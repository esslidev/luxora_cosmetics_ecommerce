import { OrderStatus, PrismaClient, Product } from '@prisma/client'
import { Request, Response } from 'express'
import { HttpError } from '../core/resources/response/httpError'
import { handleError } from '../core/utils/errorHandler'
import CustomResponse from '../core/resources/response/customResponse'
import { HttpStatusCode } from '../core/enums/response/httpStatusCode'
import { errorResponse } from '../core/resources/response/localizedErrorResponse'

const prisma = new PrismaClient()
const createProduct = async (req: Request, res: Response) => {
  const {
    language,
    isbn,
    primaryCategoryNumber,
    primaryFormatIsbn,
    title,
    imageUrl,
    author,
    editor,
    publicationDate,
    description,
    price,
    pricePromo,
    pricePromoStartDate,
    pricePromoEndDate,
    pagesNumber,
    weight,
    width,
    height,
    thickness,
    isPublic,
    formatType,
  } = req.body

  try {
    // Check for existing product
    const existingProduct = await prisma.product.findUnique({
      where: { Art_Ean13: isbn },
    })

    if (existingProduct) {
      throw new HttpError(
        HttpStatusCode.CONFLICT,
        errorResponse(language).errorTitle.PRODUCT_ALREADY_EXISTS,
        errorResponse(language).errorMessage.PRODUCT_ALREADY_EXISTS
      )
    }

    // Convert dates to ISO-8601 format if provided
    const formattedPublicationDate = new Date(publicationDate).toISOString()
    const formattedPricePromoStartDate = pricePromoStartDate ? new Date(pricePromoStartDate).toISOString() : null
    const formattedPricePromoEndDate = pricePromoEndDate ? new Date(pricePromoEndDate).toISOString() : null

    // Create the main product
    const newProduct = await prisma.product.create({
      data: {
        Art_Ean13: isbn,
        primaryCategoryNumber,
        primaryFormatIsbn,
        Art_Titre: title,
        Art_Image_Url: imageUrl,
        Art_Editeur: editor,
        Art_DateParu: formattedPublicationDate,
        Art_Description: description,
        Art_Prix: price,
        Art_Prix_Promo: pricePromo,
        Art_DateDPromo: formattedPricePromoStartDate,
        Art_DateFPromo: formattedPricePromoEndDate,
        Art_NmbrPages: pagesNumber,
        Art_Poids: weight,
        Art_Largeur: width,
        Art_Hauteur: height,
        Art_Epaisseur: thickness,
        author: author,
        isPublic,
        formatType,
      },
      include: { author: true },
    })

    // Prepare the response
    const responseNewProduct = {
      id: newProduct.id,
      isbn: newProduct.Art_Ean13,
      primaryCategoryNumber: newProduct.primaryCategoryNumber,
      primaryFormatIsbn: newProduct.primaryFormatIsbn,
      title: newProduct.Art_Titre,
      imageUrl: newProduct.Art_Image_Url,
      author: newProduct.author,
      editor: newProduct.Art_Editeur,
      publicationDate: newProduct.Art_DateParu,
      description: newProduct.Art_Description,
      price: newProduct.Art_Prix,
      pricePromo: newProduct.Art_Prix_Promo,
      pagesNumber: newProduct.Art_NmbrPages,
      weight: newProduct.Art_Poids,
      width: newProduct.Art_Largeur,
      height: newProduct.Art_Hauteur,
      thickness: newProduct.Art_Epaisseur,
      formatType: newProduct.formatType,
    }

    new CustomResponse(res).send({ data: responseNewProduct })
  } catch (error) {
    handleError(error, res, language)
  }
}

