import express from 'express'
import { authMiddleware, integrationAuthMiddleware, isAdminMiddleware } from '../middlewares/authMidleware'

const reviewController = require('../controllers/reviewController')

const reviewRouter = express.Router()

// Define the routes
reviewRouter.post('/review/create', authMiddleware, isAdminMiddleware, reviewController.createReview)
reviewRouter.put('/review/update', authMiddleware, isAdminMiddleware, reviewController.updateReview)
reviewRouter.delete('/review/delete', authMiddleware, isAdminMiddleware, reviewController.deleteReview)
reviewRouter.get('/reviews', integrationAuthMiddleware, reviewController.getReviews)

export default reviewRouter
