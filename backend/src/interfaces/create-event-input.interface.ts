import { Category } from "../enums/event-category.enum";


export interface CreateEventInput {
    title: string;
    category: Category;
    place: string;
    description?: string;
    date: Date;
    isLimited: boolean;
    maxCapacity: number;
}