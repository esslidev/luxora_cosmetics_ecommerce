import { PrismaClient, UserPreferences } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import { HttpError } from '../core/resources/response/httpError'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import CustomResponse from '../core/resources/response/customResponse'

const prisma = new PrismaClient()

const createPreferences = async (req: Request, res: Response) => {
  const { language, userId, emailNotifications } = req.body

  try {
    // Check if preferences already exist for the user
    const existingPreferences = await prisma.userPreferences.findUnique({
      where: { userId },
    })

    if (existingPreferences) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.PREFERENCES_ALREADY_EXISTS,
        errorResponse(language).errorMessage.PREFERENCES_ALREADY_EXISTS
      )
    }

    const newPreferences: UserPreferences = await prisma.userPreferences.create({
      data: {
        userId,
        emailNotifications,
      },
    })

    const responseNewPreferences = {
      userId: newPreferences.userId,
      emailNotifications: newPreferences.emailNotifications,
    }

    new CustomResponse(res).send({ data: responseNewPreferences })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getPreferences = async (req: Request, res: Response) => {
  const { language, userId } = req.body
  const { id } = req.query

  try {
    if (!id && !userId) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const preferences = await prisma.userPreferences.findUnique({
      where: id ? { id: Number(id) } : { userId },
    })

    if (!preferences) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const responsePreferences = {
      userId: preferences.userId,
      emailNotifications: preferences.emailNotifications,
    }

    new CustomResponse(res).send({ data: responsePreferences })
  } catch (error) {
    handleError(error, res, language)
  }
}

const updatePreferences = async (req: Request, res: Response) => {
  const { language, id, userId, emailNotifications } = req.body

  try {
    let existingPreferences = await prisma.userPreferences.findUnique({
      where: id ? { id } : { userId },
    })

    if (!existingPreferences) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const updatedPreferencesData = {
      ...(emailNotifications && { emailNotifications }),
    }

    const updatedPreferences = await prisma.userPreferences.update({
      where: id ? { id } : { userId },
      data: updatedPreferencesData,
    })

    const responseUpdatedPreferences = {
      userId: updatedPreferences.userId,
      emailNotifications: updatedPreferences.emailNotifications,
    }

    new CustomResponse(res).send({ data: responseUpdatedPreferences })
  } catch (error) {
    handleError(error, res, language)
  }
}

const deletePreferences = async (req: Request, res: Response) => {
  const { language, userId } = req.body

  try {
    await prisma.userPreferences.delete({
      where: {
        userId,
      },
    })

    new CustomResponse(res).send({ message: 'Preferences deleted successfully.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { createPreferences, getPreferences, updatePreferences, deletePreferences }
