import { PrismaClient, Review } from '@prisma/client'
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
        errorResponse(language).errorTitle.CATEGORY_ALREADY_EXISTS,
        errorResponse(language).errorMessage.CATEGORY_ALREADY_EXISTS
      )
    }

    // Clamp rating between 0 and 4
    const clampedRating = Math.max(0, Math.min(4, rating))

    const newReview: Review = await prisma.review.create({
      data: {
        productId,
        userId,
        text,
        rating: clampedRating,
      },
    })

    const responseNewReview = {
      id: newReview.id,
      productId: newReview.productId,
      userId: newReview.userId,
      text: newReview.text,
      rating: newReview.rating,
      isPublic: newReview.isPublic,
      createdAt: newReview.createdAt,
      updatedAt: newReview.updatedAt,
    }

    new CustomResponse(res).send({ data: responseNewReview })
  } catch (error) {
    handleError(error, res, language)
  }
}

const updateReview = async (req: Request, res: Response) => {
  const { language, id, text, rating, isPublic } = req.body

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
      where: { id: Number(id) },
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
      where: { id: Number(id) },
      data: {
        ...(text !== undefined && { text }),
        ...(clampedRating !== undefined && { rating: clampedRating }),
        ...(isPublic !== undefined && { isPublic }),
      },
    })

    // Structure the response
    const responseUpdatedReview = {
      id: updatedReview.id,
      productId: updatedReview.productId,
      userId: updatedReview.userId,
      text: updatedReview.text,
      rating: updatedReview.rating,
      isPublic: updatedReview.isPublic,
      createdAt: updatedReview.createdAt,
      updatedAt: updatedReview.updatedAt,
    }

    new CustomResponse(res).send({ data: responseUpdatedReview })
  } catch (error) {
    handleError(error, res, language)
  }
}

const deleteReview = async (req: Request, res: Response) => {
  const { language, id } = req.body

  try {
    const existingReview = await prisma.review.findUnique({
      where: { id: Number(id) },
    })

    if (!existingReview) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    await prisma.review.delete({
      where: { id: Number(id) },
    })

    new CustomResponse(res).send({
      message: 'Review deleted successfully.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getReviews = async (req: Request, res: Response) => {
  const { language } = req.body
  const { productId, userId, showPublicOnly } = req.query

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
        ...(productId ? { productId: Number(productId) } : {}),
        ...(userId ? { userId: Number(userId) } : {}),
        ...(showPublicOnly ? { isPublic: true } : {}),
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
                isVerified: true,
              },
            }
          : false,
        product: userId
          ? {
              select: {
                id: true,
                Art_Ean13: true,
                Art_Titre: true,
                Art_Image_Url: true,
                author: true,
              },
            }
          : false,
      },
    })

    const responseReviews = reviews.map((review) => ({
      id: review.id,
      productId: review.productId,
      userId: review.userId,
      text: review.text,
      rating: review.rating,
      isPublic: review.isPublic,
      createdAt: review.createdAt,
      updatedAt: review.updatedAt,
      user: review.user
        ? {
            isAdmin: review.user.isAdmin,
            firstName: review.user.encryptedFirstName ? decryptData(review.user.encryptedFirstName) : null,
            lastName: review.user.encryptedLastName ? decryptData(review.user.encryptedLastName) : null,
            email: review.user.encryptedEmail ? decryptData(review.user.encryptedEmail) : null,
          }
        : undefined,
      product: review.product
        ? {
            Art_Ean13: review.product.Art_Ean13,
            Art_Titre: review.product.Art_Titre,
            Art_Image_Url: review.product.Art_Image_Url,
            ////////// author
          }
        : undefined,
    }))

    new CustomResponse(res).send({ data: responseReviews })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { createReview, updateReview, deleteReview, getReviews }
