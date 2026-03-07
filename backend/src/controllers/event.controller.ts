import type { Request, Response } from "express";
import * as eventService from "../services/event.service"
import { Category } from "../enums/event-category.enum";

type IdParams = {
    id: string;
};

type CodeParams = {
    eventCode: string;
};

export async function getEvents(_req: Request, res: Response) {
    try {
        const events = await eventService.getAllEvents();
        return res.json(events);
    } catch (error) {
        console.error("Error greeting events: ", error);
        return res.status(500).json({
            message: "Internal Server Error",
        });
    }
}

export async function getEventByID(req: Request<IdParams>, res: Response){
    try {
        const { id } = req.params;
        if (!id){
            return res.status(404).json({
                message: "Id is required",
            })
        }

        const event = eventService.getEventByID(id);

        if (!event){
            return res.status(400).json({
                message: "Event not found",
            })
        }

        return res.json(event)

    } catch (error) {
        console.error("Error getting event: ", error);
        return res.status(500).json({
            message: "Internal Server Error",
        });
    }
}

export async function getEventByCode(req: Request<CodeParams>, res: Response) {
    try {
        const { eventCode } = req.params;

        if (!eventCode){
            return res.status(404).json({
                message: "Event Code is required",
            });
        }

        const event = await eventService.getEventByCode(eventCode);

        console.log(event)
;
        if (!event){
            return res.status(400).json({
                message: "Event not found",
            });
        }

        return res.json(event)
    } catch (error) {
        console.error("Error getting event: ", error);
        return res.status(500).json({
            message: "Internal server Error",
        });
    }
}

export async function createNewEvent(req: Request, res: Response){
    try{
        const { title, category, description, date, maxCapacity} = req.body

        if (!title || !category || !date || !maxCapacity){
            return res.status(400).json({
                message: "title, category, date and maxCapacity are required"
            })
        }

        if (!Object.values(Category).includes(category)) {
            return res.status(400).json({
                message: "Invalid Category",
            })
        }

        const event = await eventService.createEvent({
            title,
            category,
            description,
            date: new Date(date),
            maxCapacity: Number(maxCapacity),
        });

        return res.status(201).json({
            message: "Event created succesfully",
            event: event
        });
    } catch (error) {
        console.error("Error creating event: ", error);

        res.status(500).json({
            message: "Internal server error",
        });

    }
}

export async function reserveEventSpotByID(req: Request<IdParams>, res: Response){
    try {
        const { id } = req.params;
        const updatedEvent = await eventService.reserveSpotByID(id);

        if (!updatedEvent) {
            return res.status(409).json({
                message: "Event full or does not exist",
            });
        }

        return res.json(updatedEvent);
    } catch (error) {
        console.error("Error reserving spot: ", error);
        return res.status(500).json({
            message: "Internal server error",
        })
    }
}

export async function reserveEventSpotByEventCode(req: Request<CodeParams>, res: Response){
    try {
        const { eventCode } = req.params;
        const updatedEvent = await eventService.reserveSpotByEventCode(eventCode);

        if (!updatedEvent) {
            return res.status(409).json({
                message: "Event full or does not exist",
            });
        }

        return res.json(updatedEvent);
    } catch (error) {
        console.error("Error reserving spot: ", error);
        return res.status(500).json({
            message: "Internal server error",
        })
    }
}
