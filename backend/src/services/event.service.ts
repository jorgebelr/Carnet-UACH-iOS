import { EventModel } from "../models/event.model";
import { Category } from "../enums/event-category.enum";
import type { CreateEventInput } from "../interfaces/create-event-input.interface";
import { generateEventCode } from "../utils/generate-event-code";

export async function getAllEvents() {
    return await EventModel.find().sort( { date: 1 });
}

export async function getEventByID(id: string){
    return await EventModel.findById(id);
}

export  async function getEventByCode(eventCode: String) {
    return await EventModel.findOne( { eventCode });
}

async function generateUniqueEventCode(category: Category): Promise<string> {
    let eventCode = "";
    let exists = true;

    while (exists) {
        eventCode = generateEventCode(category);
        const existingEvent = await EventModel.findOne( { eventCode });
        exists = !!existingEvent;
    }
    
    return eventCode;
}

export async function createEvent( data: CreateEventInput){
    const eventCode = await generateUniqueEventCode(data.category);
    return await EventModel.create({
        ...data,
        eventCode,
    })
}

export async function reserveSpotByID(eventId: string){
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

export async function reserveSpotByEventCode(eventCode: string){
    return await EventModel.findOneAndUpdate(
        {
            eventCode,
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