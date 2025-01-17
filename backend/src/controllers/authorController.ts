import { PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { HttpError } from '../core/resources/response/httpError'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'

const prisma = new PrismaClient()

// Update author by ID
const updateAuthor = async (req: Request, res: Response) => {
  const { language, id, firstName, lastName, coverImageUrl } = req.body

  try {
    const author = await prisma.author.findUnique({ where: { id: id } })

    if (!author) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const updatedAuthor = await prisma.author.update({
      where: { id: id },
      data: {
        ...(firstName && { firstName }),
        ...(lastName && { lastName }),
        ...(coverImageUrl && { coverImageUrl }),
      },
    })

    // Prepare the response
    const responseUpdatedAuthor = {
      id: updatedAuthor.id,
      firstName: updatedAuthor.firstName,
      lastName: updatedAuthor.lastName,
      coverImageUrl: updatedAuthor.coverImageUrl,
    }

    new CustomResponse(res).send({
      data: responseUpdatedAuthor,
      message: 'Author data successfully updated.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Soft delete author by ID (mark as inactive instead of actual deletion)
const deleteAuthor = async (req: Request, res: Response) => {
  const { language, id } = req.body

  try {
    const author = await prisma.author.findUnique({ where: { id } })

    if (!author) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Use another mechanism like a `deleted` flag if you want to soft delete instead of deleting permanently
    await prisma.author.delete({ where: { id } })

    new CustomResponse(res).send({ message: 'Author deleted successfully.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get author by ID
const getAuthor = async (req: Request, res: Response) => {
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

    const author = await prisma.author.findUnique({
      where: { id: Number(id) },
      include: { products: true },
    })

    if (!author) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Prepare the response
    const responseAuthor = {
      id: author.id,
      firstName: author.firstName,
      lastName: author.lastName,
      coverImageUrl: author.coverImageUrl,
    }

    new CustomResponse(res).send({ data: responseAuthor })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getAuthors = async (req: Request, res: Response) => {
  const { language } = req.body
  const { search, isAuthorOfMonth, isFeaturedAuthor, orderByName } = req.query

  try {
    const filters: string[] = []
    const searchFilters: string[] = []

    // Search filtering
    if (search) {
      searchFilters.push(`CONCAT(a.firstName, ' ', a.lastName) LIKE '%${search}%'`)
    }

    // authorOfMonth filter
    if (isAuthorOfMonth === 'true') {
      filters.push(`a.authorOfMonth = true`)
    }

    // featuredAuthor filter
    if (isFeaturedAuthor === 'true') {
      filters.push(`a.featuredAuthor = true`)
    }

    // Combine the filters (including search) into one string, if any filters exist
    const combinedFilters = [...filters, ...searchFilters].filter(Boolean).join(' AND ')

    // Filter by the order of name
    let orderBy = ''
    if (orderByName === 'true') {
      orderBy = `ORDER BY a.firstName ASC`
    }

    // Raw query to fetch authors
    const authors: any[] = await prisma.$queryRawUnsafe(`
      SELECT a.id, a.firstName, a.lastName, a.coverImageUrl
      FROM Author a
      ${combinedFilters ? `WHERE ${combinedFilters}` : ''}
      ${orderBy}
    `)

    // Map authors to the desired response format
    const responseAuthors = authors.map((author) => ({
      id: author.id,
      firstName: author.firstName,
      lastName: author.lastName,
      coverImageUrl: author.coverImageUrl,
    }))

    // Send the response
    new CustomResponse(res).send({
      data: responseAuthors,
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { updateAuthor, deleteAuthor, getAuthor, getAuthors }
