import { PrismaClient, ShowcaseMode } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'

const prisma = new PrismaClient()

// Update preferences
const updateSystemPreferences = async (req: Request, res: Response) => {
  const { language, showcaseMode, showMessages } = req.body

  try {
    let systemPreferences = await prisma.systemPreferences.upsert({
      where: { id: 1 },
      update: { ...(showcaseMode && { showcaseMode }), ...(showMessages && { showMessages }) },
      create: { id: 1 },
    })

    // Prepare response
    const responsePreferences = {
      id: systemPreferences.id,
      showcaseMode: systemPreferences.showcaseMode,
      showMessages: systemPreferences.showMessages,
    }

    // Send success response
    new CustomResponse(res).send({
      data: responsePreferences,
      message: 'Les préférences système ont été mises à jour avec succès.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Retrieve current system preferences
const getSystemPreferences = async (req: Request, res: Response) => {
  const { language } = req.body
  try {
    let systemPreferences = await prisma.systemPreferences.upsert({
      where: { id: 1 },
      update: {},
      create: { id: 1 },
    })

    // Prepare response
    const responsePreferences = {
      id: systemPreferences.id,
      showcaseMode: systemPreferences.showcaseMode,
      showMessages: systemPreferences.showMessages,
    }

    // Send success response
    new CustomResponse(res).send({ data: responsePreferences })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { updateSystemPreferences, getSystemPreferences }
