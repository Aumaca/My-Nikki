import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../models/User.js";

/* REGISTER USER */
// If email is already in use and has no UID defined, return 400
// Create/update user and save, returning 201 and token
export const register = async (req, res) => {
  try {
    isGoogleUser = false;
    const { email, password, name, country } = req.body;

    const currentUser = await User.findBy({ email: email });
    if (currentUser) {
      if (currentUser.uid) {
        isGoogleUser = true;
      } else {
        res.status(400).json({ msg: "Email already in use." });
      }
    }

    if (isGoogleUser) {
      currentUser.name = name;
      currentUser.country = country;
    } else {
      const salt = await bcrypt.genSalt();
      const pwdHash = await bcrypt.hash(password, salt);

      currentUser.email = email;
      currentUser.password = pwdHash;
      currentUser.name = name;
      currentUser.createdAt = new Date().toUTCString();
      currentUser.country = country;
    }

    try {
      await currentUser.save();
      const token = jwt.sign(
        { email: currentUser.email, userID: currentUser.id },
        process.env.JWT_SECRET
      );
      res.status(201).json({ token });
    } catch (err) {
      res.status(400).json({
        field: err.errors[Object.keys(err.errors)[0]].properties.path,
        message: err.errors[Object.keys(err.errors)[0]].message,
      });
    }
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

    console.log(req.body);

    const user = await User.findBy({ email: email });
    if (!user) {
      return res.status(400).json({ field: "email", message: "Email invalid" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch || !user)
      return res.status(400).json({
        field: "email",
        field2: "password",
        message: "Invalid credentials",
      });

    const token = jwt.sign(
      { email: user.email, objId: user.id },
      process.env.JWT_SECRET
    );

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
    console.log(req.body);

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

        // const token = jwt.sign(
        //   { email: savedUser.email, userID: savedUser.id },
        //   process.env.JWT_SECRET
        // );

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
        const token = jwt.sign(
          { email: user.email, userID: user.id },
          process.env.JWT_SECRET
        );
        return res.status(200).json({ token });
      } else {
        return res.status(201);
      }
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

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
