import express from 'express'
import { authMiddleware, integrationAuthMiddleware, isAdminMiddleware } from '../middlewares/authMidleware'

const systemPreferencesController = require('../controllers/systemPreferencesController')

const systemPreferencesRouter = express.Router()

// Define the routes
systemPreferencesRouter.put(
  '/system-preferences/update',
  authMiddleware,
  isAdminMiddleware,
  systemPreferencesController.updateSystemPreferences
)
systemPreferencesRouter.get(
  '/system-preferences',
  integrationAuthMiddleware,
  systemPreferencesController.getSystemPreferences
)

export default systemPreferencesRouter
