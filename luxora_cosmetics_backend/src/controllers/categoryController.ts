import { Category, CategoryTranslation, PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { HttpError } from '../core/resources/response/httpError'

const prisma = new PrismaClient()

// Create a new category
const createCategory = async (req: Request, res: Response) => {
  const { language, parentId, categoryNumber, isPublic, promoPercent, translations } = req.body

  try {
    // Validate input
    if (categoryNumber!) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Check for uniqueness of category name
    const existingCategory = await prisma.category.findFirst({
      where: { categoryNumber: categoryNumber },
    })

    if (existingCategory) {
      throw new HttpError(
        HttpStatusCode.CONFLICT,
        errorResponse(language).errorTitle.CATEGORY_ALREADY_EXISTS,
        errorResponse(language).errorMessage.CATEGORY_ALREADY_EXISTS
      )
    }

    // Create new category with translation
    const newCategory = await prisma.category.create({
      data: {
        parentId,
        categoryNumber,
        isPublic,
        promoPercent,
        translations: {
          create: translations.map((translation: CategoryTranslation) => ({
            languageCode: translation.languageCode,
            name: translation.name,
          })),
        },
      },
      include: { translations: true },
    })

    // Prepare response
    const responseNewCategory = {
      id: newCategory.id,
      parentId: newCategory.parentId,
      categoryNumber: newCategory.categoryNumber,
      isPublic: newCategory.isPublic,
      promoPercent: newCategory.promoPercent,
      createdAt: newCategory.createdAt,
      updatedAt: newCategory.updatedAt,
      translations: newCategory.translations.map((translation) => ({
        languageCode: translation.languageCode,
        name: translation.name,
      })),
    }

    // Send success response
    new CustomResponse(res).send({ data: responseNewCategory })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Update a category
const updateCategory = async (req: Request, res: Response) => {
  const { language, id, parentId, categoryNumber, isPublic, promoPercent, translations } = req.body

  try {
    // Validate input
    if (!id && !categoryNumber) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Check if the category exists
    const category = await prisma.category.findUnique({
      where: { id: Number(id) },
      include: { translations: true },
    })

    if (!category) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Update translations if provided
    const translationUpdates = translations
      ? translations.map((translation: { languageCode: string; name: string }) => ({
          where: { categoryId_languageCode: { categoryId: Number(id), languageCode: translation.languageCode } },
          data: { name: translation.name },
        }))
      : []

    // Perform category update
    const updatedCategory = await prisma.category.update({
      where: { id: Number(id) },
      data: {
        ...(categoryNumber !== undefined && { categoryNumber }),
        ...(parentId !== undefined && { parentId }),
        ...(promoPercent !== undefined && { promoPercent }),
        ...(isPublic !== undefined && { isPublic }),
        translations:
          translationUpdates.length > 0
            ? {
                updateMany: translationUpdates,
              }
            : undefined,
      },
      include: {
        translations: true,
        subCategories: { include: { translations: true } },
      },
    })

    // Map the updated category to the desired response structure
    const responseCategory = {
      id: updatedCategory.id,
      parentId: updatedCategory.parentId,
      categoryNumber: updatedCategory.categoryNumber,
      isPublic: updatedCategory.isPublic,
      promoPercent: updatedCategory.promoPercent,
      createdAt: updatedCategory.createdAt,
      updatedAt: updatedCategory.updatedAt,
      translations: updatedCategory.translations.map((translation) => ({
        languageCode: translation.languageCode,
        name: translation.name,
      })),
      subCategories: updatedCategory.subCategories.map((sub) => ({
        id: sub.id,
        categoryNumber: sub.categoryNumber,
        isPublic: sub.isPublic,
        promoPercent: sub.promoPercent,
        translations: sub.translations.map((translation) => ({
          languageCode: translation.languageCode,
          name: translation.name,
        })),
      })),
    }

    // Send success response
    new CustomResponse(res).send({ data: responseCategory })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Delete a category
const deleteCategory = async (req: Request, res: Response) => {
  const { language, id, categoryNumber } = req.body

  try {
    // Validate input
    if (!id && categoryNumber!) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Check for uniqueness of category name
    const category = await prisma.category.findFirst({
      where: {
        OR: [{ id }, { categoryNumber }],
      },
    })

    if (!category) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Delete category
    await prisma.category.deleteMany({
      where: {
        OR: [{ id }, { categoryNumber }],
      },
    })

    // Send success response
    new CustomResponse(res).send({ message: 'Category removed successfully.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get all categories based on level because it is recursive
const getAllCategories = async (req: Request, res: Response) => {
  const { language } = req.body
  const { level, isMainCategory } = req.query

  // Determine the maxLevel
  const maxLevel = level !== undefined ? Number(level) : Infinity

  // Validate the level parameter if it's provided
  if (level !== undefined && (!Number.isInteger(maxLevel) || maxLevel < 0)) {
    return res.status(HttpStatusCode.BAD_REQUEST).send({
      error: errorResponse(language).errorTitle.INVALID_REQUEST,
      message: errorResponse(language).errorMessage.INVALID_REQUEST,
    })
  }

  try {
    const categories = await prisma.category.findMany({
      where: isMainCategory ? { parentId: null, isPublic: true } : { isPublic: true },
      include: {
        translations: true,
      },
    })

    // Recursive function to fetch subcategories
    const fetchSubCategories = async (categoryId: number, currentLevel: number): Promise<any> => {
      if (currentLevel === 0) return []

      const subCategories = await prisma.category.findMany({
        where: { parentId: categoryId, isPublic: true },
        include: {
          translations: true,
        },
      })

      return Promise.all(
        subCategories.map(async (subCategory) => ({
          id: subCategory.id,
          categoryNumber: subCategory.categoryNumber,
          isPublic: subCategory.isPublic,
          promoPercent: subCategory.promoPercent,
          translations: subCategory.translations.map((translation) => ({
            languageCode: translation.languageCode,
            name: translation.name,
            isDefault: translation.isDefault,
          })),
          subCategories:
            currentLevel === Infinity
              ? await fetchSubCategories(subCategory.id, Infinity) // Fetch all levels
              : await fetchSubCategories(subCategory.id, currentLevel - 1), // Recursive call
        }))
      )
    }

    const responseCategories = await Promise.all(
      categories.map(async (category) => ({
        id: category.id,
        categoryNumber: category.categoryNumber,
        isPublic: category.isPublic,
        promoPercent: category.promoPercent,
        parentId: category.parentId,
        translations: category.translations.map((translation) => ({
          languageCode: translation.languageCode,
          name: translation.name,
          isDefault: translation.isDefault,
        })),
        subCategories:
          maxLevel === Infinity
            ? await fetchSubCategories(category.id, Infinity) // Fetch all levels
            : await fetchSubCategories(category.id, maxLevel), // Fetch up to specified level
      }))
    )

    // Send success response
    new CustomResponse(res).send({ data: responseCategories })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get main categories based on ids or categoryNumbers
const getParentCategories = async (req: Request, res: Response) => {
  const { language } = req.body
  const { ids, categoryNumbers } = req.query

  try {
    // Ensure at least one of `ids` or `categoryNumbers` is provided
    if (!ids && !categoryNumbers) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    let categoryIds: number[] = []
    let categoryNumArr: number[] = []

    // Parse `ids` if provided
    if (ids) {
      categoryIds = (ids as string).split('_').map((id) => {
        const parsedId = Number(id)
        if (isNaN(parsedId)) {
          throw new HttpError(
            HttpStatusCode.BAD_REQUEST,
            errorResponse(language).errorTitle.INVALID_REQUEST,
            errorResponse(language).errorMessage.INVALID_REQUEST
          )
        }
        return parsedId
      })
    }

    // Parse `categoryNumbers` if provided
    if (categoryNumbers) {
      categoryNumArr = (categoryNumbers as string).split('_').map((num) => {
        const parsedNum = Number(num)
        if (isNaN(parsedNum)) {
          throw new HttpError(
            HttpStatusCode.BAD_REQUEST,
            errorResponse(language).errorTitle.INVALID_REQUEST,
            errorResponse(language).errorMessage.INVALID_REQUEST
          )
        }
        return parsedNum
      })
    }

    // Query the initial categories based on `categoryIds` or `categoryNumArr`
    const categories = await prisma.category.findMany({
      where: {
        OR: [{ id: { in: categoryIds } }, { categoryNumber: { in: categoryNumArr } }],
      },
    })

    if (categories.length === 0) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Recursive function to find the top-level parent
    const findTopLevelParent = async (category: any): Promise<any> => {
      while (category.parentId) {
        category = await prisma.category.findUnique({
          where: { id: category.parentId },
        })
      }
      return category
    }

    // Traverse the hierarchy for each category and find the top-level parent
    const topLevelParents = await Promise.all(categories.map(async (category) => findTopLevelParent(category)))

    // Remove duplicates (if multiple categories share the same parent)
    const uniqueTopLevelParents = Array.from(
      new Map(topLevelParents.map((category) => [category.id, category])).values()
    )

    // Fetch translations for the top-level parents
    const mainCategories = await prisma.category.findMany({
      where: {
        id: { in: uniqueTopLevelParents.map((parent) => parent.id) },
      },
      include: {
        translations: true,
      },
    })

    // Format the response
    const formattedCategories = mainCategories.map((category) => ({
      id: category.id,
      parentId: category.parentId,
      categoryNumber: category.categoryNumber,
      isPublic: category.isPublic,
      promoPercent: category.promoPercent,
      translations: category.translations.map((translation) => ({
        languageCode: translation.languageCode,
        name: translation.name,
        isDefault: translation.isDefault,
      })),
    }))

    // Send success response
    new CustomResponse(res).send({ data: formattedCategories })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getCategories = async (req: Request, res: Response) => {
  const { language } = req.body
  const { ids, categoryNumbers } = req.query

  try {
    // Ensure at least one of `ids` or `categoryNumbers` is provided
    if (!ids && !categoryNumbers) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    let categoryIds: number[] = []
    let categoryNumArr: number[] = []

    // Parse `ids` if provided
    if (ids) {
      const idString = ids as string
      categoryIds = idString.split('_').map((id) => {
        const parsedId = Number(id)
        if (isNaN(parsedId)) {
          throw new HttpError(
            HttpStatusCode.BAD_REQUEST,
            errorResponse(language).errorTitle.INVALID_REQUEST,
            errorResponse(language).errorMessage.INVALID_REQUEST
          )
        }
        return parsedId
      })
    }

    // Parse `categoryNumbers` if provided
    if (categoryNumbers) {
      const categoryNumberString = categoryNumbers as string
      categoryNumArr = categoryNumberString.split('_').map((num) => {
        const parsedNum = Number(num)
        if (isNaN(parsedNum)) {
          throw new HttpError(
            HttpStatusCode.BAD_REQUEST,
            errorResponse(language).errorTitle.INVALID_REQUEST,
            errorResponse(language).errorMessage.INVALID_REQUEST
          )
        }
        return parsedNum
      })
    }

    // Build OR conditions array without undefined values
    const orConditions = []
    if (categoryIds.length > 0) {
      orConditions.push({ id: { in: categoryIds } })
    }
    if (categoryNumArr.length > 0) {
      orConditions.push({ categoryNumber: { in: categoryNumArr } })
    }

    // Fetch categories based on either `id` or `categoryNumber` that are also public
    const categories = await prisma.category.findMany({
      where: {
        AND: [
          { isPublic: true }, // Ensure only public categories are fetched
          { OR: orConditions },
        ],
      },
      include: {
        subCategories: {
          where: {
            isPublic: true,
          },
        },
        translations: true,
      },
    })

    if (!categories || categories.length === 0) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Map categories to the desired response format
    const responseCategories = categories.map((category) => ({
      id: category.id,
      categoryNumber: category.categoryNumber,
      parentId: category.parentId,
      translations:
        category.translations.map((translation) => ({
          languageCode: translation.languageCode,
          name: translation.name,
        })) || [], // Safely access translations
    }))

    // Reorder response to match the order of requested IDs or categoryNumbers if both are not provided
    const orderedCategories =
      categoryIds.length > 0
        ? categoryIds.map((id) => responseCategories.find((cat) => cat.id === id)).filter(Boolean)
        : categoryNumArr.map((num) => responseCategories.find((cat) => cat.categoryNumber === num)).filter(Boolean)

    // Send success response
    new CustomResponse(res).send({ data: orderedCategories })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get a single category by ID or category number
const getCategory = async (req: Request, res: Response) => {
  const { language } = req.body
  const { id, categoryNumber, level } = req.query

  try {
    // Validate inputs
    if (!id && !categoryNumber) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Determine the maximum level of subcategories to fetch
    const maxLevel = level !== undefined ? Number(level) : Infinity
    if (level !== undefined && (!Number.isInteger(maxLevel) || maxLevel < 0)) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Fetch the category based on either ID or categoryNumber
    const category = await prisma.category.findFirst({
      where: id ? { id: Number(id), isPublic: true } : { categoryNumber: Number(categoryNumber), isPublic: true },
      include: {
        translations: true,
      },
    })

    if (!category) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Recursive function to fetch subcategories
    const fetchSubCategories = async (categoryId: number, currentLevel: number): Promise<any[]> => {
      if (currentLevel === 0) return []

      const subCategories = await prisma.category.findMany({
        where: { parentId: categoryId, isPublic: true },
        include: {
          translations: true,
        },
      })

      return Promise.all(
        subCategories.map(async (subCategory) => ({
          id: subCategory.id,
          categoryNumber: subCategory.categoryNumber,
          isPublic: subCategory.isPublic,
          promoPercent: subCategory.promoPercent,
          translations: subCategory.translations.map((translation) => ({
            languageCode: translation.languageCode,
            name: translation.name,
            isDefault: translation.isDefault,
          })),
          subCategories:
            currentLevel === Infinity
              ? await fetchSubCategories(subCategory.id, Infinity) // Fetch all levels
              : await fetchSubCategories(subCategory.id, currentLevel - 1), // Recursive call
        }))
      )
    }

    // Build the response for the category with subcategories
    const responseCategory = {
      id: category.id,
      categoryNumber: category.categoryNumber,
      isPublic: category.isPublic,
      promoPercent: category.promoPercent,
      parentId: category.parentId,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      translations: category.translations.map((translation) => ({
        languageCode: translation.languageCode,
        name: translation.name,
        isDefault: translation.isDefault,
      })),
      subCategories:
        maxLevel === Infinity
          ? await fetchSubCategories(category.id, Infinity) // Fetch all levels
          : await fetchSubCategories(category.id, maxLevel), // Fetch up to specified level
    }

    // Send the success response
    new CustomResponse(res).send({ data: responseCategory })
  } catch (error) {
    handleError(error, res, language)
  }
}

export {
  createCategory,
  updateCategory,
  deleteCategory,
  getAllCategories,
  getParentCategories,
  getCategories,
  getCategory,
}
