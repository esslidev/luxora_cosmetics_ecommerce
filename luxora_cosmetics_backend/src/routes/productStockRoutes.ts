import express from 'express'
import { isAdminMiddleware } from '../middlewares/authMidleware'

const productStockController = require('../controllers/productStockController')

const productStockRouter = express.Router()

// Define the routes
productStockRouter.post('/createProductStock', productStockController.createProductStock)
productStockRouter.get('/getStockByProduct', productStockController.getStockByProduct)
productStockRouter.get('/getProductStock', productStockController.getProductStock)
productStockRouter.get('/getAllStock', productStockController.getAllStock)
productStockRouter.put('/updateProductStock', productStockController.updateProductStock)
productStockRouter.delete('/deleteStock', productStockController.deleteStock)

export default productStockRouter