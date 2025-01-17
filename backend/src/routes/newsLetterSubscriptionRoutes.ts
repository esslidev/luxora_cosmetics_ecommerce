import express from 'express'
import { isAdminMiddleware } from '../middlewares/authMidleware'

const newsLetterSubscriptionController = require('../controllers/newsLetterSubscriptionController')

const newsLetterSubscriptionRouter = express.Router()

// Define the routes
newsLetterSubscriptionRouter.post('/subscribeEmail', newsLetterSubscriptionController.subscribeEmail)
newsLetterSubscriptionRouter.put('/unsubscribeEmail', newsLetterSubscriptionController.unsubscribeEmail)
newsLetterSubscriptionRouter.get('/getSubscribedEmails', newsLetterSubscriptionController.getSubscribedEmails)

export default newsLetterSubscriptionRouter