const createProducts = async (req: Request, res: Response) => {
  const { language, products } = req.body

  try {
    // Validate that products is an array
    if (!Array.isArray(products) || products.length === 0) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_INPUT,
        errorResponse(language).errorMessage.INVALID_INPUT
      )
    }

    // Prepare the products data for creation
    const productsToCreate = products.map((product) => {
      const {
        isbn,
        primaryFormatIsbn,
        primaryCategoryNumber,
        title,
        imageUrl,
        author,
        editor,
        publicationDate,
        description,
        price,
        pricePromo,
        pricePromoStartDate,
        pricePromoEndDate,
        pagesNumber,
        weight,
        width,
        height,
        thickness,
        isPublic,
        formatType,
      } = product

      if (!isbn) {
        throw new HttpError(
          HttpStatusCode.BAD_REQUEST,
          errorResponse(language).errorTitle.INVALID_INPUT,
          errorResponse(language).errorMessage.INVALID_INPUT
        )
      }

      return {
        Art_Ean13: isbn,
        primaryCategoryNumber,
        primaryFormatIsbn: primaryFormatIsbn,
        Art_Titre: title,
        Art_Image_Url: imageUrl,
        author: author,
        Art_Editeur: editor,
        Art_DateParu: publicationDate ? new Date(publicationDate).toISOString() : null,
        Art_Description: description,
        Art_Prix: price,
        Art_Prix_Promo: pricePromo,
        Art_DateDPromo: pricePromoStartDate ? new Date(pricePromoStartDate).toISOString() : null,
        Art_DateFPromo: pricePromoEndDate ? new Date(pricePromoEndDate).toISOString() : null,
        Art_NmbrPages: pagesNumber,
        Art_Poids: weight,
        Art_Largeur: width,
        Art_Hauteur: height,
        Art_Epaisseur: thickness,
        isPublic,
        formatType,
      }
    })

    // Check for existing products (Ean13) before creation
    const existingProducts = await prisma.product.findMany({
      where: {
        Art_Ean13: {
          in: productsToCreate.map((product) => product.Art_Ean13).filter((isbn) => isbn),
        },
      },
    })

    if (existingProducts.length > 0) {
      throw new HttpError(
        HttpStatusCode.CONFLICT,
        errorResponse(language).errorTitle.PRODUCT_ALREADY_EXISTS,
        errorResponse(language).errorMessage.PRODUCT_ALREADY_EXISTS
      )
    }

    // Create the products using createMany
    await prisma.product.createMany({
      data: productsToCreate,
    })

    // Prepare response for the created products
    const responseCreatedProducts = productsToCreate.map((product) => ({
      isbn: product.Art_Ean13,
      primaryCategoryNumber: product.primaryCategoryNumber,
      primaryFormatIsbn: product.primaryFormatIsbn,
      title: product.Art_Titre,
      imageUrl: product.Art_Image_Url,
      author: product.author,
      editor: product.Art_Editeur,
      publicationDate: product.Art_DateParu,
      description: product.Art_Description,
      price: product.Art_Prix,
      pricePromo: product.Art_Prix_Promo,
      pricePromoStartDate: product.Art_DateDPromo,
      pricePromoEndDate: product.Art_DateFPromo,
      pagesNumber: product.Art_NmbrPages,
      weight: product.Art_Poids,
      width: product.Art_Largeur,
      height: product.Art_Hauteur,
      thickness: product.Art_Epaisseur,
      isPublic: product.isPublic,
      formatType: product.formatType,
    }))

    new CustomResponse(res).send({ data: responseCreatedProducts })
  } catch (error) {
    handleError(error, res, language)
  }
}

