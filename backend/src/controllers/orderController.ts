import { PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { HttpError } from '../core/resources/response/httpError'

const prisma = new PrismaClient()

// Create a new order
const createOrder = async (req: Request, res: Response) => {
  const { language, userId, magasinId, transactionId, deliveryAddress, transactionInfo, status, products } = req.body

  try {
    // Validate items and ensure each item has productId, quantity, and price
    if (!products || !Array.isArray(products) || products.length === 0) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.ORDER_MUST_INCLUDE_ONE_ITEM,
        errorResponse(language).errorMessage.ORDER_MUST_INCLUDE_ONE_ITEM
      )
    }

    // Prepare the order items using the provided price
    const orderItems = products.map((product: any) => {
      if (!product.productId || !product.quantity || !product.price) {
        console.error('Each item must have a productId, quantity, and price.')
        throw new HttpError(
          HttpStatusCode.BAD_REQUEST,
          errorResponse(language).errorTitle.INVALID_REQUEST,
          errorResponse(language).errorMessage.INVALID_REQUEST
        )
      }
      return {
        productId: product.productId,
        quantity: product.quantity,
        price: product.price,
      }
    })

    // Calculate total based on provided prices
    const totalPrice = orderItems.reduce((total, item) => {
      return total + item.price * item.quantity
    }, 0)

    // Create new order
    const newOrder = await prisma.order.create({
      data: {
        userId,
        magasinId,
        transactionId,
        deliveryAddress,
        transactionInfo,
        status,
        total: totalPrice,
        items: {
          create: orderItems,
        },
      },
      include: {
        items: {
          include: {
            product: {
              select: {
                id: true,
                Art_Ean13: true,
                Art_Titre: true,
                author: true,
                Art_Image_Url: true,
              },
            },
          },
        },
      },
    })

    // Prepare the response
    const responseNewOrder = {
      id: newOrder.id,
      userId: newOrder.userId,
      magasinId: newOrder.magasinId,
      transactionId: newOrder.transactionId,
      deliveryAddress: newOrder.deliveryAddress,
      transactionInfo: newOrder.transactionInfo,
      total: newOrder.total,
      status: newOrder.status,
      items: newOrder.items.map((item) => ({
        productId: item.productId,
        quantity: item.quantity,
        price: item.price,
        product: item.product,
      })),
      createdAt: newOrder.createdAt,
      updatedAt: newOrder.updatedAt,
    }

    // Send success response
    new CustomResponse(res).send({ data: responseNewOrder })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Add an item to an order
const addItemToOrder = async (req: Request, res: Response) => {
  const { language, orderId, productId, price } = req.body

  try {
    const order = await prisma.order.findUnique({
      where: { id: orderId },
    })

    if (!order) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Check if the order status is 'CREATED'
    if (order.status !== 'CREATED') {
      throw new HttpError(
        HttpStatusCode.FORBIDDEN,
        errorResponse(language).errorTitle.FORBIDDEN,
        errorResponse(language).errorMessage.FORBIDDEN
      )
    }

    // Check if the product already exists in the order
    const existingItem = await prisma.orderItem.findUnique({
      where: {
        orderId_productId: {
          orderId: orderId,
          productId: productId,
        },
      },
    })

    if (existingItem) {
      // Update the quantity of the existing item
      const updatedItem = await prisma.orderItem.update({
        where: {
          id: existingItem.id,
        },
        data: {
          quantity: existingItem.quantity + 1, // Increment the quantity
          price: price,
        },
        include: {
          product: {
            select: {
              id: true,
              Art_Ean13: true,
              Art_Titre: true,
              author: true,
              Art_Image_Url: true,
            },
          },
        },
      })

      const responseItem = {
        id: updatedItem.id,
        orderId: updatedItem.orderId,
        productId: updatedItem.productId,
        quantity: updatedItem.quantity,
        price: updatedItem.price,
        product: updatedItem.product,
      }

      new CustomResponse(res).send({ data: responseItem, message: 'Item updated successfully.' })
    } else {
      // Create a new order item if it does not exist
      const newItem = await prisma.orderItem.create({
        data: {
          orderId,
          productId,
          quantity: 1,
          price,
        },
        include: {
          product: {
            select: {
              id: true,
              Art_Ean13: true,
              Art_Titre: true,
              author: true,
              Art_Image_Url: true,
            },
          },
        },
      })

      const responseItem = {
        id: newItem.id,
        orderId: newItem.orderId,
        productId: newItem.productId,
        quantity: newItem.quantity,
        price: newItem.price,
        product: newItem.product,
      }

      new CustomResponse(res).send({ data: responseItem, message: 'Item added successfully.' })
    }
  } catch (error) {
    handleError(error, res, language)
  }
}

// Update the quantity or price of an order item
const updateOrderItem = async (req: Request, res: Response) => {
  const { language, itemId, quantity, price } = req.body

  try {
    const existingItem = await prisma.orderItem.findUnique({
      where: { id: itemId },
    })

    if (!existingItem) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Check the order status
    const order = await prisma.order.findUnique({
      where: { id: existingItem.orderId },
    })

    if (!order) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    if (order.status !== 'CREATED') {
      throw new HttpError(
        HttpStatusCode.FORBIDDEN,
        errorResponse(language).errorTitle.FORBIDDEN,
        errorResponse(language).errorMessage.FORBIDDEN
      )
    }

    const updatedItem = await prisma.orderItem.update({
      where: { id: itemId },
      data: { quantity, price },
      include: {
        product: {
          select: {
            id: true,
            Art_Ean13: true,
            Art_Titre: true,
            author: true,
            Art_Image_Url: true,
          },
        },
      },
    })

    const responseItem = {
      id: updatedItem.id,
      orderId: updatedItem.orderId,
      productId: updatedItem.productId,
      quantity: updatedItem.quantity,
      price: updatedItem.price,
      product: updatedItem.product,
    }

    new CustomResponse(res).send({ data: responseItem })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Remove an item from an order
const removeItemFromOrder = async (req: Request, res: Response) => {
  const { language, orderId, itemId } = req.body

  try {
    const order = await prisma.order.findUnique({
      where: { id: orderId },
    })

    if (!order) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Check the order status
    if (order.status !== 'CREATED') {
      throw new HttpError(
        HttpStatusCode.FORBIDDEN,
        errorResponse(language).errorTitle.FORBIDDEN,
        errorResponse(language).errorMessage.FORBIDDEN
      )
    }

    // Check if the order item exists
    const existingItem = await prisma.orderItem.findUnique({
      where: { id: itemId },
    })

    if (!existingItem) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    let responseMessage
    if (existingItem.quantity > 1) {
      // Reduce the quantity by 1 if it's greater than 1
      const updatedItem = await prisma.orderItem.update({
        where: { id: existingItem.id },
        data: { quantity: existingItem.quantity - 1 },
        include: {
          product: {
            select: {
              id: true,
              Art_Ean13: true,
              Art_Titre: true,
              author: true,
              Art_Image_Url: true,
            },
          },
        },
      })

      responseMessage = {
        id: updatedItem.id,
        orderId: updatedItem.orderId,
        productId: updatedItem.productId,
        quantity: updatedItem.quantity,
        product: updatedItem.product,
      }

      new CustomResponse(res).send({ data: responseMessage })
    } else {
      // Remove the item if the quantity is 1
      await prisma.orderItem.delete({
        where: { id: existingItem.id },
      })

      new CustomResponse(res).send({ message: 'Item removed from order' })
    }
  } catch (error) {
    handleError(error, res, language)
  }
}

// Update an order (status, deliveryAddress, transactionInfo, etc.)
const updateOrder = async (req: Request, res: Response) => {
  const { language, orderId, status, deliveryAddress, estimatedDeliveryDate, transactionInfo } = req.body

  try {
    // Check if the order exists
    const existingOrder = await prisma.order.findUnique({
      where: { id: orderId },
    })

    if (!existingOrder) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Update the order with the provided data
    const updatedOrder = await prisma.order.update({
      where: { id: orderId },
      data: {
        status,
        deliveryAddress,
        estimatedDeliveryDate,
        transactionInfo,
      },
    })

    const responseOrder = {
      id: updatedOrder.id,
      status: updatedOrder.status,
      deliveryAddress: updatedOrder.deliveryAddress,
      transactionInfo: updatedOrder.transactionInfo,
      updatedAt: updatedOrder.updatedAt,
    }

    // Send success response
    new CustomResponse(res).send({ data: responseOrder })
  } catch (error) {
    handleError(error, res, language)
  }
}

// List all orders
const getAllOrders = async (req: Request, res: Response) => {
  const { language } = req.body

  try {
    const orders = await prisma.order.findMany({
      include: {
        items: {
          include: {
            product: {
              select: {
                id: true,
                Art_Ean13: true,
                Art_Titre: true,
                Art_Image_Url: true,
                author: true,
                Art_Prix: true,
                Art_Prix_Promo: true,
                Art_DateDPromo: true,
                Art_DateFPromo: true,
              },
            },
          },
        },
      },
    })

    const responseOrders = orders.map((order) => ({
      id: order.id,
      userId: order.userId,
      magasinId: order.magasinId,
      transactionId: order.transactionId,
      deliveryAddress: order.deliveryAddress,
      transactionInfo: order.transactionInfo,
      total: order.total,
      status: order.status,
      items: order.items.map((item) => ({
        productId: item.productId,
        quantity: item.quantity,
        price: item.price,
        product: item.product,
      })),
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    }))

    new CustomResponse(res).send({ data: responseOrders })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Fetch all orders for a specific user
const getOrdersByUserId = async (req: Request, res: Response) => {
  const { language } = req.body
  const { userId } = req.query

  try {
    const orders = await prisma.order.findMany({
      where: { userId: Number(userId) },
      include: {
        items: {
          include: {
            product: {
              select: {
                id: true,
                Art_Ean13: true,
                Art_Titre: true,
                Art_Image_Url: true,
                author: true,
                Art_Prix: true,
                Art_Prix_Promo: true,
                Art_DateDPromo: true,
                Art_DateFPromo: true,
              },
            },
          },
        },
      },
    })

    if (!orders.length) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const responseOrders = orders.map((order) => ({
      id: order.id,
      userId: order.userId,
      magasinId: order.magasinId,
      transactionId: order.transactionId,
      deliveryAddress: order.deliveryAddress,
      transactionInfo: order.transactionInfo,
      total: order.total,
      status: order.status,
      items: order.items.map((item) => ({
        productId: item.productId,
        quantity: item.quantity,
        price: item.price,
        product: item.product,
      })),
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    }))

    new CustomResponse(res).send({ data: responseOrders })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Fetch all orders for a specific store (magasin)
const getOrdersByMagasinId = async (req: Request, res: Response) => {
  const { language } = req.body
  const { magasinId } = req.query

  try {
    const orders = await prisma.order.findMany({
      where: { magasinId: Number(magasinId) }, // Assuming 'magasinId' exists in the order model
      include: {
        items: {
          include: {
            product: {
              select: {
                id: true,
                Art_Ean13: true,
                Art_Titre: true,
                Art_Image_Url: true,
                author: true,
                Art_Prix: true,
                Art_Prix_Promo: true,
                Art_DateDPromo: true,
                Art_DateFPromo: true,
              },
            },
          },
        },
      },
    })

    const responseOrders = orders.map((order) => ({
      id: order.id,
      magasinId: order.magasinId,
      userId: order.userId,
      transactionId: order.transactionId,
      deliveryAddress: order.deliveryAddress,
      transactionInfo: order.transactionInfo,
      total: order.total,
      status: order.status,
      items: order.items.map((item) => ({
        productId: item.productId,
        quantity: item.quantity,
        price: item.price,
        product: item.product,
      })),
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    }))

    new CustomResponse(res).send({ data: responseOrders })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Retrieve details of a specific order
const getOrderById = async (req: Request, res: Response) => {
  const { language } = req.body
  const { orderId } = req.query

  try {
    const order = await prisma.order.findUnique({
      where: { id: Number(orderId) },
      include: {
        items: {
          include: {
            product: {
              select: {
                id: true,
                Art_Ean13: true,
                Art_Titre: true,
                Art_Image_Url: true,
                author: true,
                Art_Prix: true,
                Art_Prix_Promo: true,
                Art_DateDPromo: true,
                Art_DateFPromo: true,
              },
            },
          },
        },
      },
    })

    if (!order) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const responseOrder = {
      id: order.id,
      userId: order.userId,
      magasinId: order.magasinId,
      transactionId: order.transactionId,
      deliveryAddress: order.deliveryAddress,
      transactionInfo: order.transactionInfo,
      total: order.total,
      status: order.status,
      items: order.items.map((item) => ({
        productId: item.productId,
        quantity: item.quantity,
        price: item.price,
        product: item.product,
      })),
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    }

    new CustomResponse(res).send({ data: responseOrder })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Delete an order if its status is 'CREATED'
const deleteOrder = async (req: Request, res: Response) => {
  const { language, orderId } = req.body

  try {
    // Check if the order exists
    const existingOrder = await prisma.order.findUnique({
      where: { id: orderId },
    })

    if (!existingOrder) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Check if the order status is 'CREATED'
    if (existingOrder.status !== 'CREATED') {
      throw new HttpError(
        HttpStatusCode.FORBIDDEN,
        errorResponse(language).errorTitle.FORBIDDEN,
        errorResponse(language).errorMessage.FORBIDDEN
      )
    }

    // Delete the order
    await prisma.order.delete({
      where: { id: Number(orderId) },
    })

    // Send success response
    new CustomResponse(res).send({ message: 'Order successfully deleted.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

export default {
  createOrder,
  addItemToOrder,
  updateOrderItem,
  removeItemFromOrder,
  updateOrder,
  getAllOrders,
  getOrdersByUserId,
  getOrdersByMagasinId,
  getOrderById,
  deleteOrder,
}
