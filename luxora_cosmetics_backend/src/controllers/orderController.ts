import { PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { HttpError } from '../core/resources/response/httpError'
import { decryptData } from '../core/utils/utils'
import { userInfo } from 'os'

const prisma = new PrismaClient()

// Create a new order along with its order items.
const createOrder = async (req: Request, res: Response) => {
  const { language, userId, paymentMethod, items } = req.body

  try {
    // Validate required input
    if (!userId || !items || !Array.isArray(items) || items.length === 0) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Fetch the user from the database
    const user = await prisma.user.findUnique({ where: { id: userId, deletedAt: null } })

    // Extract all product IDs from the items array
    const productIds: string[] = items.map((item: any) => String(item.productId))

    // Fetch product details for all these product IDs
    const products = await prisma.product.findMany({
      where: { id: { in: productIds }, isPublic: true },
    })

    // If the user is not found or no products exist, throw a 404 error
    if (!user || products.length === 0) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const taxRate = 0.1 // 10%

    // Delivery is hardcoded for now
    let deliveryCost: number = 0
    const deliveryMaxArrivalDate: Date | null = null

    const orderItems = items.map((item: any) => {
      // Find product details matching the productId
      const product = products.find((p) => p.id === String(item.productId))
      if (!product) {
        throw new HttpError(
          HttpStatusCode.NOT_FOUND,
          errorResponse(language).errorTitle.NOT_FOUND,
          `Produit avec l'identifiant ${item.productId} non trouvé.`
        )
      }
    
      return {
        productName: product.name, // Using the product's EAN13 as ISBN
        productImageUrl: product.imageUrl,
        productPrice: product.price,
        productPricePromo: product.pricePromo,
        quantity: item.quantity,
        Product: { connect: { id: product.id } },
      }
    })

    // Create new order with order items
    await prisma.order.create({
      data: {
        userId: user.id,
        userEncryptedEmail: user.encryptedEmail,
        userEncryptedPhone: user.encryptedPhone,
        userEncryptedFirstName: user.encryptedFirstName,
        userEncryptedLastName: user.encryptedLastName,
        userEncryptedAddressMain: user.encryptedAddressMain,
        userEncryptedAddressSecond: user.encryptedAddressSecond,
        deliveryMaxArrivalDate: deliveryMaxArrivalDate,
        deliveryCity: user.city,
        deliveryZip: user.zip,
        taxRate: taxRate,
        deliveryCost: deliveryCost,
        paymentMethod,
        items: {
          create: orderItems,
        },
      },
      include: { items: true },
    })

    new CustomResponse(res).send({
      message: 'La commande a été créée avec succès.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Retrieve a specific order by its ID.
const getOrder = async (req: Request, res: Response) => {
  const { language } = req.body
  const { id } = req.query

  try {
    // Validate required input
    if (!id) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    const order = await prisma.order.findUnique({
      where: { id:id.toString() },
      include: { items: true },
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
      userEmail: order.userEncryptedEmail ? decryptData(order.userEncryptedEmail) : null,
      userPhone: order.userEncryptedPhone ? decryptData(order.userEncryptedPhone) : null,
      userFirstName: order.userEncryptedFirstName ? decryptData(order.userEncryptedFirstName) : null,
      userLastName: order.userEncryptedLastName ? decryptData(order.userEncryptedLastName) : null,
      deliveryAddressMain: order.userEncryptedAddressMain ? decryptData(order.userEncryptedAddressMain) : null,
      deliveryAddressSecond: order.userEncryptedAddressSecond ? decryptData(order.userEncryptedAddressSecond) : null,
      deliveryMaxArrivalDate: order.deliveryMaxArrivalDate,
      deliveryCity: order.deliveryCity,
      deliveryZip: order.deliveryZip,
      taxRate: order.taxRate,
      deliveryCost: order.deliveryCost,
      status: order.status,
      paymentMethod: order.paymentMethod,
      items: order.items.map((item) => ({
        id: item.id,
        productName: item.productName,
        productImageUrl: item.productImageUrl,
        productPrice: item.productPrice,
        productPricePromo: item.productPricePromo,
        quantity: item.quantity,
      })),
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    }

    new CustomResponse(res).send({ data: responseOrder })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Retrieve all orders. If a userId is provided in the request body, only orders for that user will be returned.
const getUserOrders = async (req: Request, res: Response) => {
  const { language, userId } = req.body
  const { limit = 10, page = 1 } = req.query

  const take = Number(limit) > 0 ? Number(limit) : 10
  const skip = (Number(page) - 1) * take
  let total: any = 0

  try {
    const orders = await prisma.order.findMany({
      where: userId ? { userId: userId.toString() } : {},
      skip,
      take,
      orderBy: {
        createdAt: 'desc',
      },
      include: { items: true },
    })

    // Fetch total count
    total = await prisma.order.count({
      where: userId ? { userId: userId.toString() } : {},
    })

    const responseOrders = orders.map((order) => ({
      id: order.id,
      userId: order.userId,
      userEmail: order.userEncryptedEmail ? decryptData(order.userEncryptedEmail) : null,
      userPhone: order.userEncryptedPhone ? decryptData(order.userEncryptedPhone) : null,
      userFirstName: order.userEncryptedFirstName ? decryptData(order.userEncryptedFirstName) : null,
      userLastName: order.userEncryptedLastName ? decryptData(order.userEncryptedLastName) : null,
      deliveryAddressMain: order.userEncryptedAddressMain ? decryptData(order.userEncryptedAddressMain) : null,
      deliveryAddressSecond: order.userEncryptedAddressSecond ? decryptData(order.userEncryptedAddressSecond) : null,
      deliveryMaxArrivalDate: order.deliveryMaxArrivalDate,
      deliveryCity: order.deliveryCity,
      deliveryZip: order.deliveryZip,
      taxRate: order.taxRate,
      deliveryCost: order.deliveryCost,
      status: order.status,
      paymentMethod: order.paymentMethod,
      items: order.items.map((item) => ({
        id: item.id,
        productName: item.productName,
        productImageUrl: item.productImageUrl,
        productPrice: item.productPrice,
        productPricePromo: item.productPricePromo,
        quantity: item.quantity,
      })),
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    }))

    new CustomResponse(res).send({
      data: responseOrders,
      pagination: {
        limit: Number(limit),
        total: Number(total),
        page: Number(page),
        pages: Math.ceil(Number(total) / take),
      },
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Update the status of an order.

const updateOrderStatus = async (req: Request, res: Response) => {
  const { language, id, status } = req.body

  try {
    // Validate input
    if (!id || !status) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    await prisma.order.update({
      where: { id: id },
      data: { status },
      include: { items: true },
    })

    new CustomResponse(res).send({
      message: 'Le statut de la commande a été mis à jour avec succès.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { createOrder, getOrder, getUserOrders, updateOrderStatus }
