import User from "../models/User.js";

export const getUser = async (req, res) => {
  const userID = req.userID;
  const user = await User.findById(userID).select("-password");
  const userObj = user.toObject();
  res.status(200).json({ user: userObj });
};
