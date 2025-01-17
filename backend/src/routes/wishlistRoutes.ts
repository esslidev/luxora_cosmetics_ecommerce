import express from 'express'
import { isAdminMiddleware } from '../middlewares/authMidleware'

const wishlistController = require('../controllers/wishlistController')

const wishlistRouter = express.Router()

// Define the routes
wishlistRouter.post('/wishlist/sync', wishlistController.syncWishlist)
wishlistRouter.get('/wishlist', wishlistController.getWishlistByUserId)
wishlistRouter.post('/item/add', wishlistController.addItemToWishlist)
wishlistRouter.put('/item/update', wishlistController.updateWishlistItem)
wishlistRouter.delete('/item/remove', wishlistController.removeItemFromWishlist)
wishlistRouter.delete('/clear', wishlistController.clearWishlist)

export default wishlistRouter
