import "dotenv/config";

export const env =  {
    PORT:  Number(process.env.PORT) || 3000,
    MONGODB_URI:  process.env.MONGODB_URI || "",
}

if (!env.MONGODB_URI) {
    throw new Error("No MONGODB_URI PROVIDED")
}

if (!env.PORT){
    throw new Error("No PORT provided")
}