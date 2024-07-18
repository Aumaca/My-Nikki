import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../models/User.js";

const createToken = (user) => {
  return jwt.sign(
    { email: user.email, userID: user.id },
    process.env.JWT_SECRET
  );
};

const hashPassword = async (password) => {
  return await bcrypt.hash(password, await bcrypt.genSalt());
};

const saveUserAndReturnToken = async ({ user, req, res }) => {
  try {
    await user.save();
    const token = createToken(user);
    res.status(201).json({ token });
  } catch (err) {
    res.status(400).json({
      field: err.errors[Object.keys(err.errors)[0]].properties.path,
      message: err.errors[Object.keys(err.errors)[0]].message,
    });
  }
};

/* REGISTER USER */
// If email is already in use and has no UID defined, return 400
// Create/update user and save, returning 201 and token
export const register = async (req, res) => {
  try {
    const { email, password, name, country } = req.body;

    const signedUpUser = await User.findOne({ email: email });
    if (signedUpUser) {
      if (signedUpUser.uid) {
        signedUpUser.name = name;
        signedUpUser.country = country;
        saveUserAndReturnToken({ user: signedUpUser, req, res });
      } else {
        return res.status(400).json({ msg: "Email already in use." });
      }
    }

    const newUser = new User({
      email,
      name,
      country,
      password: await hashPassword(password),
      createdAt: new Date().toUTCString(),
    });
    saveUserAndReturnToken({ user: newUser, req, res });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* LOGGING IN */
// If user isn't found, return 400
// If password don't match, return 400
// Return 200 and token
export const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email: email });
    if (!user) {
      return res.status(400).json({ field: "email" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({
        field: "password",
      });
    }

    const token = createToken(user);
    res.status(200).json({ token: token });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* GOOGLE AUTH */
// If is new user, save in DB and return 201
// If is not a new user, check if email is saved and check if profile is completed
//  - if it is, returns 200 and token
//  - if not, returns 201
// Returns 400 or 500 to errors
export const googleAuth = async (req, res) => {
  try {
    const { uid, email, photoURL, isNewUser } = req.body;

    if (isNewUser) {
      try {
        const newUser = new User({
          uid,
          email,
          photoURL,
          createdAt: new Date().toUTCString(),
          isComplete: false,
        });
        const savedUser = await newUser.save();
        if (savedUser) {
          return res.status(201);
        } else {
          return res.status(400);
        }
      } catch (err) {
        return res.status(400).json({
          field: err.errors[Object.keys(err.errors)[0]].properties.path,
          message: err.errors[Object.keys(err.errors)[0]].message,
        });
      }
    } else {
      const user = await User.findOne({ uid });

      if (!user) {
        return res.status(400).json({
          field: "email",
          message: "User is not new but theres no register...?",
        });
      } else if (user.isComplete) {
        const token = createToken(user);
        return res.status(200).json({ token });
      } else {
        return res.status(201);
      }
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

export const checkToken = async (req, res) => {};

// GOOGLE AUTH
//  - gets data and send to backend
//  - backend checks if is a new user
//    - if yes, save data and returns 201 to continue signing up
//    - else
//      - if isComplete, return 200 and token
//      - else, return 201 to continue to signing up
//
// REGISTER
//   - checks if email is already in use
//     - if yes
//       - if has uid because of google, continue
//       - else, return 400 and message
//     - else, continue
//   - save and return 201 and token (CAUTION)
//
// LOGIN
//   - checks if user exist
//     - If yes, return 200 and token
//     - else, return 400 and message
