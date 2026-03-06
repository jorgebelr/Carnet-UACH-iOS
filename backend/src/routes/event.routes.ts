import { Router } from "express";

import {
    getEvents,
    getEventByID,
    getEventByCode,
    createNewEvent,
    reserveEventSpotByID,
    reserveEventSpotByEventCode,
} from "../controllers/event.controller"

const router = Router()

router.get("/", getEvents);
router.get("/id/:id", getEventByID);
router.get("/eventCode/:eventCode", getEventByCode);
router.post("/", createNewEvent)
router.post("/id/reserve/:id", reserveEventSpotByID)
router.post("/eventcCode/reserve/:eventCode", reserveEventSpotByEventCode)


export default router