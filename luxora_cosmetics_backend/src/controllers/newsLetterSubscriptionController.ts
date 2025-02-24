import { PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { HttpError } from '../core/resources/response/httpError'
import { decryptData, encryptData } from '../core/utils/utils'

const prisma = new PrismaClient()

// Subscribe a new email for the newsletter
const subscribeEmail = async (req: Request, res: Response) => {
  const { language, email } = req.body

  try {
    // Validate input
    if (!email) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Check for uniqueness of email
    const existingEmail = await prisma.newsletterSubscription.findUnique({
      where: { encryptedEmail: email },
    })

    if (existingEmail) {
      throw new HttpError(
        HttpStatusCode.CONFLICT,
        errorResponse(language).errorTitle.EMAIL_ALREADY_SUBSCRIBED,
        errorResponse(language).errorMessage.EMAIL_ALREADY_SUBSCRIBED
      )
    }

    // Create new newsletter subscription
    await prisma.newsletterSubscription.create({
      data: {
        encryptedEmail: encryptData(email),
      },
    })

    new CustomResponse(res).send({
      message: 'Vous avez été abonné(e) avec succès à la newsletter.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Unsubscribe an email
const unsubscribeEmail = async (req: Request, res: Response) => {
  const { language, email } = req.body

  try {
    // Check if the email exists
    const existingEmail = await prisma.newsletterSubscription.findUnique({
      where: { encryptedEmail: email },
    })

    if (!existingEmail) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Deactivate subscription
    const updatedEmail = await prisma.newsletterSubscription.update({
      where: { encryptedEmail: encryptData(email) },
      data: { active: false },
    })

    // Prepare response
    const responseEmail = {
      id: updatedEmail.id,
      email: decryptData(updatedEmail.encryptedEmail),
      active: updatedEmail.active,
      createdAt: updatedEmail.createdAt,
      updatedAt: updatedEmail.updatedAt,
    }

    // Send success response
    new CustomResponse(res).send({
      data: responseEmail,
      message: 'Vous avez été désabonné(e) avec succès de la newsletter.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get all subscribed emails
const getSubscriptions = async (req: Request, res: Response) => {
  const { language } = req.body
  const { limit = 10, page = 1 } = req.query

  const take = Number(limit) > 0 ? Number(limit) : 10
  const skip = (Number(page) - 1) * take
  let total: any = 0

  try {
    const subscriptions = await prisma.newsletterSubscription.findMany({
      where: { active: true },
      skip,
      take,
    })

    // Fetch total count
    total = await prisma.newsletterSubscription.count({
      where: { active: true },
    })

    const responseSubscriptions = subscriptions.map((subscription) => ({
      id: subscription.id,
      email: decryptData(subscription.encryptedEmail),
      active: subscription.active,
      createdAt: subscription.createdAt,
      updatedAt: subscription.updatedAt,
    }))

    // Send success response
    new CustomResponse(res).send({
      data: responseSubscriptions,
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

export { subscribeEmail, unsubscribeEmail, getSubscriptions }
