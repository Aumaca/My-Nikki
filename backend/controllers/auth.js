import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../models/User.js";

/* REGISTER USER */
export const register = async (req, res) => {
  try {
    const { email, password } = req.body;
    const salt = await bcrypt.genSalt();
    const pwdHash = await bcrypt.hash(password, salt);

    const newUser = new User({
      email,
      password: pwdHash,
      picture: "",
      createdAt: new Date().toLocaleDateString("en-US"),
    });

    try {
      await newUser.save();
      const token = jwt.sign(
        { email: newUser.email, userID: newUser.id },
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
export const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    console.log(req.body);

    const user = await User.findOne({ email: email });
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
export const googleAuth = async (req, res) => {
  try {
    console.log(req.body);

    const { uid, email, photoURL, isNewUser, displayName } = req.body;

    // If is new user, register and return token
    if (isNewUser) {
      try {
        const newUser = new User({
          uid,
          email,
          name: displayName,
          photoURL,
          createdAt: new Date().toLocaleDateString("en-US"),
        });
        const savedUser = await newUser.save();

        const token = jwt.sign(
          { email: savedUser.email, userID: savedUser.id },
          process.env.JWT_SECRET
        );

        return res.status(201).json({ token });
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
      }

      const token = jwt.sign(
        { email: user.email, userID: user.id },
        process.env.JWT_SECRET
      );
      return res.status(200).json({ token });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
