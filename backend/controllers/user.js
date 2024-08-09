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
      if (entry.media) {
        entry.media.forEach((currMedia) => {
          let mediaInfo = [currMedia, entry.id];
          mediaFiles.push(mediaInfo);
        });
      }
    });

    userObj.media = mediaFiles;

    return res.status(200).json({ user: userObj });
  }
  return res.status(400).json({ msg: "User was not found" });
};
