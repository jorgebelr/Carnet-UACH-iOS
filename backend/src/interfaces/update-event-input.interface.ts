import { Category } from "../enums/event-category.enum";


export interface UpdateEventInput {
    title?: string;
    place?: string;
    description?: string;
    date?: Date;
    isLimited?: boolean;
    imageUrl?: string;
    maxCapacity?: number;
}