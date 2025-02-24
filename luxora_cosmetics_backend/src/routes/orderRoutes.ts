import express from 'express'
import { authMiddleware, isAdminMiddleware, integrationAuthMiddleware } from '../middlewares/authMidleware'

const orderController = require('../controllers/orderController')

const orderRouter = express.Router()

// Définir les routes pour la gestion des commandes

// Créer une commande
orderRouter.post('/order/create', authMiddleware, orderController.createOrder)

// Récupérer une commande spécifique par son identifiant
orderRouter.get('/order', authMiddleware, orderController.getOrder)

// Récupérer toutes les commandes (accès réservé aux administrateurs)
orderRouter.get('/orders/user', authMiddleware, orderController.getUserOrders)

// Mettre à jour le statut d'une commande (accès réservé aux administrateurs)
orderRouter.put('/order/update/status', authMiddleware, isAdminMiddleware, orderController.updateOrderStatus)

export default orderRouter
