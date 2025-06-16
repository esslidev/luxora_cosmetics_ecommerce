import express from 'express'
import { integrationAuthMiddleware } from '../middlewares/authMidleware'

const productController = require('../controllers/productController')

const productRouter = express.Router()

// Define the routes
productRouter.post('/product/create', productController.createProduct)
productRouter.put('/product/update', productController.updateProduct)
productRouter.delete('/product/delete', productController.deleteProduct)
productRouter.get('/product', integrationAuthMiddleware, productController.getProduct)
productRouter.get('/products', integrationAuthMiddleware, productController.getProducts)

export default productRouter
