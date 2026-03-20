import { EventModel } from "../models/event.model";
import { Category } from "../enums/event-category.enum";
import type { CreateEventInput } from "../interfaces/create-event-input.interface";
import type { UpdateEventInput } from "../interfaces/update-event-input.interface";
import { generateEventCode } from "../utils/generate-event-code";

// Obtener todos los eventos
export async function getAllEvents() {
    return await EventModel.find().sort( { date: 1 });
}

// Obtener un evento por su _id de mongo
export async function getEventByID(id: string){
    return await EventModel.findById(id);
}

// Obtener un evento por su codigo de evento
export  async function getEventByCode(eventCode: String) {
    return await EventModel.findOne( { eventCode });
}

// Editar un evento por medio de su codigo de evento
export async function updateEventByCode(eventCode: string, data: UpdateEventInput){
    return await EventModel.findOneAndUpdate(
        { eventCode },
        { $set: data },
        { new: true }
    );
}

// Generar un codigo unico de evento
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

// Crear un evento
export async function createEvent( data: CreateEventInput){
    const eventCode = await generateUniqueEventCode(data.category);
    return await EventModel.create({
        ...data,
        eventCode,
    })
}

// Reservar un lugar en el evento por medio del _id de mongo
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

// Reservar un lugar en el evento por medio del codigo de evento
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