import express from "express";
import cors from "cors";
import path from "path"
import eventRoutes from "./routes/event.routes"

const app = express();

app.use(cors());
app.use(express.json());

app.use("/uploads", express.static(path.join(process.cwd(), "uploads")));

app.get("/health", (_req, res) => {
    res.json({
        ok: true,
        message: "Server is running",
    });
});

app.use("/events", eventRoutes);

export default app;