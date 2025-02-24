import { PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import CustomResponse from '../core/resources/response/customResponse'
import { HttpError } from '../core/resources/response/httpError'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'

const prisma = new PrismaClient()

const createShowcaseItem = async (req: Request, res: Response) => {
  const { language, imageUrl, url } = req.body

  try {
    const newShowcaseItem = await prisma.showcaseItem.create({
      data: {
        imageUrl,
        url,
      },
    })

    const responsenewShowcaseItem = {
      id: newShowcaseItem.id,
      urlImage: newShowcaseItem.imageUrl,
      url: newShowcaseItem.url,
      order: null,
      type: 'none',
      startDate: null,
      endDate: null,
      createdAt: newShowcaseItem.createdAt.toISOString(),
      updatedAt: newShowcaseItem.updatedAt.toISOString(),
    }

    new CustomResponse(res).send({ data: responsenewShowcaseItem, message: 'Élément de vitrine créé avec succès.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

const updateShowcaseItem = async (req: Request, res: Response) => {
  const { language, id, imageUrl, url } = req.body

  try {
    // Check if the showcase item exists
    const existingShowcaseItem = await prisma.showcaseItem.findUnique({
      where: { id },
    })

    if (!existingShowcaseItem) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const updatedShowcaseItem = await prisma.showcaseItem.update({
      where: { id },
      data: {
        ...(imageUrl && { imageUrl: imageUrl }),
        ...(url && { url: url }),
      },
      include: {
        promo: true,
        default: true,
      },
    })

    const responseShowcaseItem = {
      id: updatedShowcaseItem.id,
      imageUrl: updatedShowcaseItem.imageUrl,
      url: updatedShowcaseItem.url,
      order: null,
      type: updatedShowcaseItem.promo ? 'promo' : 'defaultType',
      startDate: null,
      endDate: null,
      promo: updatedShowcaseItem.promo ?? null,
      default: updatedShowcaseItem.default ?? null,
      createdAt: updatedShowcaseItem.createdAt.toISOString(),
      updatedAt: updatedShowcaseItem.updatedAt.toISOString(),
    }

    new CustomResponse(res).send({ data: responseShowcaseItem, message: 'Élément de vitrine mis à jour avec succès.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

const deleteShowcaseItem = async (req: Request, res: Response) => {
  const { language, id } = req.body

  try {
    await prisma.showcaseItem.delete({ where: { id } })
    new CustomResponse(res).send({ message: "L'élément de la vitrine a été supprimé avec succès." })
  } catch (error) {
    handleError(error, res, language)
  }
}

//---------------------------------------------------------------------//

const addItemToDefaultShowcase = async (req: Request, res: Response) => {
  const { language, itemId } = req.body

  try {
    // Check if item exists in promo showcase table
    const promoShowcaseItem = await prisma.promoShowcase.findUnique({
      where: { itemId: itemId },
    })

    // Delete the item if it exists in promo showcase table
    if (promoShowcaseItem) {
      await prisma.promoShowcase.delete({
        where: { itemId: itemId },
      })
    }

    // Find the latest order value
    const latestOrder = await prisma.defaultShowcase.findFirst({
      select: { order: true },
      orderBy: { order: 'desc' },
    })

    // Calculate the new order value
    const newOrder = (latestOrder?.order ?? -1) + 1

    // Create the new DefaultShowcase item
    const defaultShowcaseItem = await prisma.defaultShowcase.create({
      data: {
        itemId: itemId,
        order: newOrder,
      },
      include: {
        showcaseItem: true,
      },
    })

    // Prepare the response data
    const responseDefaultShowcaseItem = {
      id: defaultShowcaseItem.showcaseItem.id,
      imageUrl: defaultShowcaseItem.showcaseItem.imageUrl,
      url: defaultShowcaseItem.showcaseItem.url,
      order: defaultShowcaseItem.order,
      type: 'defaultType',
      startDate: null,
      endDate: null,
      createdAt: defaultShowcaseItem.showcaseItem.createdAt.toISOString(),
      updatedAt: defaultShowcaseItem.showcaseItem.updatedAt.toISOString(),
    }

    // Send the custom response
    new CustomResponse(res).send({
      data: responseDefaultShowcaseItem,
      message: 'Élément ajouté avec succès à la vitrine par défaut.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

const removeItemFromDefaultShowcase = async (req: Request, res: Response) => {
  const { language, itemId } = req.body

  try {
    await prisma.defaultShowcase.delete({
      where: {
        itemId: itemId,
      },
    })

    new CustomResponse(res).send({ message: "L'élément de vitrine par défaut a été supprimé avec succès." })
  } catch (error) {
    handleError(error, res, language)
  }
}

const switchDefaultShowcaseOrder = async (req: Request, res: Response) => {
  const { language, itemId, direction } = req.body

  try {
    const defaultShowcaseItem = await prisma.defaultShowcase.findUnique({
      where: { itemId: itemId },
      include: { showcaseItem: true },
    })

    if (!defaultShowcaseItem) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Find the target item to switch with based on direction
    let targetShowcaseItem
    if (direction === 'up') {
      targetShowcaseItem = await prisma.defaultShowcase.findFirst({
        where: {
          order: { lt: defaultShowcaseItem.order },
        },
        orderBy: { order: 'desc' },
      })
    } else if (direction === 'down') {
      targetShowcaseItem = await prisma.defaultShowcase.findFirst({
        where: {
          order: { gt: defaultShowcaseItem.order },
        },
        orderBy: { order: 'asc' },
      })
    }

    if (!targetShowcaseItem) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.CANNOT_SWITCH_ORDER,
        errorResponse(language).errorMessage.CANNOT_SWITCH_ORDER
      )
    }

    // Swap order values between defaultShowcaseItem and targetShowcaseItem
    // Transaction make sure they both success or fail
    await prisma.$transaction([
      prisma.defaultShowcase.update({
        where: { id: defaultShowcaseItem.id },
        data: {
          order: targetShowcaseItem.order,
        },
      }),
      prisma.defaultShowcase.update({
        where: { id: targetShowcaseItem.id },
        data: {
          order: defaultShowcaseItem.order,
        },
      }),
    ])

    // Send success response
    new CustomResponse(res).send({ message: 'Changée avec succès.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

//---------------------------------------------------------------------//

const addItemToPromoShowcase = async (req: Request, res: Response) => {
  const { language, itemId } = req.body

  try {
    // Check if item exists in promo showcase table
    const defaultShowcaseItem = await prisma.defaultShowcase.findUnique({
      where: { itemId: itemId },
    })

    // Delete the item if it exists in promo showcase table
    if (defaultShowcaseItem) {
      await prisma.defaultShowcase.delete({
        where: { itemId: itemId },
      })
    }

    // Find the latest order value
    const latestOrder = await prisma.promoShowcase.findFirst({
      select: { order: true },
      orderBy: { order: 'desc' },
    })

    // Calculate the new order value
    const newOrder = (latestOrder?.order ?? -1) + 1

    // Create the new PromoShowcase item
    const promoShowcaseItem = await prisma.promoShowcase.create({
      data: {
        itemId: itemId,
        order: newOrder,
      },
      include: {
        showcaseItem: true,
      },
    })

    // Prepare the response data
    const responsePromoShowcaseItem = {
      id: promoShowcaseItem.showcaseItem.id,
      imageUrl: promoShowcaseItem.showcaseItem.imageUrl,
      url: promoShowcaseItem.showcaseItem.url,
      order: promoShowcaseItem.order,
      type: 'promo',
      startDate: promoShowcaseItem.startDate ? promoShowcaseItem.startDate.toISOString() : null,
      endDate: promoShowcaseItem.endDate ? promoShowcaseItem.endDate.toISOString() : null,
      createdAt: promoShowcaseItem.showcaseItem.createdAt.toISOString(),
      updatedAt: promoShowcaseItem.showcaseItem.updatedAt.toISOString(),
    }

    // Send the custom response
    new CustomResponse(res).send({
      data: responsePromoShowcaseItem,
      message: 'Élément ajouté avec succès à la vitrine promotionnelle.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

const updatePromoShowcaseItem = async (req: Request, res: Response) => {
  const { language, itemId, startDate, endDate, clearStartDate, clearEndDate } = req.body

  try {
    // Validate input
    if (!itemId) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Check if the promo showcase item exists
    const existingPromoShowcase = await prisma.promoShowcase.findUnique({
      where: { itemId: itemId },
    })

    if (!existingPromoShowcase) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const updatedPromoShowcase = await prisma.promoShowcase.update({
      where: { itemId: itemId },
      data: {
        startDate: clearStartDate ? null : startDate ? new Date(startDate) : undefined,
        endDate: clearEndDate ? null : endDate ? new Date(endDate) : undefined,
      },
      include: {
        showcaseItem: true,
      },
    })

    const responseShowcaseItem = {
      id: updatedPromoShowcase.showcaseItem.id,
      imageUrl: updatedPromoShowcase.showcaseItem.imageUrl,
      url: updatedPromoShowcase.showcaseItem.url,
      order: updatedPromoShowcase.order,
      type: 'promo',
      startDate: updatedPromoShowcase.startDate ? updatedPromoShowcase.startDate.toISOString() : null,
      endDate: updatedPromoShowcase.endDate ? updatedPromoShowcase.endDate.toISOString() : null,
      createdAt: updatedPromoShowcase.showcaseItem.createdAt.toISOString(),
      updatedAt: updatedPromoShowcase.showcaseItem.updatedAt.toISOString(),
    }

    new CustomResponse(res).send({
      data: responseShowcaseItem,
      message: 'Élément de la vitrine promotionnelle mis à jour avec succès.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

const removeItemFromPromoShowcase = async (req: Request, res: Response) => {
  const { language, itemId } = req.body

  try {
    await prisma.promoShowcase.delete({
      where: {
        itemId: itemId,
      },
    })

    new CustomResponse(res).send({ message: "L'élément de vitrine promotionnelle a été supprimé avec succès." })
  } catch (error) {
    handleError(error, res, language)
  }
}

const switchPromoShowcaseOrder = async (req: Request, res: Response) => {
  const { language, itemId, direction } = req.body

  try {
    const promoShowcaseItem = await prisma.promoShowcase.findUnique({
      where: { itemId: itemId },
      include: { showcaseItem: true },
    })

    if (!promoShowcaseItem) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Find the target item to switch with based on direction
    let targetShowcaseItem
    if (direction === 'up') {
      targetShowcaseItem = await prisma.promoShowcase.findFirst({
        where: {
          order: { lt: promoShowcaseItem.order },
        },
        orderBy: { order: 'desc' },
      })
    } else if (direction === 'down') {
      targetShowcaseItem = await prisma.promoShowcase.findFirst({
        where: {
          order: { gt: promoShowcaseItem.order },
        },
        orderBy: { order: 'asc' },
      })
    }

    if (!targetShowcaseItem) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.CANNOT_SWITCH_ORDER,
        errorResponse(language).errorMessage.CANNOT_SWITCH_ORDER
      )
    }

    // Update order values in a transaction
    await prisma.$transaction([
      prisma.promoShowcase.update({
        where: { id: promoShowcaseItem.id },
        data: {
          order: targetShowcaseItem.order,
        },
      }),
      prisma.promoShowcase.update({
        where: { id: targetShowcaseItem.id },
        data: {
          order: promoShowcaseItem.order,
        },
      }),
    ])

    // Send success response
    new CustomResponse(res).send({ message: 'Changée avec succès.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

//---------------------------------------------------------------------//

const getShowcaseItems = async (req: Request, res: Response) => {
  const { language } = req.body
  try {
    const showcaseItems = await prisma.showcaseItem.findMany({
      include: {
        promo: true,
        default: true,
      },
      orderBy: { createdAt: 'desc' },
    })

    const responseShowcaseItems = showcaseItems.map((showcaseItem) => ({
      id: showcaseItem.id,
      imageUrl: showcaseItem.imageUrl,
      url: showcaseItem.url,
      order: null,
      type: showcaseItem.promo ? 'promo' : showcaseItem.default ? 'defaultType' : 'none',
      startDate: showcaseItem.promo
        ? showcaseItem.promo.startDate
          ? showcaseItem.promo.startDate.toISOString()
          : null
        : null,
      endDate: showcaseItem.promo
        ? showcaseItem.promo.endDate
          ? showcaseItem.promo.endDate.toISOString()
          : null
        : null,
      createdAt: showcaseItem.createdAt.toISOString(),
      updatedAt: showcaseItem.updatedAt.toISOString(),
    }))

    new CustomResponse(res).send({ data: responseShowcaseItems })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getDefaultShowcaseItems = async (req: Request, res: Response) => {
  const { language } = req.body
  try {
    const defaultShowcaseItems = await prisma.defaultShowcase.findMany({
      include: { showcaseItem: true },
      orderBy: { order: 'asc' },
    })

    const responseShowcaseItems = defaultShowcaseItems.map((item) => ({
      id: item.showcaseItem.id,
      imageUrl: item.showcaseItem.imageUrl,
      url: item.showcaseItem.url,
      order: item.order,
      type: 'defaultType',
      startDate: null,
      endDate: null,
      createdAt: item.showcaseItem.createdAt.toISOString(),
      updatedAt: item.showcaseItem.updatedAt.toISOString(),
    }))

    new CustomResponse(res).send({ data: responseShowcaseItems })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getPromoShowcaseItems = async (req: Request, res: Response) => {
  const { language } = req.body
  try {
    const promoShowcaseItems = await prisma.promoShowcase.findMany({
      include: { showcaseItem: true },
      orderBy: { order: 'asc' },
    })

    const responseShowcaseItems = promoShowcaseItems.map((item) => ({
      id: item.showcaseItem.id,
      imageUrl: item.showcaseItem.imageUrl,
      url: item.showcaseItem.url,
      order: item.order,
      type: 'promo',
      startDate: item.startDate ? item.startDate.toISOString() : null,
      endDate: item.endDate ? item.endDate.toISOString() : null,
      createdAt: item.showcaseItem.createdAt.toISOString(),
      updatedAt: item.showcaseItem.updatedAt.toISOString(),
    }))

    new CustomResponse(res).send({ data: responseShowcaseItems })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getPrioritizedShowcaseItems = async (req: Request, res: Response) => {
  const { language } = req.body
  try {
    const currentDate = new Date()

    // Fetch promo showcase items with not expired dates, ordered by order
    const promoShowcaseItems = await prisma.promoShowcase.findMany({
      where: {
        AND: [
          {
            OR: [
              { startDate: null }, // Show if startDate is null
              { startDate: { lte: currentDate } }, // Or show if startDate has been reached
            ],
          },
          {
            OR: [
              { endDate: null }, // Show if endDate is null
              { endDate: { gte: currentDate } }, // Or show if endDate has not expired
            ],
          },
        ],
      },
      include: { showcaseItem: true },
      orderBy: { order: 'asc' },
    })

    // Fetch default showcase items, ordered by order
    const defaultShowcaseItems = await prisma.defaultShowcase.findMany({
      include: { showcaseItem: true },
      orderBy: { order: 'asc' },
    })

    // Map and format promo showcase items with incremented order
    let orderCounter = 0 // Initialize order counter
    const promoItems = promoShowcaseItems.map((showcaseItem) => ({
      id: showcaseItem.showcaseItem.id,
      imageUrl: showcaseItem.showcaseItem.imageUrl,
      url: showcaseItem.showcaseItem.url,
      order: orderCounter++, // Increment order counter for each promo item
      type: 'promo',
      startDate: showcaseItem.startDate ? showcaseItem.startDate.toISOString() : null,
      endDate: showcaseItem.endDate ? showcaseItem.endDate.toISOString() : null,
      createdAt: showcaseItem.showcaseItem.createdAt.toISOString(),
      updatedAt: showcaseItem.showcaseItem.updatedAt.toISOString(),
    }))

    // Map and format default showcase items with incremented order
    const defaultItems = defaultShowcaseItems.map((showcaseItem) => ({
      id: showcaseItem.showcaseItem.id,
      imageUrl: showcaseItem.showcaseItem.imageUrl,
      url: showcaseItem.showcaseItem.url,
      order: orderCounter++, // Increment order counter for each default item
      type: 'defaultType',
      startDate: null,
      endDate: null,
      createdAt: showcaseItem.showcaseItem.createdAt.toISOString(),
      updatedAt: showcaseItem.showcaseItem.updatedAt.toISOString(),
    }))

    // Combine promo and default items in prioritized order
    const responseShowcaseItems = [...promoItems, ...defaultItems]

    // Send the combined and formatted response
    new CustomResponse(res).send({ data: responseShowcaseItems })
  } catch (error) {
    handleError(error, res, language)
  }
}

export {
  // item
  createShowcaseItem,
  updateShowcaseItem,
  deleteShowcaseItem,

  //default
  addItemToDefaultShowcase,
  removeItemFromDefaultShowcase,
  switchDefaultShowcaseOrder,

  //promo
  addItemToPromoShowcase,
  updatePromoShowcaseItem,
  removeItemFromPromoShowcase,
  switchPromoShowcaseOrder,

  // list
  getShowcaseItems,
  getDefaultShowcaseItems,
  getPromoShowcaseItems,
  getPrioritizedShowcaseItems,
}
