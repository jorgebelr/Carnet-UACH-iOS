import { Category } from "../enums/event-category.enum";


export interface UpdateEventInput {
    title?: string;
    category?: Category;
    description?: string;
    date?: Date;
    maxCapacity?: number;
}