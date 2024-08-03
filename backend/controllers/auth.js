import bcrypt from "bcrypt";
import jwt, { decode } from "jsonwebtoken";
import User from "../models/User.js";
import admin from "firebase-admin";

const createToken = (user) => {
  return jwt.sign({ userID: user.id }, process.env.JWT_SECRET, {
    expiresIn: "30d",
  });
};

const hashPassword = async (password) => {
  return await bcrypt.hash(password, await bcrypt.genSalt());
};

const returnToken = async ({ user, req, res }) => {
  try {
    if (user) {
      const token = createToken(user);
      return res.status(200).json({ token });
    } else {
      throw new Error();
    }
  } catch (err) {
    return res.status(400).json({ msg: "Error returning token" });
  }
};

const saveUserAndReturnToken = async ({ user, req, res }) => {
  try {
    await user.save();
    const token = createToken(user);
    return res.status(201).json({ token });
  } catch (err) {
    return res.status(400).json({ msg: "Error saving and returning token" });
  }
};
export const checkToken = async (req, res) => {
  const { token } = req.body;
  const verifiedToken = jwt.verify(token, process.env.JWT_SECRET);
  if (verifiedToken) {
    return res.status(200).json();
  } else {
    return res.status(400).json({ msg: "Invalid JWT token" });
  }
};

/* REGISTER */
export const register = async (req, res) => {
  try {
    const { uid, email, password, name, country } = req.body;

    const signedUpUser = await User.findOne({ email: email.toLowerCase() });

    if (signedUpUser)
      return res.status(400).json({ msg: "Email already in use." });

    const capitalizedName = name
      .split(" ")
      .map(
        (slicedName) =>
          slicedName.charAt(0).toUpperCase() + slicedName.slice(1).toLowerCase()
      )
      .join(" ");

    const user = new User({
      uid,
      email: email.toLowerCase(),
      name: capitalizedName,
      country,
      password: uid ? null : await hashPassword(password),
      createdAt: new Date().toLocaleDateString("en-US"),
    });

    saveUserAndReturnToken({ user, req, res });
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

/* LOGIN */
export const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        msg: "No email and password provided",
      });
    }

    const user = await User.findOne({ email: email.toLowerCase() });
    if (!user) {
      return res.status(400).json({ field: "email" });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({
        field: "password",
      });
    }

    return returnToken({ user, req, res });
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

export const googleLogin = async (req, res) => {
  try {
    const { idToken } = req.body;
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    const user = await User.findOne({ uid: uid });
    if (user) {
      return returnToken({ user, req, res });
    } else {
      return res.status(400).json();
    }
  } catch (e) {
    res.status(401).send("Invalid Firebase ID token");
  }
};

export const googleRegister = async (req, res) => {
  try {
    const { idToken, email, name, country } = req.body;
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    const user = await User.findOne({ uid: uid });
    if (!user) {
      const newUser = new User({
        uid,
        email,
        name,
        country,
        password: null,
        createdAt: new Date().toLocaleDateString("en-US"),
      });

      await newUser.save();

      return saveUserAndReturnToken({ user, req, res });
    } else {
      return res.status(400).json({ msg: "User already signed up" });
    }
  } catch (e) {
    res.status(401).send("Invalid Firebase ID token");
  }
};
