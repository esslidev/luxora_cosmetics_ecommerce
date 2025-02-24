import { PaymentMethod, PrismaClient } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { HttpError } from '../core/resources/response/httpError'
import { decryptData, encryptData } from '../core/utils/utils'

const prisma = new PrismaClient()

// Create a new order along with its order items.
const createOrder = async (req: Request, res: Response) => {
  const { language, userId, magasinCode, paymentMethod, items } = req.body

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
    const user = await prisma.user.findUnique({ where: { id: Number(userId), deletedAt: null } })

    let magasin: any = null
    // If a magasinCode is provided, fetch the corresponding magasin.
    if (magasinCode) {
      magasin = await prisma.magasin.findUnique({ where: { magasinCode } })
      if (!magasin) {
        throw new HttpError(
          HttpStatusCode.NOT_FOUND,
          errorResponse(language).errorTitle.NOT_FOUND,
          errorResponse(language).errorMessage.NOT_FOUND
        )
      }
    }

    // Extract all product IDs from the items array
    const productIds: number[] = items.map((item: any) => Number(item.productId))

    // Fetch product details for all these product IDs
    const products = await prisma.product.findMany({
      where: { id: { in: productIds }, isPublic: true },
      include: {
        stock: {
          include: {
            magasin: {
              include: {
                Delivery: true,
              },
            },
          },
        },
        primaryCategory: true,
        reviews: { where: { isPublic: true } },
      },
    })

    // If the user is not found or no products exist, throw a 404 error
    if (!user || products.length === 0) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Calculate the subtotal (price before tax and delivery)
    let subTotalPrice: number = 0
    let totalPrice: number = 0
    const taxRate = 0.1 // 10%

    // Delivery is hardcoded for now
    let deliveryCost: number = 0
    const deliveryMaxArrivalDate: Date | null = null

    const orderItems = items.map((item: any) => {
      // Find product details matching the productId
      const product = products.find((p) => p.id === Number(item.productId))
      if (!product) {
        throw new HttpError(
          HttpStatusCode.NOT_FOUND,
          errorResponse(language).errorTitle.NOT_FOUND,
          `Produit avec l'identifiant ${item.productId} non trouvé.`
        )
      }

      // Determine effective price:
      // - Use Art_Prix_Promo if available,
      // - Otherwise, if primaryCategory promoPercent is available, calculate promo price,
      // - Else use the regular Art_Prix.
      let effectivePrice: number
      if (product.Art_Prix_Promo !== null && product.Art_Prix_Promo !== undefined) {
        effectivePrice = product.Art_Prix_Promo
      } else if (
        product.primaryCategory &&
        product.primaryCategory.promoPercent !== null &&
        product.primaryCategory.promoPercent !== undefined
      ) {
        effectivePrice = product.Art_Prix - (product.Art_Prix * product.primaryCategory.promoPercent) / 100
      } else {
        effectivePrice = product.Art_Prix
      }
      subTotalPrice += effectivePrice * item.quantity

      return {
        productIsbn: product.Art_Ean13, // Using the product's EAN13 as ISBN
        productTitle: product.Art_Titre,
        productImageUrl: product.Art_Image_Url,
        productPrice: product.Art_Prix,
        productPricePromo: product.Art_Prix_Promo,
        productPrimaryCategoryPromoPercent: product.primaryCategory?.promoPercent || null,
        productFormatType: product.formatType,
        quantity: item.quantity,
        Product: { connect: { id: product.id } },
      }
    })

    // Calculate tax amount and final total price
    const taxAmount = subTotalPrice * taxRate
    deliveryCost = paymentMethod === PaymentMethod.cashOnDelivery ? 60.99 : 0
    totalPrice = subTotalPrice + taxAmount + deliveryCost // Fixed total price calculation

    // Create new order with order items
    await prisma.order.create({
      data: {
        userId: user.id,
        magasinCode: magasin?.magasinCode,
        userEncryptedEmail: user.encryptedEmail,
        userEncryptedPhone: user.encryptedPhone,
        userEncryptedFirstName: user.encryptedFirstName,
        userEncryptedLastName: user.encryptedLastName,
        subTotalPrice: subTotalPrice,
        totalPrice: totalPrice,
        taxRate: taxRate,
        deliveryCost: deliveryCost,
        magasinName: magasin?.magasinName,
        magasinAddress: magasin?.magasinAddress,
        userEncryptedAddressMain: user.encryptedAddressMain,
        userEncryptedAddressSecond: user.encryptedAddressSecond,
        deliveryMaxArrivalDate: deliveryMaxArrivalDate,
        deliveryCity: user.city,
        deliveryZip: user.zip,
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
      where: { id: Number(id) },
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
      subTotalPrice: order.subTotalPrice,
      totalPrice: order.totalPrice,
      taxRate: order.taxRate,
      deliveryCost: order.deliveryCost,
      magasinCode: order.magasinCode,
      magasinName: order.magasinName,
      magasinAddress: order.magasinAddress,
      deliveryAddressMain: order.userEncryptedAddressMain ? decryptData(order.userEncryptedAddressMain) : null,
      deliveryAddressSecond: order.userEncryptedAddressSecond ? decryptData(order.userEncryptedAddressSecond) : null,
      deliveryMaxArrivalDate: order.deliveryMaxArrivalDate,
      deliveryCity: order.deliveryCity,
      deliveryZip: order.deliveryZip,
      status: order.status,
      paymentMethod: order.paymentMethod,
      items: order.items.map((item) => ({
        id: item.id,
        productIsbn: item.productIsbn,
        productTitle: item.productTitle,
        productImageUrl: item.productImageUrl,
        productPrice: item.productPrice,
        productPricePromo: item.productPricePromo,
        productPrimaryCategoryPromoPercent: item.productPrimaryCategoryPromoPercent,
        productFormatType: item.productFormatType,
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
      where: userId ? { userId: Number(userId) } : {},
      skip,
      take,
      orderBy: {
        createdAt: 'desc',
      },
      include: { items: true },
    })

    // Fetch total count
    total = await prisma.order.count({
      where: userId ? { userId: Number(userId) } : {},
    })

    const responseOrders = orders.map((order) => ({
      id: order.id,
      subTotalPrice: order.subTotalPrice,
      totalPrice: order.totalPrice,
      taxRate: order.taxRate,
      deliveryCost: order.deliveryCost,
      magasinCode: order.magasinCode,
      magasinName: order.magasinName,
      magasinAddress: order.magasinAddress,
      deliveryAddressMain: order.userEncryptedAddressMain ? decryptData(order.userEncryptedAddressMain) : null,
      deliveryAddressSecond: order.userEncryptedAddressSecond ? decryptData(order.userEncryptedAddressSecond) : null,
      deliveryMaxArrivalDate: order.deliveryMaxArrivalDate,
      deliveryCity: order.deliveryCity,
      deliveryZip: order.deliveryZip,
      status: order.status,
      paymentMethod: order.paymentMethod,
      items: order.items.map((item) => ({
        id: item.id,
        productIsbn: item.productIsbn,
        productTitle: item.productTitle,
        productImageUrl: item.productImageUrl,
        productPrice: item.productPrice,
        productPricePromo: item.productPricePromo,
        productPrimaryCategoryPromoPercent: item.productPrimaryCategoryPromoPercent,
        productFormatType: item.productFormatType,
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
