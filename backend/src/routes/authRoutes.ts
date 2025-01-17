import express from 'express'

import { authMiddleware, integrationAuthMiddleware } from '../middlewares/authMidleware'

const authController = require('../controllers/authController')

const authRouter = express.Router()

// Define the routes
authRouter.post('/sign_up', integrationAuthMiddleware, authController.signUp)
authRouter.post('/sign_in', integrationAuthMiddleware, authController.signIn)
authRouter.post('/sign_out', authMiddleware, authController.signOut)
authRouter.post('/password/reset/request', integrationAuthMiddleware, authController.requestPasswordReset)
authRouter.post('/password/reset', integrationAuthMiddleware, authController.resetPassword)
authRouter.post('/email/verify/request', authMiddleware, authController.requestEmailVerification)
authRouter.post('/email/verify', integrationAuthMiddleware, authController.verifyEmail)
authRouter.post('/access/renew', integrationAuthMiddleware, authController.renewAccess)

export default authRouter
