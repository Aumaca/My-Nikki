import User from "../models/User.js";

export const getUser = async (req, res) => {
  const userID = req.userID;
  const user = await User.findById(userID)
    .select("-password")
    .populate({
      path: "entries",
      options: {
        sort: { date: -1 },
      },
    });
  if (user) {
    const userObj = user.toObject();

    let mediaFiles = [];
    user.entries.forEach((entry) => {
      mediaFiles = mediaFiles.concat(entry.media || []);
    });

    userObj.medias = mediaFiles;
    return res.status(200).json({ user: userObj });
  }
  return res.status(400).json({ msg: "User was not found" });
};
