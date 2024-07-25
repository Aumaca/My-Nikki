import express from "express";
import {
  register,
  login,
  googleLogin,
  googleRegister,
  checkToken,
} from "../controllers/auth.js";

const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.post("/google_login", googleLogin);
router.post("/google_register", googleRegister);
router.post("/check_token", checkToken);

export default router;
