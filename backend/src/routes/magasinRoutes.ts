import express from 'express'
import { isAdminMiddleware } from '../middlewares/authMidleware'

const magasinController = require('../controllers/magasinController')

const magasinRouter = express.Router()

// Define the routes
magasinRouter.post('/createMagasin', magasinController.createMagasin)
magasinRouter.get('/getMagasinById', magasinController.getMagasinById)
magasinRouter.get('/getMagasins', magasinController.getMagasins)
magasinRouter.get('/getAllMagasins', magasinController.getAllMagasins)
magasinRouter.put('/updateMagasin', magasinController.updateMagasin)
magasinRouter.delete('/deleteMagasinById', magasinController.deleteMagasinById)

export default magasinRouter