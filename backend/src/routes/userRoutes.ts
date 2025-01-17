import express from 'express'
import { isAdminMiddleware } from '../middlewares/authMidleware'

const userController = require('../controllers/userController')

const userRouter = express.Router()

// Define the routes
userRouter.put('/user/update', userController.updateUser)
userRouter.put('/user/update/password', userController.updateUserPassword)
userRouter.delete('/user/delete', isAdminMiddleware, userController.deleteUser)
userRouter.get('/all', isAdminMiddleware, userController.getAllUsers)
userRouter.get('/user', userController.getUser)

export default userRouter
