import { PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { HttpError } from '../core/resources/response/httpError'

const prisma = new PrismaClient()

// Add multiple items to the wishlist
const syncWishlist = async (req: Request, res: Response) => {
  const { language, userId, items } = req.body

  try {
    if (!Array.isArray(items)) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.MISSING_PARAMETERS,
        errorResponse(language).errorMessage.MISSING_PARAMETERS
      )
    }

    // Ensure the wishlist exists
    const wishlist = await prisma.wishlist.upsert({
      where: { userId: userId },
      update: {},
      create: { userId: userId },
    })

    // Add the items to the wishlist using upsert
    await Promise.all(
      items.map(async (item) => {
        return await prisma.wishlistItem.upsert({
          where: {
            wishlistId_productId: {
              wishlistId: wishlist.id,
              productId: item.productId,
            },
          },
          update: {},
          create: {
            wishlistId: wishlist.id,
            productId: item.productId,
            quantity: item.quantity,
          },
        })
      })
    )

    const updatedWishlist = await prisma.wishlist.findUnique({
      where: { userId },
      include: {
        items: true,
      },
    })

    const wishlistResponse = {
      items: updatedWishlist!.items.map((item) => ({
        id: item.id,
        quantity: item.quantity,
        productId: item.productId,
      })),
    }

    new CustomResponse(res).send({ data: wishlistResponse })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get or create wishlist by user ID
const getWishlistByUserId = async (req: Request, res: Response) => {
  const { language, userId } = req.body

  try {
    const wishlist = await prisma.wishlist.upsert({
      where: { userId: userId },
      update: {},
      create: {
        userId: userId,
      },
      include: {
        items: true,
      },
    })

    const wishlistResponse = {
      items: wishlist.items.map((item) => ({
        id: item.id,
        quantity: item.quantity,
        productId: item.productId,
      })),
    }

    new CustomResponse(res).send({ data: wishlistResponse })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Add an item to the wishlist
const addItemToWishlist = async (req: Request, res: Response) => {
  const { language, userId, productId } = req.body

  try {
    if (!productId) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.MISSING_PARAMETERS,
        errorResponse(language).errorMessage.MISSING_PARAMETERS
      )
    }
    const wishlist = await prisma.wishlist.findUnique({
      where: { userId },
    })

    if (!wishlist) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Use upsert to either increment quantity or create a new wishlist item // done
    const wishlistItem = await prisma.wishlistItem.upsert({
      where: {
        wishlistId_productId: {
          wishlistId: wishlist.id,
          productId: productId,
        },
      },
      update: {
        quantity: { increment: 1 },
      },
      create: {
        wishlistId: wishlist.id,
        productId: productId,
        quantity: 1,
      },
    })

    // Send the created/updated item in the response
    const responseItem = {
      id: wishlistItem.id,
      quantity: wishlistItem.quantity,
      productId: wishlistItem.productId,
    }

    new CustomResponse(res).send({ data: responseItem })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Update a wishlist item (quantity)
const updateWishlistItem = async (req: Request, res: Response) => {
  const { language, productId, quantity } = req.body

  try {
    if (!productId || !quantity) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.MISSING_PARAMETERS,
        errorResponse(language).errorMessage.MISSING_PARAMETERS
      )
    }

    // Validate quantity
    if (quantity < 1) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_INPUT,
        errorResponse(language).errorMessage.INVALID_INPUT
      )
    }

    // Check if the item exists
    const existingItem = await prisma.wishlistItem.findFirst({
      where: { productId: productId },
    })

    if (!existingItem) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Update the item
    const updatedItem = await prisma.wishlistItem.update({
      where: { id: existingItem.id },
      data: { quantity: quantity },
    })

    const responseUpdatedItem = {
      id: updatedItem.id,
      quantity: updatedItem.quantity,
      productId: updatedItem.productId,
    }

    new CustomResponse(res).send({ data: responseUpdatedItem })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Remove an item from the wishlist or reduce its quantity
const removeItemFromWishlist = async (req: Request, res: Response) => {
  const { language, productId, allQuantity } = req.body

  try {
    console.log('allQuantity::::: ' + allQuantity)
    if (!productId) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.MISSING_PARAMETERS,
        errorResponse(language).errorMessage.MISSING_PARAMETERS
      )
    }

    // Check if the item exists
    const existingItem = await prisma.wishlistItem.findFirst({
      where: { productId: productId },
    })

    if (!existingItem) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    let responseDeletedItem

    if (allQuantity || existingItem.quantity <= 1) {
      // Delete the item completely
      const deletedItem = await prisma.wishlistItem.delete({
        where: { id: existingItem.id },
      })

      responseDeletedItem = {
        id: deletedItem.id,
        quantity: deletedItem.quantity,
        productId: deletedItem.productId,
      }
    } else {
      const updatedItem = await prisma.wishlistItem.update({
        where: { id: existingItem.id },
        data: {
          quantity: existingItem.quantity - 1,
        },
      })

      responseDeletedItem = {
        id: updatedItem.id,
        quantity: updatedItem.quantity,
        productId: updatedItem.productId,
      }
    }

    // Send a success response
    new CustomResponse(res).send({
      data: responseDeletedItem,
      message: `L'article de la liste de souhaits a été supprimé avec succès.`,
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Clear wishlist (remove all items) //done
const clearWishlist = async (req: Request, res: Response) => {
  const { language, userId } = req.body

  try {
    const wishlist = await prisma.wishlist.findUnique({ where: { userId: userId }, include: { items: true } })

    if (!wishlist) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    await prisma.wishlistItem.deleteMany({ where: { wishlistId: wishlist.id } })

    new CustomResponse(res).send({ message: 'La liste de souhaits a été vidée avec succès.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

export {
  syncWishlist,
  getWishlistByUserId,
  addItemToWishlist,
  updateWishlistItem,
  removeItemFromWishlist,
  clearWishlist,
}
