import express from 'express'
import { isAdminMiddleware } from '../middlewares/authMidleware'

const orderController = require('../controllers/orderController')

const orderRouter = express.Router()

// Define the routes
orderRouter.post('/order/create', orderController.createOrder)
orderRouter.post('/addItemToOrder', orderController.addItemToOrder)
orderRouter.put('/updateOrderItem', orderController.updateOrderItem)
orderRouter.delete('/removeItemFromOrder', orderController.removeItemFromOrder)
orderRouter.put('/updateOrder', orderController.updateOrder)
orderRouter.get('/getAllOrders', orderController.getAllOrders)
orderRouter.get('/getOrdersByUserId', orderController.getOrdersByUserId)
orderRouter.get('/getOrdersByMagasinId', orderController.getOrdersByMagasinId)
orderRouter.get('/getOrderById', orderController.getOrderById)
orderRouter.delete('/deleteOrder', orderController.deleteOrder)

export default orderRouter