const updateProduct = async (req: Request, res: Response) => {
  const {
    language,
    id,
    isbn,
    primaryCategoryNumber,
    primaryFormatIsbn,
    title,
    imageUrl,
    author,
    editor,
    publicationDate,
    description,
    price,
    pricePromo,
    pricePromoStartDate,
    pricePromoEndDate,
    pagesNumber,
    weight,
    width,
    height,
    thickness,
    isPublic,
    formatType,
  } = req.body

  try {
    // Validate input
    if (!id && !isbn) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    const product = await prisma.product.findFirst({
      where: {
        OR: [{ id }, { Art_Ean13: isbn }],
      },
    })

    if (!product) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const updatedData = {
      ...(isbn && { Art_Ean13: isbn }),
      ...(primaryCategoryNumber && { primaryCategoryNumber }),
      ...(primaryFormatIsbn && { primaryFormatIsbn }),
      ...(title && { Art_Titre: title }),
      ...(imageUrl && { Art_Image_Url: imageUrl }),
      ...(author && { author: author }),
      ...(editor && { Art_Editeur: editor }),
      ...(publicationDate && { Art_DateParu: new Date(publicationDate).toISOString() }),
      ...(description && { Art_Description: description }),
      ...(price && { Art_Prix: price }),
      ...(pricePromo && { Art_Prix_Promo: pricePromo }),
      ...(pricePromoStartDate && { Art_DateDPromo: new Date(pricePromoStartDate).toISOString() }),
      ...(pricePromoEndDate && { Art_DateFPromo: new Date(pricePromoEndDate).toISOString() }),
      ...(pagesNumber && { Art_NmbrPages: pagesNumber }),
      ...(weight && { Art_Poids: weight }),
      ...(width && { Art_Largeur: width }),
      ...(height && { Art_Hauteur: height }),
      ...(thickness && { Art_Epaisseur: thickness }),
      ...(isPublic !== undefined && { isPublic }),
      ...(formatType && { formatType: formatType }),
    }

    // Update the product
    const updatedProduct = await prisma.product.update({
      where: { id: parseInt(id) },
      data: updatedData,
      include: {
        stock: true,
        author: true,
        formats: {
          include: {
            stock: true,
          },
        },
      },
    })

    // Prepare the response
    const responseUpdatedProduct = {
      id: updatedProduct.id,
      isbn: updatedProduct.Art_Ean13,
      primaryCategoryNumber: updatedProduct.primaryCategoryNumber,
      primaryFormatIsbn: updatedProduct.primaryFormatIsbn,
      title: updatedProduct.Art_Titre,
      imageUrl: updatedProduct.Art_Image_Url,
      author: updatedProduct.author,
      editor: updatedProduct.Art_Editeur,
      publicationDate: updatedProduct.Art_DateParu,
      description: updatedProduct.Art_Description,
      price: updatedProduct.Art_Prix,
      pricePromo: updatedProduct.Art_Prix_Promo,
      pagesNumber: updatedProduct.Art_NmbrPages,
      weight: updatedProduct.Art_Poids,
      width: updatedProduct.Art_Largeur,
      height: updatedProduct.Art_Hauteur,
      thickness: updatedProduct.Art_Epaisseur,
      isPublic: updatedProduct.isPublic,
      formatType: product.formatType,
      stock: updatedProduct.stock.map((stock) => ({
        magasinId: stock.magasinId,
        stock: stock.Art_Stock,
      })),
      formats: updatedProduct.formats.map((format) => ({
        isbn: format.Art_Ean13,
        title: format.Art_Titre,
        imageUrl: format.Art_Image_Url,
        author: updatedProduct.author,
        editor: format.Art_Editeur,
        publicationDate: format.Art_DateParu,
        description: format.Art_Description,
        price: format.Art_Prix,
        pricePromo: format.Art_Prix_Promo,
        pagesNumber: format.Art_NmbrPages,
        weight: format.Art_Poids,
        width: format.Art_Largeur,
        height: format.Art_Hauteur,
        thickness: format.Art_Epaisseur,
        isPublic: format.isPublic,
        formatType: product.formatType,
        stock: format.stock.map((stock) => ({
          magasinId: stock.magasinId,
          stock: stock.Art_Stock,
        })),
      })),
    }

    new CustomResponse(res).send({ data: responseUpdatedProduct })
  } catch (error) {
    handleError(error, res, language)
  }
}

