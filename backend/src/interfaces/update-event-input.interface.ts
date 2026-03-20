import { Category } from "../enums/event-category.enum";


export interface UpdateEventInput {
    title?: string;
    category?: Category;
    place?: string;
    description?: string;
    date?: Date;
    isLimited?: boolean;
    maxCapacity?: number;
}