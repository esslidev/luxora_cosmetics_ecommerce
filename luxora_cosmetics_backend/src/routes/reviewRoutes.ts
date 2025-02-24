import express from 'express'
import { authMiddleware, integrationAuthMiddleware, isAdminMiddleware } from '../middlewares/authMidleware'

const reviewController = require('../controllers/reviewController')

const reviewRouter = express.Router()

// Define the routes
reviewRouter.post('/review/create', authMiddleware, reviewController.createReview)
reviewRouter.put('/review/update', authMiddleware, isAdminMiddleware, reviewController.updateReview)
reviewRouter.put('/review/approve', authMiddleware, reviewController.setReviewApproval)
reviewRouter.delete('/review/delete', authMiddleware, isAdminMiddleware, reviewController.deleteReview)
reviewRouter.get('/reviews', authMiddleware, isAdminMiddleware, reviewController.getReviews)
reviewRouter.get('/reviews/approved', integrationAuthMiddleware, reviewController.getApprovedReviews)

export default reviewRouter
