import { Schema, model}  from "mongoose";
import type { IEvent } from "../interfaces/event.interface";
import { Category } from "../enums/event-category.enum";


const eventSchema = new Schema<IEvent>(
    {
    title: {
        type: String,
        required: true,
        trim: true,
    },
    category: {
        type: String,
        required: true,
        enum: Object.values(Category),
    },
    description: {
        type: String,
    },
    date: {
        type: Date,
        required: true,
    },
    maxCapacity: {
        type: Number,
        required: true,
        min: 1,
    },
    reservedCount: {
        type: Number,
        default: 0,
        min: 0,
    },
},
{
    timestamps: true
}
);

export const EventModel = model<IEvent>("Event", eventSchema)