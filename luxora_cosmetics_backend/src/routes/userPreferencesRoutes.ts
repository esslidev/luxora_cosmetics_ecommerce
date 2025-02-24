import express from 'express'
import { isAdminMiddleware } from '../middlewares/authMidleware'

const userPreferencesController = require('../controllers/userPreferencesController')

const userPreferencesRouter = express.Router()

// Define the routes
userPreferencesRouter.post('/createPreferences', userPreferencesController.createPreferences)
userPreferencesRouter.get('/getPreferences', userPreferencesController.getUser)
userPreferencesRouter.put('/updatePreferences', userPreferencesController.updatePreferences)
userPreferencesRouter.delete('/deletePreferences', isAdminMiddleware, userPreferencesController.deletePreferences)

export default userPreferencesRouter
