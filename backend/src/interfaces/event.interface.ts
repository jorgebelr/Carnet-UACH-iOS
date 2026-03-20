import { Document } from "mongoose";
import { Category } from "../enums/event-category.enum";

export interface IEvent extends Document {
    title: string;
    eventCode: string;
    category: Category;
    place: string;
    description?: string;
    date: Date;
    isLimited: boolean;
    maxCapacity: number;
    reservedCount: number;
    imageUrl?: string
    createdAt: Date;
    updatedAt: Date;
}