// Delete product by ID
const deleteProduct = async (req: Request, res: Response) => {
  const { id, isbn, language } = req.body

  try {
    // Validate input
    if (!id && !isbn) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    const product = await prisma.product.findFirst({
      where: {
        OR: [{ id }, { Art_Ean13: isbn }],
      },
    })

    if (!product) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    await prisma.product.deleteMany({
      where: {
        OR: [{ id }, { Art_Ean13: isbn }],
      },
    })

    new CustomResponse(res).send({ message: 'Product deleted successfully.' })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getProduct = async (req: Request, res: Response) => {
  const { language } = req.body
  const { id, isbn } = req.query

  try {
    if (!id && !isbn) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    const product = await prisma.product.findUnique({
      where: id ? { id: Number(id), isPublic: true } : { Art_Ean13: String(isbn), isPublic: true },
      include: {
        author: true,
        stock: {
          include: {
            magasin: {
              include: {
                Delivery: true,
              },
            },
          },
        },
        formats: {
          include: {
            author: true,
            stock: {
              include: {
                magasin: {
                  include: {
                    Delivery: true,
                  },
                },
              },
            },
          },
        },

        primaryCategory: true,
        reviews: { where: { isPublic: true } },
      },
    })

    if (!product) {
      throw new HttpError(
        HttpStatusCode.NOT_FOUND,
        errorResponse(language).errorTitle.NOT_FOUND,
        errorResponse(language).errorMessage.NOT_FOUND
      )
    }

    const currentDate = new Date()

    const isNewArrival = product.createdAt >= new Date(currentDate.getTime() - 30 * 24 * 60 * 60 * 1000)
    // Fetch top 10 best-selling products
    const topBestSellers = await prisma.orderItem.groupBy({
      by: ['productId'],
      _count: {
        productId: true,
      },
      where: { order: { status: OrderStatus.PAID } },
      orderBy: {
        _count: {
          productId: 'desc',
        },
      },
      take: 10, // Limit to top 10 best-sellers
    })

    const topBestSellerIds = topBestSellers.map((item) => item.productId)
    const isBestSeller = topBestSellerIds.includes(product.id)

    // Check if the PARENT PRODUCT's promo is active
    const isParentProductPromoActive =
      product.Art_DateDPromo && product.Art_DateFPromo
        ? currentDate >= product.Art_DateDPromo && currentDate <= product.Art_DateFPromo
        : false
    const parentProductPricePromo = isParentProductPromoActive ? product.Art_Prix_Promo : null

    const ratingCount = product.reviews.length
    const ratingAverage =
      ratingCount > 0 ? product.reviews.reduce((sum, review) => sum + review.rating, 0) / ratingCount : 0

    // Calculate the smallest delivery time and total stock count
    const parentProductDeliveryTimes = product.stock
      .map((stock) => stock.magasin.Delivery?.deliveryTime)
      .filter((time): time is number => time !== undefined)
    const parentProductDeliveryTime =
      parentProductDeliveryTimes.length > 0 ? Math.min(...parentProductDeliveryTimes) : null

    const parentProductStockCounts = product.stock.map((stock) => stock.Art_Stock)
    const parentProductStockCount = parentProductStockCounts.reduce((sum, stock) => sum + stock, 0) // Sum of all stocks

    // Map formats, applying parent product fields if it exists
    const formats = product.formats.map((format) => {
      const isProductPromoActive =
        format.Art_DateDPromo && format.Art_DateFPromo
          ? currentDate >= format.Art_DateDPromo && currentDate <= format.Art_DateFPromo
          : false
      const productPricePromo = isProductPromoActive ? format.Art_Prix_Promo : null

      // Calculate the smallest delivery time and total stock count
      const productDeliveryTimes = format.stock
        .map((stock) => stock.magasin.Delivery?.deliveryTime)
        .filter((time): time is number => time !== undefined)

      const productDeliveryTime = productDeliveryTimes.length > 0 ? Math.min(...productDeliveryTimes) : null

      const productStockCounts = format.stock.map((stock) => stock.Art_Stock)
      const productStockCount = productStockCounts.reduce((sum, stock) => sum + stock, 0) // Sum of all stocks

      return {
        isbn: format.Art_Ean13,
        title: format.Art_Titre,
        imageUrl: format.Art_Image_Url,
        author: format.author,
        editor: format.Art_Editeur,
        publicationDate: format.Art_DateParu,
        description: format.Art_Description,
        price: format.Art_Prix,
        pricePromo: productPricePromo, // Ensure main variation's promo is prioritized if active
        primaryCategoryPromoPercent: product.primaryCategory?.promoPercent || null,
        pagesNumber: format.Art_NmbrPages,
        weight: format.Art_Poids,
        width: format.Art_Largeur,
        height: format.Art_Hauteur,
        thickness: format.Art_Epaisseur,
        isPublic: format.isPublic,
        formatType: format.formatType,
        deliveryTime: productDeliveryTime,
        stockCount: productStockCount,
      }
    })

    const responseProduct = {
      id: product.id,
      isbn: product.Art_Ean13,
      primaryCategoryNumber: product.primaryCategoryNumber,
      primaryFormatIsbn: product.primaryFormatIsbn,
      title: product.Art_Titre,
      imageUrl: product.Art_Image_Url,
      author: product.author,
      editor: product.Art_Editeur,
      publicationDate: product.Art_DateParu,
      description: product.Art_Description,
      price: product.Art_Prix,
      pricePromo: parentProductPricePromo,
      primaryCategoryPromoPercent: product.primaryCategory?.promoPercent || null,
      pagesNumber: product.Art_NmbrPages,
      weight: product.Art_Poids,
      width: product.Art_Largeur,
      height: product.Art_Hauteur,
      thickness: product.Art_Epaisseur,
      isPublic: product.isPublic,
      formatType: product.formatType,
      deliveryTime: parentProductDeliveryTime,
      stockCount: parentProductStockCount,
      formats,
      isNewArrival,
      isBestSeller,
      ratingCount,
      ratingAverage,
    }

    new CustomResponse(res).send({ data: responseProduct })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getProductsByProductIds = async (req: Request, res: Response) => {
  const { language } = req.body
  const { productIds } = req.query

  try {
    // Ensure productIds is provided
    if (!productIds) {
      throw new HttpError(
        HttpStatusCode.BAD_REQUEST,
        errorResponse(language).errorTitle.INVALID_REQUEST,
        errorResponse(language).errorMessage.INVALID_REQUEST
      )
    }

    ;[]

    const idString = productIds as string
    const parsedProductIds: number[] = idString.split('_').map((productId) => {
      const parsedProductId = Number(productId)
      if (isNaN(parsedProductId)) {
        throw new HttpError(
          HttpStatusCode.BAD_REQUEST,
          errorResponse(language).errorTitle.INVALID_REQUEST,
          errorResponse(language).errorMessage.INVALID_REQUEST
        )
      }
      return parsedProductId
    })

    const orConditions = []
    if (parsedProductIds.length > 0) {
      orConditions.push({ id: { in: parsedProductIds } })
    }

    // Fetch products with filters, sorting, and pagination
    const products = await prisma.product.findMany({
      where: { AND: [{ OR: orConditions }] },
      include: {
        primaryCategory: { select: { promoPercent: true } },
        author: true,
        stock: {
          include: {
            magasin: {
              include: {
                Delivery: true,
              },
            },
          },
        },
      },
    })

    // Fetch top 10 best-selling product IDs
    const topBestSellers = await prisma.orderItem.groupBy({
      by: ['productId'],
      _count: { productId: true },
      where: { order: { status: 'PAID' } },
      orderBy: { _count: { productId: 'desc' } },
      take: 10,
    })

    const topBestSellerIds = topBestSellers.map((item) => item.productId)

    // Prepare response data with custom fields
    const currentDate = new Date()
    const responseProducts = products.map((product) => {
      const isProductPromoActive =
        product.Art_DateDPromo && product.Art_DateFPromo
          ? currentDate >= product.Art_DateDPromo && currentDate <= product.Art_DateFPromo
          : false
      const productPricePromo = isProductPromoActive ? product.Art_Prix_Promo : null

      const isNewArrival = product.createdAt >= new Date(currentDate.getTime() - 30 * 24 * 60 * 60 * 1000)

      const productStockCounts = product.stock.map((stock) => stock.Art_Stock)
      const productStockCount = productStockCounts.reduce((sum, stock) => sum + stock, 0)

      return {
        id: product.id,
        isbn: product.Art_Ean13,
        title: product.Art_Titre,
        imageUrl: product.Art_Image_Url,
        author: product.author,
        price: product.Art_Prix,
        formatType: product.formatType,
        pricePromo: productPricePromo,
        primaryCategoryPromoPercent: product.primaryCategory?.promoPercent ?? null,
        stockCount: productStockCount,
        isNewArrival,
        isBestSeller: topBestSellerIds.includes(product.id),
      }
    })

    // Send response with pagination metadata
    new CustomResponse(res).send({
      data: responseProducts,
    })
  } catch (error) {
    handleError(error, res, language)
  }
}

const getProducts = async (req: Request, res: Response) => {
  const { language } = req.body
  const {
    limit = 10,
    page = 1,
    productIds,
    search,
    categoryNumber,
    isbn,
    title,
    authorName,
    editor,
    categoryName,
    formatType,
    priceRange,
    publicationDate,
    isPublished,
    publishedIn,
    publishedWithin,
    isNewArrivals,
    isBestSellers,
    isPreorder,
    isInStock,
    isOutStock,
    orderByCreateDate,
    orderBySales,
    orderByTitle,
    orderByAuthor,
    orderByPrice,
    orderByPublicationDate,
    orderByStock,
    orderByPreorder,
    sortOrder = 'asc',
  } = req.query

  const take = Number(limit) > 0 ? Number(limit) : 10
  const skip = (Number(page) - 1) * take
  let total: any = 0

  const thirtyDaysAgo = new Date()
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)

  let inStockCount: any = 0
  let preorderCount: any = 0
  let publishedCount: any = 0
  let publishedPast6MonthsCount: any = 0
  let publishedWithin3MonthsCount: any = 0
  let paperbackFormatCount: any = 0
  let grandFormatCount: any = 0

  const filters: string[] = []
  const searchFilters: string[] = []

  if (isbn) filters.push(`p.Art_Ean13 LIKE '%${isbn}%'`)
  if (title) filters.push(`p.Art_Titre LIKE '%${title}%'`)
  if (authorName) filters.push(`CONCAT(a.firstName, ' ', a.lastName) LIKE '%${authorName}%'`)
  if (editor) filters.push(`p.Art_Editeur LIKE '%${editor}%'`)
  if (publicationDate) {
    const parsedDate = new Date(publicationDate as string)
    if (!isNaN(parsedDate.getTime())) {
      filters.push(`p.Art_DateParu = '${parsedDate.toISOString()}'`)
    }
  }
  if (isPublished === 'true') {
    filters.push(`p.Art_DateParu IS NOT NULL AND p.Art_DateParu <= NOW()`)
  }
  if (publishedIn) {
    const parsedDate = new Date(publishedIn as string)
    filters.push(`p.Art_DateParu IS NOT NULL AND p.Art_DateParu BETWEEN '${parsedDate.toISOString()}' AND NOW()`)
  }
  if (publishedWithin) {
    const parsedDate = new Date(publishedWithin as string)
    filters.push(`p.Art_DateParu IS NOT NULL AND p.Art_DateParu BETWEEN NOW() AND '${parsedDate.toISOString()}'`)
  }
  if (categoryNumber) filters.push(`c.categoryNumber = ${Number(categoryNumber)}`)
  if (categoryName) {
    filters.push(`
        EXISTS (
          SELECT 1
          FROM CategoryTranslation ct
          WHERE ct.categoryNumber = c.categoryNumber
          AND ct.name LIKE '%${categoryName}%'
          ${language ? `AND ct.languageCode = '${language}'` : ''}
        )
      `)
  }
  if (productIds) {
    const productIdsArray = (productIds as string).split('_').map((id) => Number(id))
    if (productIdsArray.length > 0) {
      filters.push(`p.id IN (${productIdsArray.join(',')})`)
    }
  }
  if (search) {
    searchFilters.push(`
      p.Art_Ean13 LIKE '%${search}%' OR
      p.Art_Titre LIKE '%${search}%' OR
      p.Art_Editeur LIKE '%${search}%' OR
      CONCAT(a.firstName, ' ', a.lastName) LIKE '%${search}%'
    `)
  }

  if (formatType) {
    filters.push(`
      p.id IN (
        SELECT main.id
        FROM Product main
        LEFT JOIN Product formats ON formats.primaryFormatIsbn = main.Art_Ean13
        WHERE main.primaryFormatIsbn IS NULL
        AND (main.formatType = '${formatType}' OR formats.formatType = '${formatType}')
      )
    `)
  }
  if (priceRange && typeof priceRange === 'string') {
    const priceParts = priceRange.split('_')
    const lowestPrice = priceParts[0] != '' ? Number(priceParts[0]) : null
    const highestPrice = priceParts[1] != '' ? Number(priceParts[1]) : null

    // Case 1: Only lowest price is provided ("lowestPrice_")
    if (lowestPrice != null && highestPrice == null) {
      filters.push(`p.Art_Prix >= ${lowestPrice}`)
    }

    // Case 2: Only highest price is provided ("_highestPrice")
    else if (lowestPrice == null && highestPrice != null) {
      filters.push(`p.Art_Prix <= ${highestPrice}`)
    }

    // Case 3: Both lowest and highest prices are provided ("lowestPrice_highestPrice")
    else if (lowestPrice != null && highestPrice != null) {
      filters.push(`p.Art_Prix BETWEEN ${lowestPrice} AND ${highestPrice}`)
    }
  }
  // Filter by new arrival products (e.g., products created within the last 30 days)
  if (isNewArrivals === 'true') {
    filters.push(`p.createdAt >= '${thirtyDaysAgo.toISOString()}'`)
  }
  // Filter by bestseller products (e.g., based on high sales count)
  if (isBestSellers === 'true') {
    filters.push(`
    EXISTS (
      SELECT 1
      FROM OrderItem oi
      LEFT JOIN \`Order\` o ON oi.orderId = o.id
      WHERE oi.productId = p.id AND o.status = 'PAID'
    )
  `)
  }

  if (isPreorder === 'true') {
    filters.push(`p.isPreorder = true`)
  }
  if (isInStock === 'true') {
    filters.push(`
      EXISTS (
        SELECT 1
        FROM ProductStock ps
        WHERE ps.productIsbn = p.Art_Ean13
        GROUP BY ps.productIsbn
        HAVING SUM(ps.Art_Stock) > 0
      )
    `)
  }
  if (isOutStock === 'true') {
    filters.push(`
      NOT EXISTS (
        SELECT 1
        FROM ProductStock ps
        WHERE ps.productIsbn = p.Art_Ean13
        GROUP BY ps.productIsbn
        HAVING SUM(ps.Art_Stock) > 0
      )
    `)
  }

  const combinedFilters = filters.concat(searchFilters).filter(Boolean).join(' AND ')

  let orderBy = ''
  if (orderBySales === 'true') {
    orderBy = `ORDER BY salesCount ${sortOrder}`
  } else if (orderByCreateDate === 'true') {
    orderBy = `ORDER BY p.createdAt ${sortOrder}`
  } else if (orderByTitle === 'true') {
    orderBy = `ORDER BY p.Art_Titre ${sortOrder}`
  } else if (orderByAuthor === 'true') {
    orderBy = `ORDER BY a.firstName ${sortOrder}, a.lastName ${sortOrder}` // Assuming you want to order by author's first and last name
  } else if (orderByPrice === 'true') {
    orderBy = `ORDER BY p.Art_Prix ${sortOrder}`
  } else if (orderByPublicationDate === 'true') {
    orderBy = `ORDER BY p.Art_DateParu ${sortOrder}`
  } else if (orderByStock === 'true') {
    orderBy = `ORDER BY stockCount ${sortOrder}`
  } else if (orderByPreorder === 'true') {
    orderBy = `ORDER BY p.isPreorder ${sortOrder}`
  } else if (isNewArrivals === 'true') {
    orderBy = 'ORDER BY p.createdAt DESC'
  } else if (isBestSellers === 'true') {
    orderBy = `ORDER BY salesCount DESC`
  }

  try {
    // filtering by category id and its subcategories tree...
    /*if (categoryNumber) {
      let subcategories: any[] = await prisma.$queryRawUnsafe(`
         WITH RECURSIVE category_tree AS (
           SELECT id, categoryNumber, parentId
           FROM Category
           WHERE categoryNumber = ${categoryNumber}
           UNION ALL
           SELECT c.id, c.categoryNumber, c.parentId
           FROM Category c
           INNER JOIN category_tree ct ON ct.id = c.parentId
         )
         SELECT categoryNumber
         FROM category_tree
       `)
      const categoryNumbers = subcategories.map((subCategory: { categoryNumber: number }) => subCategory.categoryNumber)

      if (categoryNumbers.length > 0) {
        // Create the condition string with OR
        const categoryNumberConditions = categoryNumbers
          .map((categoryNumber) => `c.categoryNumber = ${categoryNumber}`)
          .join(' AND ')
        // Add the condition to filters with parentheses
        filters.push(`(${categoryNumberConditions})`)
      }
    }*/
    const products: any[] = await prisma.$queryRawUnsafe(`
      SELECT p.id,
             p.primaryCategoryNumber,
             p.isPublic,
             p.isPreorder,
             p.Art_Ean13,
             p.Art_Titre,
             p.Art_Image_Url,
             p.Art_Prix,
             p.Art_Prix_Promo,
             p.Art_DateDPromo,
             p.Art_DateFPromo,
             p.createdAt,
             JSON_OBJECT('firstName', a.firstName, 'lastName', a.lastName) AS author,
             JSON_OBJECT('promoPercent', pc.promoPercent) AS primaryCategory,
             CAST(
             (
             SELECT SUM(ps.Art_Stock)
             FROM ProductStock ps 
             WHERE ps.productIsbn = p.Art_Ean13
             ) AS SIGNED
            ) AS stockCount,
             (
             SELECT COALESCE(SUM(oi.quantity), 0) 
             FROM OrderItem oi
             LEFT JOIN \`Order\` o ON oi.orderId = o.id AND o.status = 'PAID'
             WHERE oi.productId = p.id
             ) AS salesCount
      FROM \`Product\` p
      LEFT JOIN \`Category\` pc ON p.primaryCategoryNumber = pc.categoryNumber
      JOIN \`_CategoryProducts\` cp ON p.id = cp.B
      JOIN \`Category\` c ON c.id = cp.A
      LEFT JOIN \`CategoryTranslation\` ct ON ct.categoryNumber = c.categoryNumber
      LEFT JOIN \`Author\` a ON p.authorId = a.id
      WHERE p.isPublic = true AND p.primaryFormatIsbn IS NULL
      ${combinedFilters ? `AND (${combinedFilters})` : ''}
      GROUP BY p.id
      ${orderBy}
      LIMIT ${take} OFFSET ${skip}
    `)

    // console.log('Query executed products successfully:', products)

    // Calculate inStockCount
    const inStockCountResult: any = await prisma.$queryRawUnsafe(`
      SELECT COUNT(DISTINCT ps.productIsbn) AS inStockCount
      FROM ProductStock ps
      WHERE ps.Art_Stock > 0
      `)
    inStockCount = inStockCountResult[0]?.inStockCount || 0

    const preorderCountResult: any = await prisma.$queryRawUnsafe(`
      SELECT COUNT(*) AS preorderCount
      FROM Product p
      WHERE p.isPublic = true AND  p.primaryFormatIsbn IS NULL AND p.isPreorder = true
    `)
    preorderCount = preorderCountResult[0]?.preorderCount || 0

    // Calculate publishedCount
    const publishedCountResult: any = await prisma.$queryRawUnsafe(`
    SELECT COUNT(DISTINCT p.id) AS publishedCount
    FROM Product p
    WHERE p.isPublic = true AND p.primaryFormatIsbn IS NULL AND p.Art_DateParu IS NOT NULL
    AND p.Art_DateParu <= NOW()
  `)
    publishedCount = publishedCountResult[0]?.publishedCount || 0

    // Calculate publishedCount
    const publishedPast6MonthsCountResult: any = await prisma.$queryRawUnsafe(`
      SELECT COUNT(DISTINCT p.id) AS publishedPast6MonthsCount
      FROM Product p
      WHERE p.isPublic = true AND p.primaryFormatIsbn IS NULL AND p.Art_DateParu IS NOT NULL
      AND p.Art_DateParu BETWEEN DATE_SUB(NOW(), INTERVAL 6 MONTH) AND NOW()
    `)
    publishedPast6MonthsCount = publishedPast6MonthsCountResult[0]?.publishedPast6MonthsCount || 0

    // Calculate publishedCount
    const publishedWithin3MonthsCountResult: any = await prisma.$queryRawUnsafe(`
      SELECT COUNT(DISTINCT p.id) AS publishedWithin3MonthsCount
      FROM Product p
      WHERE p.isPublic = true AND p.primaryFormatIsbn IS NULL AND p.Art_DateParu IS NOT NULL
      AND p.Art_DateParu BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 3 MONTH)
    `)
    publishedWithin3MonthsCount = publishedWithin3MonthsCountResult[0]?.publishedWithin3MonthsCount || 0

    // Calculate paperbackFormatCount
    const paperbackFormatCountResult: any = await prisma.$queryRawUnsafe(`
    SELECT COUNT(DISTINCT main.id) AS paperbackFormatCount
    FROM Product main
    LEFT JOIN Product formats ON formats.primaryFormatIsbn = main.Art_Ean13
    WHERE main.isPublic = true AND main.primaryFormatIsbn IS NULL
    AND (main.formatType = 'paperback' OR formats.formatType = 'paperback')
  `)
    paperbackFormatCount = paperbackFormatCountResult[0]?.paperbackFormatCount || 0

    // Calculate grandFormatCount
    const grandFormatCountResult: any = await prisma.$queryRawUnsafe(`
    SELECT COUNT(DISTINCT main.id) AS grandFormatCount
    FROM Product main
    LEFT JOIN Product formats ON formats.primaryFormatIsbn = main.Art_Ean13
    WHERE main.isPublic = true AND main.primaryFormatIsbn IS NULL
    AND (main.formatType = 'grand' OR formats.formatType = 'grand')
  `)
    grandFormatCount = grandFormatCountResult[0]?.grandFormatCount || 0

    const totalResult: any = await prisma.$queryRawUnsafe(`
      SELECT COUNT(*) as total
      FROM \`Product\` p
      LEFT JOIN \`_CategoryProducts\` cp ON p.id = cp.B
      LEFT JOIN \`Category\` c ON c.id = cp.A
      LEFT JOIN \`Author\` a ON p.authorId = a.id
      WHERE p.isPublic = true AND p.primaryFormatIsbn IS NULL
      ${combinedFilters ? `AND (${combinedFilters})` : ''}
    `)
    total = totalResult[0]?.total || 0

    // console.log('Query executed total successfully:', total)

    // Fetch top 10 best-selling product IDs
    const topBestSellers = await prisma.orderItem.groupBy({
      by: ['productId'],
      _count: { productId: true },
      where: { order: { status: 'PAID' } },
      orderBy: { _count: { productId: 'desc' } },
      take: 10,
    })
    const topBestSellerIds = topBestSellers.map((item) => item.productId)

    const currentDate = new Date()

    const responseProducts = products.map((product) => {
      const isParentProductPromoActive =
        product.Art_DateDPromo && product.Art_DateFPromo
          ? currentDate >= product.Art_DateDPromo && currentDate <= product.Art_DateFPromo
          : false
      const parentProductPricePromo = isParentProductPromoActive ? product.Art_Prix_Promo : null

      return {
        id: product.id,
        primaryCategoryNumber: product.primaryCategoryNumber,
        isbn: product.Art_Ean13,
        title: product.Art_Titre,
        imageUrl: product.Art_Image_Url,
        author: product.author,
        price: product.Art_Prix,
        pricePromo: parentProductPricePromo,
        primaryCategoryPromoPercent: product.primaryCategory?.promoPercent ?? null,
        stockCount: Number(product.stockCount) ?? 0,
        isPublic: product.isPublic === 1 || product.isPublic === true,
        isPreorder: product.isPreorder === 1 || product.isPreorder === true,
        isNewArrival: new Date(product.createdAt) >= thirtyDaysAgo,
        isBestSeller: topBestSellerIds.includes(product.id),
      }
    })

    new CustomResponse(res).send({
      data: responseProducts,
      filteringData: {
        inStockCount: Number(inStockCount),
        preorderCount: Number(preorderCount),
        publishedCount: Number(publishedCount),
        publishedPast6MonthsCount: Number(publishedPast6MonthsCount),
        publishedWithin3MonthsCount: Number(publishedWithin3MonthsCount),
        paperbackFormatCount: Number(paperbackFormatCount),
        grandFormatCount: Number(grandFormatCount),
      },
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

export { createProduct, createProducts, updateProduct, deleteProduct, getProduct, getProductsByProductIds, getProducts }
