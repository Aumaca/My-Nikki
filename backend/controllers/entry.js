import { startSession } from "mongoose";
import Entry from "../models/Entry.js";
import User from "../models/User.js";
import path from "path";
import fs from "fs";

export const createEntry = async (req, res) => {
  const session = await startSession();
  session.startTransaction();

  try {
    const userID = req.userID;
    const user = await User.findById(userID).select("-password");

    if (!user) {
      return res.status(400).json({ msg: "User was not found" });
    }

    const { content, mood, date, localization, tags } = req.body;

    const newEntry = new Entry({
      content,
      mood,
      date: new Date(date),
      localization: {
        x: localization.x,
        y: localization.y,
      },
      tags: JSON.parse(tags),
    });

    if (req.files && req.files.length > 0) {
      handleMedia(req, newEntry); // Add files in the entry media array
    }

    const savedEntry = await newEntry.save({ session });

    await User.updateOne(
      { _id: userID },
      { $push: { entries: savedEntry._id } },
      { session }
    );

    await session.commitTransaction();
    session.endSession();

    return res.status(201).json(savedEntry);
  } catch (e) {
    await session.abortTransaction();
    session.endSession();

    console.error(e);
    return res.status(500).json({ msg: "Error creating entry." });
  }
};

const handleMedia = (req, newEntry) => {
  req.files.map((file) => {
    const filePath = path.join("uploads", file.filename);
    newEntry.media.push(filePath);
  });
};
