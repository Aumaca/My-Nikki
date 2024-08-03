import { createEntry } from "../controllers/entry.js";
import { verifyToken } from "../middleware/auth.js";
import express from "express";
import multer from "multer";
import path from "path";

const router = express.Router();

// Multer
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    const fileName = Date.now() + path.extname(file.originalname);
    cb(null, fileName);
  },
});
const upload = multer({ storage });

router.post("/", verifyToken, upload.array("media", 6), createEntry);

export default router;
