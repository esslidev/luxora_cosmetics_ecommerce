import express from 'express'

const cartController = require('../controllers/cartController')

const cartRouter = express.Router()

// Define the routes
cartRouter.post('/cart/sync', cartController.syncCart)
cartRouter.get('/cart', cartController.getCartByUserId)
cartRouter.post('/item/add', cartController.addItemToCart)
cartRouter.post('/items/add-many', cartController.addManyItemsToCart)
cartRouter.put('/item/update', cartController.updateCartItem)
cartRouter.delete('/item/remove', cartController.removeItemFromCart)
cartRouter.delete('/clear', cartController.clearCart)

export default cartRouter
