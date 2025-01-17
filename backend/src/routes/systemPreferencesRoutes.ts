import express from 'express'
import { isAdminMiddleware } from '../middlewares/authMidleware'

const systemPreferencesController = require('../controllers/systemPreferencesController')

const systemPreferencesRouter = express.Router()

// Define the routes
systemPreferencesRouter.put('/updateSystemPreferences', systemPreferencesController.updateSystemPreferences)
systemPreferencesRouter.get('/getSystemPreferences', systemPreferencesController.getSystemPreferences)

export default systemPreferencesRouter