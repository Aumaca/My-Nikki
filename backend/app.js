import express from "express";
import bodyParser from "body-parser";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import helmet from "helmet";
import multer from "multer";
import path from "path";
import { fileURLToPath } from "url";
import admin from "firebase-admin";

import authRoutes from "./routes/auth.js";
import userRoutes from "./routes/user.js";
import entryRoutes from "./routes/entry.js";

import serviceAccount from "./firebase_key.json" assert { type: "json" };

/* CONFIG */
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
dotenv.config();
const app = express();

app.use(express.json());
app.use(helmet());
app.use(helmet.crossOriginResourcePolicy({ policy: "cross-origin" }));
app.use(bodyParser.json({ limit: "30mb", extended: true }));
app.use(bodyParser.urlencoded({ limit: "30mb", extended: true }));
app.use(
  cors({
    origin: ["https://aumaca-mynikki.vercel.app", "http://127.0.0.1:5173"],
  })
);
app.use("/assets", express.static(path.join(__dirname, "public/assets")));

/* ROUTES */
app.use("/auth", authRoutes);
app.use("/user", userRoutes);
app.use("/entry", entryRoutes);
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const PORT = process.env.PORT || 3001;

mongoose
  .connect(process.env.MONGO_URL)
  .then(() => {
    app.listen(PORT, () => {});
  })
  .catch(() => console.log("Error while connecting to mongoDB server."));

export default app;
