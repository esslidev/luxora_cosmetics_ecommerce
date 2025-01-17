import express from 'express'
import { isAdminMiddleware } from '../middlewares/authMidleware'

const categoryController = require('../controllers/categoryController')

const categoryRouter = express.Router()

// Define the routes
categoryRouter.post('/category/create', categoryController.createCategory)
categoryRouter.put('/category/update', categoryController.updateCategory)
categoryRouter.delete('/category/delete', categoryController.deleteCategory)
categoryRouter.get('/all', categoryController.getAllCategories)
categoryRouter.get('/main-categories', categoryController.getMainCategories)
categoryRouter.get('/categories', categoryController.getCategories)
categoryRouter.get('/category', categoryController.getCategory)

export default categoryRouter
