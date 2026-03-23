import type { Request, Response } from "express";
import * as eventService from "../services/event.service"
import { Category } from "../enums/event-category.enum";

type IdParams = {
    id: string;
};

type CodeParams = {
    eventCode: string;
};

// Obtener todos los eventos
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

// Obtener un evento en especifico por su _id de mongo
export async function getEventByID(req: Request<IdParams>, res: Response) {
    try {
        const { id } = req.params;
        if (!id) {
            return res.status(404).json({
                message: "Id is required",
            })
        }

        const event = await eventService.getEventByID(id);

        if (!event) {
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

// Obtener un evento por su codigo de evento
export async function getEventByCode(req: Request<CodeParams>, res: Response) {
    try {
        const { eventCode } = req.params;

        if (!eventCode) {
            return res.status(404).json({
                message: "Event Code is required",
            });
        }

        const event = await eventService.getEventByCode(eventCode);

        console.log(event)
            ;
        if (!event) {
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


// Crear un nuevo evento
export async function createNewEvent(req: Request, res: Response) {
    try {
        const { title, category, place, description, date, isLimited, maxCapacity } = req.body

        if (!title || !category || !date || !maxCapacity) {
            return res.status(400).json({
                message: "title, category, date and maxCapacity are required"
            })
        }

        if (!Object.values(Category).includes(category)) {
            return res.status(400).json({
                message: "Invalid Category",
            })
        }

        let imageUrl: string | undefined = undefined;
        if (req.file) {
            imageUrl = `upload/events/${req.file.filename}`;
        }

        const event = await eventService.createEvent({
            title,
            category,
            place,
            description,
            date: new Date(date),
            imageUrl,
            isLimited: Boolean(isLimited),
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

// Actualizar un evento por su codigo de evento
export async function updateEventByCode(req: Request<CodeParams>, res: Response) {
    try {
        const { eventCode } = req.params;
        const { title, category, place, description, date, isLimited, maxCapacity } = req.body;

        if (!eventCode) {
            return res.status(404).json({
                message: "Event Code is required",
            });
        }

        const event = await eventService.updateEventByCode(eventCode, {
            title,
            category,
            place,
            description,
            date: new Date(date),
            isLimited: Boolean(isLimited),
            maxCapacity: Number(maxCapacity),
        });

        if (!event) {
            return res.status(404).json({
                message: "Event not found",
            });
        }

        return res.json(event);
    } catch (error) {
        console.error("Error updating event: ", error);
        return res.status(500).json({
            message: "Internal server error",
        })
    }
}


// Reservar un evento por medio del _id de mongo
export async function reserveEventSpotByID(req: Request<IdParams>, res: Response) {
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

// Reservar un evento por medio de su codigo de evento
export async function reserveEventSpotByEventCode(req: Request<CodeParams>, res: Response) {
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
