import User from "../models/User.js";

export const getUser = async (req, res) => {
  const userID = req.userID;
  console.log("USERID: " + userID);
  const user = await User.findById(userID).select("-password");
  const userObj = user.toObject();
  console.log(userObj);
  res.status(200).json({ user: userObj });
};
