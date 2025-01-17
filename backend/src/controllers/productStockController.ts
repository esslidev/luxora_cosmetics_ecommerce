import { PrismaClient, ProductStock } from '@prisma/client'
import { Request, Response } from 'express'
import { handleError } from '../core/utils/errorHandler'
import { HttpError } from '../core/resources/response/httpError'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'
import CustomResponse from '../core/resources/response/customResponse'

const prisma = new PrismaClient()

const createProductStock = async (req: Request, res: Response) => {
  const { language, productIsbn, magasinId, stock } = req.body

  try {
    const existingStock = await prisma.productStock.findUnique({
      where: {
        productIsbn_magasinId: {
          productIsbn: productIsbn,
          magasinId,
        },
      },
    })

    if (existingStock) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.DATA_ALREADY_EXISTS,
        errorResponse(language).errorMessage.DATA_ALREADY_EXISTS
      )
    }

    const newProductStock: ProductStock = await prisma.productStock.create({
      data: {
        productIsbn: productIsbn,
        magasinId,
        Art_Stock: stock,
      },
    })

    const responseNewProductStock = {
      id: newProductStock.id,
      productIsbn: newProductStock.productIsbn,
      magasinId: newProductStock.magasinId,
      stock: newProductStock.Art_Stock,
    }

    new CustomResponse(res).send({ data: responseNewProductStock })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getStockByProduct = async (req: Request, res: Response) => {
  const { language } = req.body
  const { productIsbn } = req.query

  try {
    const totalStock = await prisma.productStock.aggregate({
      _sum: {
        Art_Stock: true,
      },
      where: {
        productIsbn: String(productIsbn), // Adjusted to match your field
      },
    })

    if (!totalStock._sum.Art_Stock) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    new CustomResponse(res).send({
      data: { productIsbn, totalStock: totalStock._sum.Art_Stock },
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getProductStock = async (req: Request, res: Response) => {
  const { language } = req.body
  const { productIsbn, magasinId } = req.query

  try {
    const stock = await prisma.productStock.findUnique({
      where: {
        productIsbn_magasinId: {
          productIsbn: String(productIsbn), // Adjusted to match your field
          magasinId: Number(magasinId),
        },
      },
    })

    if (!stock) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const responseStock = {
      id: stock.id,
      productIsbn: stock.productIsbn,
      magasinId: stock.magasinId,
      stock: stock.Art_Stock,
    }

    new CustomResponse(res).send({ data: responseStock })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getAllStock = async (req: Request, res: Response) => {
  const { language } = req.body

  try {
    const allStock = await prisma.productStock.findMany({
      include: {
        product: true, // Assuming you have this relation in your schema
        magasin: true, // Assuming you have this relation in your schema
      },
    })

    const responseAllStock = allStock.map((stock) => ({
      id: stock.id,
      productIsbn: stock.productIsbn,
      magasinId: stock.magasinId,
      stock: stock.Art_Stock,
      productName: stock.product.Art_Titre,
      magasinName: stock.magasin.magasinName,
    }))

    new CustomResponse(res).send({ data: responseAllStock })
  } catch (error) {
    handleError(error, res, language)
  }
}

const updateProductStock = async (req: Request, res: Response) => {
  const { language, productIsbn, magasinId, stock } = req.body

  try {
    const existingStock = await prisma.productStock.findUnique({
      where: {
        productIsbn_magasinId: {
          productIsbn: productIsbn,
          magasinId,
        },
      },
    })

    if (!existingStock) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const updatedProductStock = await prisma.productStock.update({
      where: {
        productIsbn_magasinId: {
          productIsbn: productIsbn,
          magasinId,
        },
      },
      data: { Art_Stock: stock },
    })

    const responseUpdatedProductStock = {
      id: updatedProductStock.id,
      productIsbn: updatedProductStock.productIsbn,
      magasinId: updatedProductStock.magasinId,
      stock: updatedProductStock.Art_Stock,
    }

    new CustomResponse(res).send({ data: responseUpdatedProductStock })
  } catch (error) {
    handleError(error, res, language)
  }
}

const deleteStock = async (req: Request, res: Response) => {
  const { productIsbn, magasinId, language } = req.body

  try {
    // Check if both productIsbn and magasinId are missing
    if (!productIsbn && !magasinId) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    // Build where condition based on provided parameters
    const whereCondition: any = {}
    if (productIsbn) whereCondition.productIsbn = String(productIsbn) // Adjusted to match your field
    if (magasinId) whereCondition.magasinId = Number(magasinId)

    // Check if any stock entry matches the condition
    const existingStock = await prisma.productStock.findMany({
      where: whereCondition,
    })

    if (existingStock.length === 0) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    // Delete the stock based on the condition
    await prisma.productStock.deleteMany({
      where: whereCondition,
    })

    new CustomResponse(res).send({
      message: 'Stock deleted successfully.',
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

export { createProductStock, getStockByProduct, getProductStock, getAllStock, updateProductStock, deleteStock }
