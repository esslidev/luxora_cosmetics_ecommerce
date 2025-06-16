import { OrderStatus, PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { HttpError } from '../core/resources/response/httpError'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { isPublic } from 'ip'

const prisma = new PrismaClient()
const createProduct = async (req: Request, res: Response) => {
  const {
    language,
    name,
    imageUrl,
    description,
    price,
    pricePromo,
    promoStartDate,
    promoEndDate,
    stock,
    productType,
  } = req.body

  try {

    // Convert dates to ISO-8601 format if provided
    const formattedPromoStartDate = promoStartDate ? new Date(promoStartDate).toISOString() : null
    const formattedPromoEndDate = promoEndDate ? new Date(promoEndDate).toISOString() : null

    // Create the main product
    const newProduct = await prisma.product.create({
      data: {
        name,
        imageUrl,
        description,
        price,
        pricePromo,
        promoStartDate:formattedPromoStartDate,
        promoEndDate:formattedPromoEndDate,
       stock,
        productType,     
      },
    })

    // Prepare the response
    const responseNewProduct = {
      id: newProduct.id,
      name: newProduct.name,
      imageUrl: newProduct.imageUrl,
      description: newProduct.description,
      price: newProduct.price,
      pricePromo: newProduct.pricePromo,
      promoStartDate: newProduct.promoStartDate,
      promoEndDate: newProduct.promoEndDate,
      stock: newProduct.stock,
      productType: newProduct.productType,
    }

    new CustomResponse(res).send({ data: responseNewProduct })
  } catch (error) {
    handleError(error, res, language)
  }
}

const updateProduct = async (req: Request, res: Response) => {
  const {
    language,
    id,
    name,
    imageUrl,
    description,
    price,
    pricePromo,
    promoStartDate,
    promoEndDate,
    stock,
    productType,
  } = req.body

  try {
    // Validate input
    if (!id) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    const product = await prisma.product.findFirst({
      where: {
        id,
      },
    })

    if (!product) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Convert dates to ISO-8601 format if provided
    const formattedPromoStartDate = promoStartDate ? new Date(promoStartDate).toISOString() : null
    const formattedPromoEndDate = promoEndDate ? new Date(promoEndDate).toISOString() : null

    const updatedData = {
      ...(name && { name }),
      ...(imageUrl && { imageUrl }),
      ...(description && { description }),
      ...(price && { price }),
      ...(pricePromo && { pricePromo }),
      ...(promoStartDate && { formattedPromoStartDate }),
      ...(promoEndDate && { formattedPromoEndDate }),
      ...(stock && { stock }),
      ...(productType && { productType }),
    }

    // Update the product
    const updatedProduct = await prisma.product.update({
      where: { id },
      data: updatedData,
    })

    // Prepare the response
    const responseUpdatedProduct = {
      id: updatedProduct.id,
      name: updatedProduct.name,
      imageUrl: updatedProduct.imageUrl,
      description: updatedProduct.description,
      price: updatedProduct.price,
      pricePromo: updatedProduct.pricePromo,
      promoStartDate: updatedProduct.promoStartDate,
      promoEndDate: updatedProduct.promoEndDate,
      stock: updatedProduct.stock,
      productType: updatedProduct.productType,
    }

    new CustomResponse(res).send({ data: responseUpdatedProduct })
  } catch (error) {
    handleError(error, res, language)
  }
}

const deleteProduct = async (req: Request, res: Response) => {
  const { id, language } = req.body

  try {
    // Validate input
    if (!id) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    const product = await prisma.product.findFirst({
      where: {
        id,
      },
    })

    if (!product) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    await prisma.product.deleteMany({
      where: {
        id,
      },
    })

    new CustomResponse(res).send({ message: 'Produit supprimé avec succès.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getProduct = async (req: Request, res: Response) => {
  const { language } = req.body
  const { id } = req.query

  try {
    if (!id) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    const product = await prisma.product.findUnique({
      where: { id: id.toString(), isPublic: true },
      include: {
        reviews: { where: { isPublic: true } },
      },
    })

    if (!product) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const ratingCount = product.reviews.length
    const ratingAverage =
      ratingCount > 0 ? product.reviews.reduce((sum, review) => sum + review.rating, 0) / ratingCount : 0
 

    const responseProduct = {
      id: product.id,
      name: product.name,
      imageUrl: product.imageUrl,
      description: product.description,
      price: product.price,
      pricePromo: product.pricePromo,
      promoStartDate: product.promoStartDate,
      promoEndDate: product.promoEndDate,
      stock: product.stock,
      productType: product.productType,
      ratingCount,
      ratingAverage,
    }

    new CustomResponse(res).send({ data: responseProduct })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getProducts = async (req: Request, res: Response) => {
  const { language } = req.body
  const {
    limit = 10,
    page = 1,
    productIds,
    search,
  } = req.query

  const take = Number(limit) > 0 ? Number(limit) : 10
  const skip = (Number(page) - 1) * take

  const thirtyDaysAgo = new Date()
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)

  const filters: any = {
    isPublic: true,
    deletedAt: null,
  }

  if (productIds) {
    filters.id = {
      in: (productIds as string).split('_'),
    }
  }

  if (search) {
    filters.OR = [
      { id: { contains: search as string, mode: 'insensitive' } },
      { name: { contains: search as string, mode: 'insensitive' } },
    ]
  }

  try {
    const [products, total, topBestSellers] = await Promise.all([
      prisma.product.findMany({
        where: filters,
        take,
        skip,
        include: {
          reviews: { where: { isPublic: true } },
        },
        orderBy: {
          createdAt: 'desc',
        },
      }),

      prisma.product.count({
        where: filters,
      }),

      prisma.orderItem.groupBy({
        by: ['productId'],
        _count: { productId: true },
        where: {
          order: {
            status: OrderStatus.created,
          },
        },
        orderBy: {
          _count: {
            productId: 'desc',
          },
        },
        take: 10,
      }),
    ])

    // Extract top best seller IDs
    const topBestSellerIds = topBestSellers.map((item) => item.productId)

    const responseProducts = products.map((product) => {
      const ratingCount = product.reviews.length
      const ratingAverage =
        ratingCount > 0
          ? product.reviews.reduce((sum, review) => sum + review.rating, 0) / ratingCount
          : 0

      return {
        id: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        price: product.price,
        pricePromo: product.pricePromo,
        promoStartDate: product.promoStartDate,
        promoEndDate: product.promoEndDate,
        stockCount: typeof product.stock === 'number' ? product.stock : 0,
        isNewArrival: new Date(product.createdAt) >= thirtyDaysAgo,
        isBestSeller: topBestSellerIds.includes(product.id),
        ratingCount,
        ratingAverage,
      }
    })

    new CustomResponse(res).send({
      data: responseProducts,
      pagination: {
        limit: take,
        total,
        page: Number(page),
        pages: Math.ceil(total / take),
      },
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getAllProducts = async (req: Request, res: Response) => {
  const { language } = req.body
  const {
    limit = 10,
    page = 1,
    productIds,
    search,
  } = req.query

  const take = Number(limit) > 0 ? Number(limit) : 10
  const skip = (Number(page) - 1) * take

  const thirtyDaysAgo = new Date()
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)

  const filters: any = {
  }

  if (productIds) {
    filters.id = {
      in: (productIds as string).split('_'),
    }
  }

  if (search) {
    filters.OR = [
      { id: { contains: search as string, mode: 'insensitive' } },
      { name: { contains: search as string, mode: 'insensitive' } },
    ]
  }

  try {
    const [products, total, topBestSellers] = await Promise.all([
      prisma.product.findMany({
        where: filters,
        take,
        skip,
        include: {
          reviews: { where: { isPublic: true } },
        },
        orderBy: {
          createdAt: 'desc',
        },
      }),

      prisma.product.count({
        where: filters,
      }),

      prisma.orderItem.groupBy({
        by: ['productId'],
        _count: { productId: true },
        where: {
          order: {
            status: OrderStatus.created,
          },
        },
        orderBy: {
          _count: {
            productId: 'desc',
          },
        },
        take: 10,
      }),
    ])

    // Extract top best seller IDs
    const topBestSellerIds = topBestSellers.map((item) => item.productId)

    const responseProducts = products.map((product) => {
      const ratingCount = product.reviews.length
      const ratingAverage =
        ratingCount > 0
          ? product.reviews.reduce((sum, review) => sum + review.rating, 0) / ratingCount
          : 0

      return {
        id: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        price: product.price,
        pricePromo: product.pricePromo,
        promoStartDate: product.promoStartDate,
        promoEndDate: product.promoEndDate,
        stockCount: typeof product.stock === 'number' ? product.stock : 0,
        isNewArrival: new Date(product.createdAt) >= thirtyDaysAgo,
        isBestSeller: topBestSellerIds.includes(product.id),
        ratingCount,
        ratingAverage,
        isPublic: product.isPublic,
        deletedAt:product.deletedAt,
      }
    })

    new CustomResponse(res).send({
      data: responseProducts,
      pagination: {
        limit: take,
        total,
        page: Number(page),
        pages: Math.ceil(total / take),
      },
    })
  } catch (error) {
    handleError(error, res, language)
  }
}


export { createProduct, updateProduct, deleteProduct, getProduct, getProducts,getAllProducts }
