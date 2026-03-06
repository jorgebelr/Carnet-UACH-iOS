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
router.get("/eventCode/:code", getEventByCode);
router.post("/", createNewEvent)
router.post("/id/:id/reserve", reserveEventSpotByID)
router.post("/eventcCode/:code/reserve", reserveEventSpotByEventCode)


export default router