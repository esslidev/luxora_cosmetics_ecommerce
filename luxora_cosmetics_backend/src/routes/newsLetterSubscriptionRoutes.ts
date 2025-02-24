import express from 'express'
import { authMiddleware, isAdminMiddleware, integrationAuthMiddleware } from '../middlewares/authMidleware'

const newsLetterSubscriptionController = require('../controllers/newsLetterSubscriptionController')

const newsLetterSubscriptionRouter = express.Router()

// Define the routes
newsLetterSubscriptionRouter.post(
  '/newsletter/subscribe',
  integrationAuthMiddleware,
  newsLetterSubscriptionController.subscribeEmail
)
newsLetterSubscriptionRouter.put(
  '/newsletter/unsubscribe',
  authMiddleware,
  isAdminMiddleware,
  newsLetterSubscriptionController.unsubscribeEmail
)
newsLetterSubscriptionRouter.get(
  '/newsletter/subscriptions',
  authMiddleware,
  isAdminMiddleware,
  newsLetterSubscriptionController.getSubscriptions
)

export default newsLetterSubscriptionRouter
