import express from "express";
import { authMiddleware, integrationAuthMiddleware, isAdminMiddleware } from "../middlewares/authMidleware";
const showcaseController = require("../controllers/showcaseController");
const showcaseRouter = express.Router();


showcaseRouter.put("/showcase/promo/update", showcaseController.updatePromoShowcase);
showcaseRouter.put("/showcase/default/switch-order", showcaseController.switchDefaultShowcaseOrder);
showcaseRouter.put("/showcase/promo/switch-order", showcaseController.switchPromoShowcaseOrder);

showcaseRouter.post("/showcase/item/create", showcaseController.createShowcaseItem);
showcaseRouter.put("/showcase/item/update" , showcaseController.updateShowcaseItem);
showcaseRouter.delete("/showcase/item/delete", showcaseController.deleteShowcaseItem);

showcaseRouter.post("/showcase/item/add-default", showcaseController.addDefaultShowcaseItem);
showcaseRouter.post("/showcase/item/remove-default", showcaseController.removeDefaultShowcaseItem);
showcaseRouter.post("/showcase/item/add-promo", showcaseController.addPromoShowcaseItem);
showcaseRouter.post("/showcase/item/remove-promo", showcaseController.removePromoShowcaseItem);

showcaseRouter.get("/showcase/items", showcaseController.getShowcaseItems);
showcaseRouter.get("/showcase/items/default", showcaseController.getDefaultShowcaseItems);
showcaseRouter.get("/showcase/items/promo", showcaseController.getPromoShowcaseItems);
showcaseRouter.get("/showcase/items/prioritized",showcaseController.getPrioritizedShowcaseItems);




 
export default showcaseRouter;