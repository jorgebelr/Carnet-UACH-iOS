import { Router } from "express";

import {
    getEvents,
    getEvent,
    createNewEvent,
    reserveEventSpot,
} from "../controllers/event.controller"

const router = Router()

router.get("/", getEvents);
router.get("/:id", getEvent);
router.post("/", createNewEvent)
router.post("/:id/reserve", reserveEventSpot)

export default router;