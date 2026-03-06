import express from "express";
import cors from "cors";
import eventRoutes from "./routes/event.routes"

const app = express();

app.use(cors());
app.use(express.json());

app.get("/health", (_req, res) => {
    res.json({
        ok: true,
        message: "Server is running",
    });
});

app.use("/events", eventRoutes);

export default app;