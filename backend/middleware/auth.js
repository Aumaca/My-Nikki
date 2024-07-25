import jwt from "jsonwebtoken";

export const verifyToken = async (req, res, next) => {
  try {
    let token = req.header("Authorization");
    if (token && token.startsWith("Bearer ")) {
      token = token.slice(7).trim(); // Adjust slicing as needed
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      req.userID = decoded.userID;
      next();
    } else {
      res.status(401).send("No token provided");
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({ msg: "Invalid token" });
  }
};
