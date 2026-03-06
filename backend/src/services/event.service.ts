import { EventModel } from "../models/event.model";
import { Category } from "../enums/event-category.enum";
import type { CreateEventInput } from "../interfaces/create-event-input.interface";

export async function getAllEvents() {
    return await EventModel.find().sort( { date: 1 });
}

export async function getEventByID(id: string){
    return await EventModel.findById(id);
}

export async function createEvent( data: CreateEventInput){
    return await EventModel.create(data)
}

export async function reserveSpot(eventId: string){
    return await EventModel.findOneAndUpdate(
        {
            _id: eventId,
            $expr: { $lt: ["$reservedCount", "$maxCapacity"] },
        },
        {
            $inc: { reservedCount: 1 },
        },
        {
            new: true
        }
    );
}