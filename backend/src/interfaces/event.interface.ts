import { Document } from "mongoose";
import { Category } from "../enums/-category.enum";

export interface IEvent extends Document {
    title: string;
    category: Category;
    descripion?: string;
    date: Date;
    maxCapacity: number;
    reservedCount: number;
    createdAt: Date;
    updatedAt: Date;
}