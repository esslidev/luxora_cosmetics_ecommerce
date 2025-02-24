import { PrismaClient, Content } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { HttpError } from '../core/resources/response/httpError'

const prisma = new PrismaClient()

// Create new content
const createContent = async (req: Request, res: Response) => {
  const { language, title, authorId, type, content } = req.body

  try {
    // Validate input
    if (!title || !authorId || !type || !content) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Create new content
    const newContent = await prisma.content.create({
      data: {
        title,
        authorId,
        type,
        content,
      },
      include: {
        author: true,
      },
    })

    const responseNewContent = {
      id: newContent.id,
      title: newContent.title,
      content: newContent.content,
      type: newContent.type,
      author: newContent.author
        ? {
            id: newContent.author.id,
            firstName: newContent.author.firstName,
            lastName: newContent.author.lastName,
            coverImageUrl: newContent.author.coverImageUrl,
            authorOfMonth: newContent.author.authorOfMonth,
            featuredAuthor: newContent.author.featuredAuthor,
          }
        : undefined,
    }

    // Send success response
    new CustomResponse(res).send({ data: responseNewContent })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Update content
const updateContent = async (req: Request, res: Response) => {
  const { language, id, title, authorId, type, content } = req.body

  try {
    // Validate input
    if (!id) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Check if content exists
    const existingContent = await prisma.content.findUnique({
      where: { id: Number(id) },
    })

    if (!existingContent) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Update content
    const updatedContent = await prisma.content.update({
      where: { id: Number(id) },
      data: {
        ...(title && { title }),
        ...(authorId && { authorId }),
        ...(type && { type }),
        ...(content && { content }),
      },
      include: {
        author: true,
      },
    })

    const responseUpdatedContent = {
      id: updatedContent.id,
      title: updatedContent.title,
      content: updatedContent.content,
      type: updatedContent.type,
      author: updatedContent.author
        ? {
            id: updatedContent.author.id,
            firstName: updatedContent.author.firstName,
            lastName: updatedContent.author.lastName,
            coverImageUrl: updatedContent.author.coverImageUrl,
            authorOfMonth: updatedContent.author.authorOfMonth,
            featuredAuthor: updatedContent.author.featuredAuthor,
          }
        : undefined,
    }

    // Send success response
    new CustomResponse(res).send({ data: responseUpdatedContent })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Delete content
const deleteContent = async (req: Request, res: Response) => {
  const { language, id } = req.body

  try {
    // Validate input
    if (!id) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Delete content
    await prisma.content.delete({
      where: { id: Number(id) },
    })

    // Send success response
    new CustomResponse(res).send({ message: 'Content removed successfully.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get a single content by ID
const getContent = async (req: Request, res: Response) => {
  const { language } = req.body
  const { id } = req.query

  try {
    // Validate input
    if (!id) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Fetch content by ID
    const content = await prisma.content.findUnique({
      where: { id: Number(id) },
      include: { author: true },
    })

    // Check if content exists
    if (!content) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Format the response
    const responseContent = {
      id: content.id,
      title: content.title,
      content: content.content,
      type: content.type,
      author: content.author
        ? {
            id: content.author.id,
            firstName: content.author.firstName,
            lastName: content.author.lastName,
            coverImageUrl: content.author.coverImageUrl,
            authorOfMonth: content.author.authorOfMonth,
            featuredAuthor: content.author.featuredAuthor,
          }
        : undefined,
    }

    // Send success response
    new CustomResponse(res).send({ data: responseContent })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get all content
const getContents = async (req: Request, res: Response) => {
  const { language } = req.body
  const { limit = 10, page = 1, type, authorId, orderByAuthorName, orderByCreatedDate, sortOrder = 'asc' } = req.query

  const take = Number(limit) > 0 ? Number(limit) : 10
  const skip = (Number(page) - 1) * take
  let total: any = 0

  try {
    // Define filters for fetching content
    const filters: any = {}
    filters.isPublished = 'true'

    // Filter by type if provided
    if (type) {
      filters.type = String(type)
    }

    // Filter by authorId if provided
    if (authorId) {
      filters.authorId = Number(authorId)
    }

    // Define orderBy based on query parameters
    const orderBy: any = []

    // Order by author name if orderByAuthorName is true
    if (orderByAuthorName === 'true') {
      orderBy.push({
        author: {
          name: sortOrder,
        },
      })
    }

    // Order by created date if orderByCreatedDate is true
    if (orderByCreatedDate === 'true') {
      orderBy.push({
        createdAt: sortOrder,
      })
    }

    // Fetch contents with filters and ordering applied
    const contents = await prisma.content.findMany({
      where: filters,
      orderBy: orderBy.length > 0 ? orderBy : undefined,
      skip,
      take,
      include: { author: true },
    })

    // Fetch total count for pagination (without applying filters or pagination)
    total = await prisma.content.count({
      where: filters,
    })

    const responseContents = await Promise.all(
      contents.map(async (content) => ({
        id: content.id,
        title: content.title,
        content: content.content,
        type: content.type,
        author: content.author
          ? {
              id: content.author.id,
              firstName: content.author.firstName,
              lastName: content.author.lastName,
              coverImageUrl: content.author.coverImageUrl,
              authorOfMonth: content.author.authorOfMonth,
              featuredAuthor: content.author.featuredAuthor,
            }
          : undefined,
      }))
    )

    // Send success response
    new CustomResponse(res).send({
      data: responseContents,
      pagination: {
        limit: Number(limit),
        total: Number(total),
        page: Number(page),
        pages: Math.ceil(Number(total) / take),
      },
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { createContent, updateContent, deleteContent, getContent, getContents }
