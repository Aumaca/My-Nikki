import express from "express";
import { register, login, googleAuth } from "../controllers/auth.js";

const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.post("/google_auth", googleAuth);

export default router;
