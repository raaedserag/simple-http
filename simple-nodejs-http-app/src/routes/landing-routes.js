import { Router } from "express";
import * as healthCheckControllers from "../controllers/health-checks-controller.js"
import {getCurrentTime} from "../helpers/time-helper.js"
const router = Router();

router.get("/", (req, res) => res.send(`Welcome to a simple HTTP app, current server time is ${getCurrentTime()}`));
router.get("/live", healthCheckControllers.checkLiveStatus);
export default router;