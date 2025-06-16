import { PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { HttpError } from '../core/resources/response/httpError'

const prisma = new PrismaClient()

// sync local db with remote db
const syncCart = async (req: Request, res: Response) => {
  const { language, userId, items } = req.body

  try {
    if (!Array.isArray(items)) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.MISSING_PARAMETERS,
        errorResponse(language).errorMessage.MISSING_PARAMETERS
      )
    }

    // Ensure the cart exists
    const cart = await prisma.cart.upsert({
      where: { userId: userId },
      update: {},
      create: { userId: userId },
    })

    // Add the items to the cart using upsert
    await Promise.all(
      items.map(async (item) => {
        return await prisma.cartItem.upsert({
          where: {
            cartId_productId: {
              cartId: cart.id,
              productId: item.productId,
            },
          },
          update: {},
          create: {
            cartId: cart.id,
            productId: item.productId,
            quantity: item.quantity,
          },
        })
      })
    )

    const updatedCart = await prisma.cart.findUnique({
      where: { userId },
      include: {
        items: {
          orderBy: {
            createdAt: 'desc',
          },
        },
      },
    })

    const cartResponse = {
      items: updatedCart!.items.map((item) => ({
        id: item.id,
        quantity: item.quantity,
        productId: item.productId,
      })),
    }

    new CustomResponse(res).send({ data: cartResponse })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Get or create cart by user ID
const getCartByUserId = async (req: Request, res: Response) => {
  const { language, userId } = req.body

  try {
    const cart = await prisma.cart.upsert({
      where: { userId: userId },
      update: {},
      create: {
        userId: userId,
      },
      include: {
        items: {
          orderBy: {
            createdAt: 'desc',
          },
        },
      },
    })

    const responseCart = {
      userId: cart.userId,
      items: cart.items.map((item) => ({
        id: item.id,
        quantity: item.quantity,
        productId: item.productId,
      })),
    }

    new CustomResponse(res).send({ data: responseCart })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Add an item to the cart
const addItemToCart = async (req: Request, res: Response) => {
  const { language, userId, productId } = req.body

  try {
    if (!productId) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.MISSING_PARAMETERS,
        errorResponse(language).errorMessage.MISSING_PARAMETERS
      )
    }

    const cart = await prisma.cart.findUnique({
      where: { userId: userId },
    })

    if (!cart) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Use upsert to add/update the cart item
    const cartItem = await prisma.cartItem.upsert({
      where: {
        cartId_productId: {
          cartId: cart.id,
          productId: productId,
        },
      },
      update: {
        quantity: { increment: 1 },
      },
      create: {
        cartId: cart.id,
        productId: productId,
        quantity: 1,
      },
    })

    const responseItem = {
      id: cartItem.id,
      quantity: cartItem.quantity,
      productId: cartItem.productId,
    }

    new CustomResponse(res).send({ data: responseItem })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Add multiple items to the cart
const addManyItemsToCart = async (req: Request, res: Response) => {
  const { language, userId, productIds } = req.body

  try {
    if (!Array.isArray(productIds) || productIds.length === 0) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.MISSING_PARAMETERS,
        errorResponse(language).errorMessage.MISSING_PARAMETERS
      )
    }

    const cart = await prisma.cart.findUnique({
      where: { userId: userId },
    })

    if (!cart) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const addedItems = await Promise.all(
      productIds.map(async (productId) => {
        return await prisma.cartItem.upsert({
          where: {
            cartId_productId: {
              cartId: cart.id,
              productId: productId,
            },
          },
          update: {
            quantity: { increment: 1 },
          },
          create: {
            cartId: cart.id,
            productId: productId,
            quantity: 1,
          },
        })
      })
    )

    const responseItems = addedItems.map((item) => ({
      id: item.id,
      quantity: item.quantity,
      productId: item.productId,
    }))

    new CustomResponse(res).send({ data: responseItems })
  } catch (error) {
    handleError(error, res, language)
  }
}
// update cart item by product id
const updateCartItem = async (req: Request, res: Response) => {
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
    const existingItem = await prisma.cartItem.findFirst({
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
    const updatedItem = await prisma.cartItem.update({
      where: { id: existingItem.id },
      data: { quantity },
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

// Remove an item from the cart
const removeItemFromCart = async (req: Request, res: Response) => {
  const { language, productId, allQuantity } = req.body

  try {
    if (!productId) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.MISSING_PARAMETERS,
        errorResponse(language).errorMessage.MISSING_PARAMETERS
      )
    }

    // Check if the item exists
    const existingItem = await prisma.cartItem.findFirst({
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
      const deletedItem = await prisma.cartItem.delete({
        where: { id: existingItem.id },
      })

      responseDeletedItem = {
        id: deletedItem.id,
        quantity: deletedItem.quantity,
        productId: deletedItem.productId,
      }
    } else {
      // Reduce quantity by 1
      const updatedItem = await prisma.cartItem.update({
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

    new CustomResponse(res).send({
      data: responseDeletedItem,
      message: 'Cart item has been removed successfully.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Clear cart (remove all items)
const clearCart = async (req: Request, res: Response) => {
  const { language, userId } = req.body

  try {
    const cart = await prisma.cart.findUnique({ where: { userId: userId }, include: { items: true } })

    if (!cart) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    await prisma.cartItem.deleteMany({ where: { cartId: cart.id } })

    new CustomResponse(res).send({ message: 'The cart is cleared successfully.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { syncCart, getCartByUserId, addItemToCart, addManyItemsToCart, updateCartItem, removeItemFromCart, clearCart }
