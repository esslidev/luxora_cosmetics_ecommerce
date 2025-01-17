import { PrismaClient, Magasin } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import { HttpError } from '../core/resources/response/httpError'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import CustomResponse from '../core/resources/response/customResponse'

const prisma = new PrismaClient()

// Helper function to format Magasin response
const formatMagasinResponse = (magasin: Magasin) => ({
  id: magasin.id,
  magasinId: magasin.magasinId,
  isDefaultMagasin: magasin.isDefaultMagasin,
  magasinName: magasin.magasinName,
  magasinEmail: magasin.magasinEmail,
  magasinHoraire: magasin.magasinHoraire,
  magasinAddress: magasin.magasinAddress,
  magasinPhone: magasin.magasinPhone,
})

// Create a new Magasin
const createMagasin = async (req: Request, res: Response) => {
  const {
    language,
    magasinId,
    isDefaultMagasin,
    magasinName,
    magasinEmail,
    magasinHoraire,
    magasinAddress,
    magasinPhone,
  } = req.body

  try {
    // Check if magasin with the same magasinId already exists
    const existingMagasin = await prisma.magasin.findUnique({ where: { magasinId } })

    if (existingMagasin) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.MAGASIN_ALREADY_EXISTS,
        errorResponse(language).errorMessage.MAGASIN_ALREADY_EXISTS
      )
    }

    const newMagasin: Magasin = await prisma.magasin.create({
      data: {
        magasinId,
        isDefaultMagasin,
        magasinName,
        magasinEmail,
        magasinHoraire,
        magasinAddress,
        magasinPhone,
      },
    })

    const responseNewMagasin = formatMagasinResponse(newMagasin)
    new CustomResponse(res).send({ data: responseNewMagasin })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get a Magasin by ID
const getMagasinById = async (req: Request, res: Response) => {
  const { language } = req.body
  const { id } = req.query

  try {
    const magasin = await prisma.magasin.findUnique({ where: { id: Number(id) } })

    if (!magasin) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const responseMagasin = formatMagasinResponse(magasin)
    new CustomResponse(res).send({ data: responseMagasin })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get Magasins based on query parameters
const getMagasins = async (req: Request, res: Response) => {
  const { language } = req.body
  const { id, magasinId, magasinName, magasinEmail, magasinAddress, magasinPhone } = req.query

  try {
    const whereClause: any = {}

    // Build the where clause based on available query parameters
    if (id) whereClause.id = Number(id)
    if (magasinId) whereClause.magasinId = magasinId
    if (magasinName) whereClause.magasinName = magasinName
    if (magasinEmail) whereClause.magasinEmail = magasinEmail
    if (magasinAddress) whereClause.magasinAddress = magasinAddress
    if (magasinPhone) whereClause.magasinPhone = magasinPhone

    const magasins = await prisma.magasin.findMany({ where: whereClause })

    if (magasins.length === 0) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const responseMagasins = magasins.map(formatMagasinResponse)
    new CustomResponse(res).send({ data: responseMagasins })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get all Magasins
const getAllMagasins = async (req: Request, res: Response) => {
  try {
    const magasins = await prisma.magasin.findMany()
    const responseMagasins = magasins.map(formatMagasinResponse)
    new CustomResponse(res).send({ data: responseMagasins })
  } catch (error) {
    handleError(error, res)
  }
}

// Update a Magasin
const updateMagasin = async (req: Request, res: Response) => {
  const {
    id,
    magasinId,
    isDefaultMagasin,
    magasinName,
    magasinEmail,
    magasinHoraire,
    magasinAddress,
    magasinPhone,
    language,
  } = req.body

  try {
    const existingMagasin = await prisma.magasin.findUnique({ where: { id } })

    if (!existingMagasin) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const updatedMagasinData: Partial<Magasin> = {
      ...(magasinId && { magasinId }),
      ...(isDefaultMagasin !== undefined && { isDefaultMagasin }),
      ...(magasinName && { magasinName }),
      ...(magasinEmail && { magasinEmail }),
      ...(magasinHoraire && { magasinHoraire }),
      ...(magasinAddress && { magasinAddress }),
      ...(magasinPhone && { magasinPhone }),
    }

    const updatedMagasin = await prisma.magasin.update({
      where: { id },
      data: updatedMagasinData,
    })

    const responseUpdatedMagasin = formatMagasinResponse(updatedMagasin)
    new CustomResponse(res).send({ data: responseUpdatedMagasin })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Delete a Magasin by ID
const deleteMagasinById = async (req: Request, res: Response) => {
  const { id, language } = req.body

  try {
    await prisma.magasin.delete({ where: { id: Number(id) } })
    new CustomResponse(res).send({ message: 'Magasin deleted successfully.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { createMagasin, getMagasinById, getMagasins, getAllMagasins, updateMagasin, deleteMagasinById }
