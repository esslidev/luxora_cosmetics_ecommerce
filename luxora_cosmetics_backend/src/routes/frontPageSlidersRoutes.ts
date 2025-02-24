import express from 'express'
import { authMiddleware, integrationAuthMiddleware, isAdminMiddleware } from '../middlewares/authMidleware'
const showcaseController = require('../controllers/frontPageSlidersController')
const showcaseRouter = express.Router()

//---------------------------------------------------------------------//

showcaseRouter.post('/showcase/item/create', authMiddleware, isAdminMiddleware, showcaseController.createShowcaseItem)
showcaseRouter.put('/showcase/item/update', authMiddleware, isAdminMiddleware, showcaseController.updateShowcaseItem)
showcaseRouter.delete('/showcase/item/delete', authMiddleware, isAdminMiddleware, showcaseController.deleteShowcaseItem)

//---------------------------------------------------------------------//

showcaseRouter.post(
  '/showcase/default/item/add',
  authMiddleware,
  isAdminMiddleware,
  showcaseController.addItemToDefaultShowcase
)
showcaseRouter.delete(
  '/showcase/default/item/remove',
  authMiddleware,
  isAdminMiddleware,
  showcaseController.removeItemFromDefaultShowcase
)
showcaseRouter.put(
  '/showcase/default/switch-order',
  authMiddleware,
  isAdminMiddleware,
  showcaseController.switchDefaultShowcaseOrder
)

//---------------------------------------------------------------------//

showcaseRouter.post(
  '/showcase/promo/item/add',
  authMiddleware,
  isAdminMiddleware,
  showcaseController.addItemToPromoShowcase
)
showcaseRouter.put(
  '/showcase/promo/item/update',
  authMiddleware,
  isAdminMiddleware,
  showcaseController.updatePromoShowcaseItem
)
showcaseRouter.delete(
  '/showcase/promo/item/remove',
  authMiddleware,
  isAdminMiddleware,
  showcaseController.removeItemFromPromoShowcase
)
showcaseRouter.put(
  '/showcase/promo/switch-order',
  authMiddleware,
  isAdminMiddleware,
  showcaseController.switchPromoShowcaseOrder
)

//---------------------------------------------------------------------//

showcaseRouter.get('/showcase/items', authMiddleware, isAdminMiddleware, showcaseController.getShowcaseItems)
showcaseRouter.get(
  '/showcase/items/default',
  authMiddleware,
  isAdminMiddleware,
  showcaseController.getDefaultShowcaseItems
)
showcaseRouter.get('/showcase/items/promo', authMiddleware, isAdminMiddleware, showcaseController.getPromoShowcaseItems)
showcaseRouter.get(
  '/showcase/items/prioritized',
  integrationAuthMiddleware,
  showcaseController.getPrioritizedShowcaseItems
)

export default showcaseRouter
