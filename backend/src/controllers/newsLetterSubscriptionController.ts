import { PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { HttpError } from '../core/resources/response/httpError'

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
    const newSubscription = await prisma.newsletterSubscription.create({
      data: {
        encryptedEmail: email,
      },
    })

    // Prepare response
    const responseEmail = {
      id: newSubscription.id,
      email: newSubscription.encryptedEmail,
      active: newSubscription.active,
    }

    // Send success response
    new CustomResponse(res).send({ data: responseEmail })
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
      where: { encryptedEmail: email },
      data: { active: false },
    })

    // Prepare response
    const responseEmail = {
      id: updatedEmail.id,
      email: updatedEmail.encryptedEmail,
      active: updatedEmail.active,
    }

    // Send success response
    new CustomResponse(res).send({ data: responseEmail })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get all subscribed emails
const getSubscribedEmails = async (req: Request, res: Response) => {
  const { language } = req.body
  try {
    const subscribedEmails = await prisma.newsletterSubscription.findMany({
      where: { active: true }, // Only fetch active subscriptions
    })

    const responseEmails = subscribedEmails.map((sub) => ({
      id: sub.id,
      email: sub.encryptedEmail,
      active: sub.active,
      createdAt: sub.createdAt,
      updatedAt: sub.updatedAt,
    }))

    // Send success response
    new CustomResponse(res).send({ data: responseEmails })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { subscribeEmail, unsubscribeEmail, getSubscribedEmails }
