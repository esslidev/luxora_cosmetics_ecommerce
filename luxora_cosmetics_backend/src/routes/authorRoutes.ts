import express from 'express'
import { integrationAuthMiddleware, isAdminMiddleware } from '../middlewares/authMidleware'

const authorController = require('../controllers/authorController')

const authorRouter = express.Router()

// Define the routes
authorRouter.put('/author/update', isAdminMiddleware, authorController.updateAuthor)
authorRouter.delete('/author/delete', isAdminMiddleware, authorController.deleteAuthor)
authorRouter.get('/author', integrationAuthMiddleware, authorController.getAuthor)
authorRouter.get('/authors', integrationAuthMiddleware, authorController.getAuthors)

export default authorRouter
