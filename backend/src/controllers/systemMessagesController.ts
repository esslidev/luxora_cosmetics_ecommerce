import { PrismaClient, SystemMessageTranslation } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { HttpError } from '../core/resources/response/httpError'

const prisma = new PrismaClient()

// Create a new system-related message with translations
const createMessage = async (req: Request, res: Response) => {
  const { language, translations, startDate, endDate, isPublic } = req.body
  try {
    if (!translations || translations.length === 0) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    const newMessage = await prisma.systemMessage.create({
      data: {
        startDate: startDate || null,
        endDate: endDate || null,
        isPublic: isPublic || true, // Default to true if not provided
        translations: {
          create: translations.map((translation: SystemMessageTranslation) => ({
            languageCode: translation.languageCode,
            message: translation.message,
          })),
        },
      },
      include: { translations: true },
    })

    // Prepare response for the newly created message
    const responseNewMessage = {
      id: newMessage.id,
      startDate: newMessage.startDate,
      endDate: newMessage.endDate,
      isPublic: newMessage.isPublic,
      translations: newMessage.translations.map((translation) => ({
        languageCode: translation.languageCode,
        message: translation.message,
      })),
    }

    new CustomResponse(res).send({ data: responseNewMessage })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Update an existing system message
const updateMessage = async (req: Request, res: Response) => {
  const { language, id, translations, startDate, endDate, isPublic } = req.body

  try {
    const existingMessage = await prisma.systemMessage.findUnique({
      where: { id: Number(id) },
      include: { translations: true }, // Include translations to check current state
    })

    if (!existingMessage) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const updatedMessage = await prisma.systemMessage.update({
      where: { id: Number(id) },
      data: {
        ...(startDate && { startDate }),
        ...(endDate && { endDate }),
        ...(typeof isPublic !== 'undefined' && { isPublic }), // Update isPublic if provided
        translations: {
          upsert: translations.map((translation: SystemMessageTranslation) => ({
            where: {
              systemMessageId_languageCode: {
                systemMessageId: Number(id),
                languageCode: translation.languageCode,
              },
            },
            create: {
              languageCode: translation.languageCode,
              message: translation.message,
            },
            update: {
              message: translation.message,
            },
          })),
        },
      },
      include: { translations: true },
    })

    // Prepare response for the updated message
    const responseUpdatedMessage = {
      id: updatedMessage.id,
      startDate: updatedMessage.startDate,
      endDate: updatedMessage.endDate,
      isPublic: updatedMessage.isPublic,
      translations: updatedMessage.translations.map((translation) => ({
        languageCode: translation.languageCode,
        message: translation.message,
      })),
    }

    new CustomResponse(res).send({ data: responseUpdatedMessage })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Delete a message
const deleteMessage = async (req: Request, res: Response) => {
  const { language } = req.body
  const { id } = req.query

  try {
    const existingMessage = await prisma.systemMessage.findUnique({
      where: { id: Number(id) },
    })

    if (!existingMessage) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    await prisma.systemMessage.delete({
      where: { id: Number(id) },
    })

    // Send success response for deletion
    new CustomResponse(res).send({ message: 'System message is deleted successfully.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

// List all messages
const getAllMessages = async (req: Request, res: Response) => {
  const { language } = req.body
  try {
    const messages = await prisma.systemMessage.findMany({
      include: { translations: true },
    })

    // Prepare response for the list of messages
    const responseMessages = messages.map((message) => ({
      id: message.id,
      isPublic: message.isPublic,
      startDate: message.startDate,
      endDate: message.endDate,
      translations: message.translations.map((translation) => ({
        languageCode: translation.languageCode,
        message: translation.message,
      })),
      createdAt: message.createdAt.toISOString(),
      updatedAt: message.updatedAt.toISOString(),
    }))

    new CustomResponse(res).send({ data: responseMessages })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get shown messages (unexpired messages) with conditions
const getShownMessages = async (req: Request, res: Response) => {
  const { language } = req.body

  const currentDate = new Date()

  try {
    console.log('recieved succesfully ' + language)
    const preferences = await prisma.systemPreferences.findFirst()
    if (!preferences) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const showMessages = preferences.showMessages

    // If showMessages is false, return an empty array
    if (!showMessages) {
      return new CustomResponse(res).send({ data: [] })
    }

    const shownMessages = await prisma.systemMessage.findMany({
      where: {
        isPublic: true,
        OR: [
          {
            startDate: { lte: currentDate },
            endDate: { gte: currentDate },
          },
          {
            startDate: { lte: currentDate },
            endDate: null,
          },
          {
            startDate: null,
            endDate: { gte: currentDate },
          },
          {
            startDate: null,
            endDate: null,
          },
        ],
      },
      include: { translations: true }, // Include translations
    })

    // Prepare response for shown messages
    const responseShownMessages = shownMessages.map((msg) => ({
      id: msg.id,
      isPublic: msg.isPublic,
      startDate: msg.startDate,
      endDate: msg.endDate,
      translations: msg.translations.map((translation) => ({
        languageCode: translation.languageCode,
        message: translation.message,
      })),
    }))

    new CustomResponse(res).send({ data: responseShownMessages })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { createMessage, updateMessage, deleteMessage, getAllMessages, getShownMessages }
