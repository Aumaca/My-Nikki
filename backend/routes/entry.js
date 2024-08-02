import { createEntry } from "../controllers/entry.js";
import { verifyToken } from "../middleware/auth.js";
import express from "express";
import multer from "multer";

const router = express.Router();

// Multer
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

router.post("/", verifyToken, upload.array("files", 6), createEntry);

export default router;
