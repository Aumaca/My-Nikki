import Entry from "../models/Entry.js";
import User from "../models/User.js";
import Media from "../models/Media.js";

export const createEntry = async (req, res) => {
  try {
    const userID = req.userID;
    const user = await User.findById(userID).select("-password");

    if (!user) {
      return res.status(400).json({ msg: "User was not found" });
    }

    const { content, mood, date, tags, localization } = req.body;

    const newEntry = new Entry({
      content,
      localization,
      tags,
      mood,
      user: userID,
    });

    const savedEntry = new Entry(newEntry);

    if (req.files && req.files.length > 0) {
      const mediaPromises = req.files.map((file) => {
        const newMedia = new Media({
          name: file.originalName,
          media: {
            data: file.buffer,
            contentType: file.mimetype,
          },
        });

        return newMedia.save().then((savedMedia) => {
          savedEntry.media.push(savedMedia._id);
        });
      });

      await Promise.all(mediaPromises);
      await savedEntry.save();
    }
  } catch (e) {
    console.error(e);
    return res.status(500).json({ msg: "Error creating entry." });
  }
};
