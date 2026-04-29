import { Router } from "express";

import {
    getEvents,
    getEventByID,
    getEventByCode,
    createNewEvent,
    reserveEventSpotByID,
    reserveEventSpotByCode,
    updateEventByCode,
} from "../controllers/event.controller"

import { uploadEventImage } from "../middlewares/upload.middleware";

const router = Router()

router.get("/", getEvents);
router.get("/id/:id", getEventByID);
router.get("/eventCode/:eventCode", getEventByCode);
router.post("/", uploadEventImage.single("image"), createNewEvent)
router.post("/id/reserve/:id", reserveEventSpotByID)
router.post("/eventcCode/reserve/:eventCode", reserveEventSpotByCode)
router.patch("/eventCode/:eventCode", uploadEventImage.single("image"), updateEventByCode)


export default router