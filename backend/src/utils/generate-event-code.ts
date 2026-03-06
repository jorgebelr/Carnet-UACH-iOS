import { Category } from "../enums/event-category.enum";

function getCategoryPrefix(category: Category): string {
    switch (category) {
        case Category.Culture:
            return "CUL";
        case Category.ScientificPhilosophical:
            return "SCI";
        case Category.Sports:
            return "SPO";
        case Category.CommunitySupport:
            return "COM";
        case Category.Health:
            return "HEA";
        case Category.FutureLivingTools:
            return "FUT";
        default:
            return "EVT";
    }
}

function generateRandomPart(lenght = 6): string {
    const chars = "ABCDEFGHJKLMNPQRSTUVXYZ23456789"
    let result = "";

    for (let i = 0; i < lenght; i++) {
        const index = Math.floor(Math.random() * chars.length);
        result += chars[index]
    }
    return result;
}

export function generateEventCode(category: Category): string {
    const prefix = getCategoryPrefix(category);
    const randomPart = generateRandomPart();

    return `${prefix}-${randomPart}`;
}