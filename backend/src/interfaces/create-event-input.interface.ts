import { Category } from "../enums/event-category.enum";


export interface CreateEventInput {
    title: string;
    category: Category;
    description?: string;
    date: Date;
    maxCapacity: number;
}