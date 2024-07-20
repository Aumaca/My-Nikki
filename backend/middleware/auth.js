import jwt from "jsonwebtoken";

export const verifyToken = async (req, res, next) => {
  try {
    let token = req.header("Authorization");
    token = token.slice(7, token.length).trimLeft();

    console.log(token);
    if (!token) {
      return res.status(401).send("No token provided");
    }
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userID = decoded.userID;
    next();
  } catch (err) {
    res.status(500).json({ msg: "Invalid token" });
  }
};
