import User from "../models/User.js";

export const getUser = async (req, res) => {
  const userID = req.userID;
  const user = await User.findById(userID).select("-password");
  if (user) {
    const userObj = user.toObject();
    return res.status(200).json({ user: userObj });
  }
  return res.status(400).json({ msg: "User was not found" });
};
