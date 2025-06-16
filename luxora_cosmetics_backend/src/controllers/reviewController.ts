import { PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import { HttpError } from '../core/resources/response/httpError'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import CustomResponse from '../core/resources/response/customResponse'
import { decryptData } from '../core/utils/utils'

const prisma = new PrismaClient()

const createReview = async (req: Request, res: Response) => {
  const { language, productId, userId, text, rating } = req.body

  try {
    // Validate input
    if (!productId && !userId) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Check if a review by the same user for the same product already exists
    const existingReview = await prisma.review.findUnique({
      where: {
        productId_userId: {
          productId: productId,
          userId: userId,
        },
      },
    })

    if (existingReview) {
      throw new HttpError(
        HttpStatusCode.CONFLICT,
        errorResponse(language).errorTitle.REVIEW_ALREADY_SENT,
        errorResponse(language).errorMessage.REVIEW_ALREADY_SENT
      )
    }

    // Clamp rating between 1 and 5
    const clampedRating = Math.max(1, Math.min(5, rating))

    const newReview = await prisma.review.create({
      data: {
        productId,
        userId,
        text,
        rating: clampedRating,
      },
      include: {
        user: {
          select: {
            id: true,
            encryptedFirstName: true,
            encryptedLastName: true,
            encryptedEmail: true,
            isAdmin: true,
          },
        },
        product: {
          select: {
            id: true,
            name: true,
            imageUrl: true,          
          },
        },
      },
    })

    const responseNewReview = {
      id: newReview.id,
      text: newReview.text,
      rating: newReview.rating,
      isPublic: newReview.isPublic,
      isApproved: newReview.isApproved,
      user: newReview.user
        ? {
            id: newReview.user.id,
            isAdmin: newReview.user.isAdmin,
            firstName: newReview.user.encryptedFirstName ? decryptData(newReview.user.encryptedFirstName) : null,
            lastName: newReview.user.encryptedLastName ? decryptData(newReview.user.encryptedLastName) : null,
            email: newReview.user.encryptedEmail ? decryptData(newReview.user.encryptedEmail) : null,
          }
        : undefined,
      product: newReview.product
        ? {
            id: newReview.product.id,
            name: newReview.product.name,
            imageUrl: newReview.product.imageUrl,
            ////////// author
          }
        : undefined,
      createdAt: newReview.createdAt,
      updatedAt: newReview.updatedAt,
    }

    new CustomResponse(res).send({ data: responseNewReview })
  } catch (error) {
    handleError(error, res, language)
  }
}

const updateReview = async (req: Request, res: Response) => {
  const { language, id, text, rating } = req.body

  try {
    // Validate that the review ID is provided
    if (!id) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Check if the review exists
    const existingReview = await prisma.review.findUnique({
      where: { id: id },
    })

    if (!existingReview) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Clamp rating between 0 and 4 if provided
    const clampedRating = rating !== undefined ? Math.max(0, Math.min(4, rating)) : undefined

    // Perform review update
    const updatedReview = await prisma.review.update({
      where: { id: id },
      data: {
        ...(text !== undefined && { text }),
        ...(clampedRating !== undefined && { rating: clampedRating }),
      },
      include: {
        user: {
          select: {
            id: true,
            encryptedFirstName: true,
            encryptedLastName: true,
            encryptedEmail: true,
            isAdmin: true,
          },
        },
        product: {
          select: {
            id: true,
            name: true,
            imageUrl: true,
          },
        },
      },
    })

    // Structure the response
    const responseUpdatedReview = {
      id: updatedReview.id,
      text: updatedReview.text,
      rating: updatedReview.rating,
      isPublic: updatedReview.isPublic,
      isApproved: updatedReview.isApproved,
      user: updatedReview.user
        ? {
            id: updatedReview.user.id,
            isAdmin: updatedReview.user.isAdmin,
            firstName: updatedReview.user.encryptedFirstName
              ? decryptData(updatedReview.user.encryptedFirstName)
              : null,
            lastName: updatedReview.user.encryptedLastName ? decryptData(updatedReview.user.encryptedLastName) : null,
            email: updatedReview.user.encryptedEmail ? decryptData(updatedReview.user.encryptedEmail) : null,
          }
        : undefined,
      product: updatedReview.product
        ? {
            id: updatedReview.product.id,
            name: updatedReview.product.name,         
            imageUrl: updatedReview.product.imageUrl,
            ////////// author
          }
        : undefined,
      createdAt: updatedReview.createdAt,
      updatedAt: updatedReview.updatedAt,
    }

    new CustomResponse(res).send({ data: responseUpdatedReview })
  } catch (error) {
    handleError(error, res, language)
  }
}

const setReviewApproval = async (req: Request, res: Response) => {
  const { language, id, isApproved } = req.body

  try {
    // Validate that the review ID and approval status are provided
    if (id === undefined || isApproved === undefined) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Check if the review exists
    const existingReview = await prisma.review.findUnique({
      where: { id: id },
    })

    if (!existingReview) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Update the review to set the specified approval status
    const updatedReview = await prisma.review.update({
      where: { id: id },
      data: { isApproved },
      include: {
        user: {
          select: {
            id: true,
            encryptedFirstName: true,
            encryptedLastName: true,
            encryptedEmail: true,
            isAdmin: true,
          },
        },
        product: {
          select: {
            id: true,
            name: true,
            imageUrl: true,        
          },
        },
      },
    })

    // Structure the response
    const responseReview = {
      id: updatedReview.id,
      text: updatedReview.text,
      rating: updatedReview.rating,
      isPublic: updatedReview.isPublic,
      isApproved: updatedReview.isApproved,
      user: updatedReview.user
        ? {
            id: updatedReview.user.id,
            isAdmin: updatedReview.user.isAdmin,
            firstName: updatedReview.user.encryptedFirstName
              ? decryptData(updatedReview.user.encryptedFirstName)
              : null,
            lastName: updatedReview.user.encryptedLastName ? decryptData(updatedReview.user.encryptedLastName) : null,
            email: updatedReview.user.encryptedEmail ? decryptData(updatedReview.user.encryptedEmail) : null,
          }
        : undefined,
      product: updatedReview.product
        ? {
            id: updatedReview.product.id,
            name: updatedReview.product.name,
            imageUrl: updatedReview.product.imageUrl,
          }
        : undefined,
      createdAt: updatedReview.createdAt,
      updatedAt: updatedReview.updatedAt,
    }

    // Send a custom response with the message depending on approval status
    const successMessage = isApproved ? "L'avis a été approuvé avec succès." : "L'avis a été désapprouvé avec succès."

    new CustomResponse(res).send({
      data: responseReview,
      message: successMessage,
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

const deleteReview = async (req: Request, res: Response) => {
  const { language, id } = req.body

  try {
    const existingReview = await prisma.review.findUnique({
      where: { id: id },
    })

    if (!existingReview) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    await prisma.review.delete({
      where: { id: id },
    })

    new CustomResponse(res).send({
      message: 'Avis supprimé avec succès.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getApprovedReviews = async (req: Request, res: Response) => {
  const { language } = req.body
  const { productId, userId } = req.query

  try {
    // Validate that either `productId` or `userId` is provided
    if (!productId && !userId) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }
    const reviews = await prisma.review.findMany({
      where: {
        isPublic: true,
        OR: [
          {
            isApproved: true, // Approved reviews
          },
          {
            user: {
              isAdmin: true, // Admin reviews
            },
          },
        ],
        ...(productId ? { productId: productId.toString() } : {}),
        ...(userId ? { userId: userId.toString() } : {}),
      },
      include: {
        user: productId
          ? {
              select: {
                id: true,
                encryptedFirstName: true,
                encryptedLastName: true,
                encryptedEmail: true,
                isAdmin: true,
              },
            }
          : false,
        product: userId
          ? {
              select: {
                id: true,
                name: true,
                imageUrl: true,
              },
            }
          : false,
      },
    })

    const responseReviews = reviews.map((review) => ({
      id: review.id,
      text: review.text,
      rating: review.rating,
      isPublic: review.isPublic,
      isApproved: review.isApproved,
      createdAt: review.createdAt,
      updatedAt: review.updatedAt,
      user: review.user
        ? {
            id: review.user.id,
            isAdmin: review.user.isAdmin,
            firstName: review.user.encryptedFirstName ? decryptData(review.user.encryptedFirstName) : null,
            lastName: review.user.encryptedLastName ? decryptData(review.user.encryptedLastName) : null,
            email: review.user.encryptedEmail ? decryptData(review.user.encryptedEmail) : null,
          }
        : undefined,
      product: review.product
        ? {
            id: review.product.id,
            name: review.product.name,
            imageUrl: review.product.imageUrl,
            ////////// author
          }
        : undefined,
    }))

    new CustomResponse(res).send({ data: responseReviews })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getReviews = async (req: Request, res: Response) => {
  const { language } = req.body
  const { limit = 10, page = 1, showOnlyApproved, showOnlyUnApproved } = req.query

  const take = Number(limit) > 0 ? Number(limit) : 10
  const skip = (Number(page) - 1) * take
  let total: any = 0

  try {
    // Set up filter conditions
    const filterConditions: any = {
      isPublic: true,
    }

    if (showOnlyApproved === 'true') {
      filterConditions.OR = [{ isApproved: true }, { user: { isAdmin: true } }]
    } else if (showOnlyUnApproved === 'true') {
      filterConditions.isApproved = false
      filterConditions.user = { isAdmin: false }
    }

    const reviews = await prisma.review.findMany({
      where: filterConditions,
      skip,
      take,
      orderBy: {
        createdAt: 'desc',
      },
      include: {
        user: {
          select: {
            id: true,
            encryptedFirstName: true,
            encryptedLastName: true,
            encryptedEmail: true,
            isAdmin: true,
          },
        },
        product: {
          select: {
            id: true,
            name: true,           
            imageUrl: true,
          },
        },
      },
    })

    // Fetch total count
    total = await prisma.review.count({
      where: filterConditions,
    })

    const responseReviews = reviews.map((review) => ({
      id: review.id,
      text: review.text,
      rating: review.rating,
      isPublic: review.isPublic,
      isApproved: review.isApproved,
      createdAt: review.createdAt,
      updatedAt: review.updatedAt,
      user: review.user
        ? {
            id: review.user.id,
            isAdmin: review.user.isAdmin,
            firstName: review.user.encryptedFirstName ? decryptData(review.user.encryptedFirstName) : null,
            lastName: review.user.encryptedLastName ? decryptData(review.user.encryptedLastName) : null,
            email: review.user.encryptedEmail ? decryptData(review.user.encryptedEmail) : null,
          }
        : undefined,
      product: review.product
        ? {
            id: review.product.id,
            name: review.product.name,
            imageUrl: review.product.imageUrl,
            ////////// author
          }
        : undefined,
    }))

    new CustomResponse(res).send({
      data: responseReviews,
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

export { createReview, updateReview, setReviewApproval, deleteReview, getApprovedReviews,getReviews }
