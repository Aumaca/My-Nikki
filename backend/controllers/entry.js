import { startSession } from "mongoose";
import Entry from "../models/Entry.js";
import User from "../models/User.js";
import path from "path";
import fs from "fs";

export const createEntry = async (req, res) => {
  const session = await startSession();
  session.startTransaction();

  let filePaths = [];

  try {
    const userID = req.userID;
    const user = await User.findById(userID).select("-password");

    if (!user) {
      return res.status(400).json({ msg: "User was not found" });
    }

    const { content, mood, date, localization, tags } = JSON.parse(
      req.body.data
    );

    const newEntry = new Entry({
      content,
      mood,
      date: new Date(date),
      localization: localization
        ? {
            x: localization.x,
            y: localization.y,
          }
        : null,
      tags: tags ? tags : null,
    });

    if (req.files && req.files.length > 0) {
      filePaths = req.files.map((file) => {
        const filePath = path.join("uploads", file.filename);
        newEntry.media.push(filePath);
      });
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

    filePaths ??
      filePaths.forEach((filePath) => {
        fs.unlink(filePath, (err) => {
          if (err) console.error(`Error deleting file: ${filePath}`, err);
        });
      });

    console.error(e);
    return res.status(500).json({ msg: "Error creating entry." });
  }
};
