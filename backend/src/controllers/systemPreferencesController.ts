import { PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'

const prisma = new PrismaClient()

// Update preferences
const updateSystemPreferences = async (req: Request, res: Response) => {
  const { language, showcaseType, showMessages } = req.body

  try {
    // Retrieve existing system preferences or create one if not exists
    let systemPreferences = await prisma.systemPreferences.findFirst()

    if (!systemPreferences) {
      systemPreferences = await prisma.systemPreferences.create({
        data: {
          showcaseType: showcaseType,
          showMessages: showMessages,
        },
      })
    } else {
      // Update system preferences if they already exist
      systemPreferences = await prisma.systemPreferences.update({
        where: { id: systemPreferences.id },
        data: {
          ...(showcaseType && { showcaseType }),
          ...(showMessages !== undefined && { showMessages }),
        },
      })
    }

    // Prepare response
    const responsePreferences = {
      id: systemPreferences.id,
      showcaseType: systemPreferences.showcaseType,
      showMessages: systemPreferences.showMessages,
    }

    // Send success response
    new CustomResponse(res).send({ data: responsePreferences })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Retrieve current system preferences
const getSystemPreferences = async (req: Request, res: Response) => {
  const { language } = req.body
  try {
    // Retrieve the system preferences or create one if not found
    let systemPreferences = await prisma.systemPreferences.findFirst()

    if (!systemPreferences) {
      systemPreferences = await prisma.systemPreferences.create({
        data: {
          showcaseType: 'TRIPLE', // Provide defaults when creating new
          showMessages: true,
        },
      })
    }

    // Prepare response
    const responsePreferences = {
      id: systemPreferences.id,
      showcaseType: systemPreferences.showcaseType,
      showMessages: systemPreferences.showMessages,
    }

    // Send success response
    new CustomResponse(res).send({ data: responsePreferences })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { updateSystemPreferences, getSystemPreferences }
