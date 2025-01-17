import express from 'express'
import { authMiddleware, integrationAuthMiddleware, isAdminMiddleware } from '../middlewares/authMidleware'

const systemMessagesController = require('../controllers/systemMessagesController')

const systemMessagesRouter = express.Router()

// Define the routes
systemMessagesRouter.post('/message/create', authMiddleware, isAdminMiddleware, systemMessagesController.createMessage)
systemMessagesRouter.put('/message/update', authMiddleware, isAdminMiddleware, systemMessagesController.updateMessage)
systemMessagesRouter.delete(
  '/message/delete',
  authMiddleware,
  isAdminMiddleware,
  systemMessagesController.deleteMessage
)
systemMessagesRouter.get('/all', authMiddleware, isAdminMiddleware, systemMessagesController.getAllMessages)
systemMessagesRouter.get('/all/shown', integrationAuthMiddleware, systemMessagesController.getShownMessages)

export default systemMessagesRouter
