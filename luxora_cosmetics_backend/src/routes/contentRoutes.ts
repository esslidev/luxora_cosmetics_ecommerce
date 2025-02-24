import express from 'express'
import { authMiddleware, integrationAuthMiddleware, isAdminMiddleware } from '../middlewares/authMidleware'

const contentController = require('../controllers/contentController')

const contentRouter = express.Router()

// Define the routes
contentRouter.post('/content/create', contentController.createContent)
contentRouter.put('/content/update', contentController.updateContent)
contentRouter.delete('/content/delete', contentController.deleteContent)
contentRouter.get('/content', contentController.getContent)
contentRouter.get('/contents', contentController.getContents)

export default contentRouter
