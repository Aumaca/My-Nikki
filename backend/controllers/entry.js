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
        newEntry.media.push(file.filename);
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

export const updateEntry = async (req, res) => {
  const session = await startSession();
  session.startTransaction();

  let filePaths = [];

  try {
    const userID = req.userID;
    const user = await User.findById(userID).select("-password");
    if (!user) {
      return res.status(400).json({ msg: "User was not found" });
    }

    const entryID = req.params.entryID;
    const userHasEntry = user.entries.find((entry) => entry == entryID);
    const entry = await Entry.findById(entryID);
    if (!userHasEntry || !entry) {
      return res.status(400).json({ msg: "Entry was not found" });
    }

    const { content, mood, date, localization, tags, existingFiles } =
      JSON.parse(req.body.data);

    // Media
    // Handle media files
    let newMedia = [];
    let mediaToRemove = [];
    let mediaToAdd = [];

    // Include new files
    if (req.files && req.files.length > 0) {
      req.files.map((file) => {
        filePaths.push(file.filename);
        newMedia.push(file.filename);
      });
    }

    // Get files to remove or keep media
    if (entry.media && existingFiles) {
      mediaToRemove = entry.media.filter(
        (currMedia) => !existingFiles.includes(currMedia)
      );
      mediaToAdd = entry.media.filter((currMedia) =>
        existingFiles.includes(currMedia)
      );
    }

    // Update newMedia to include mediaToAdd
    newMedia = newMedia.concat(mediaToAdd);

    // Update the entry
    let updatedEntry = await Entry.findByIdAndUpdate(
      entryID,
      {
        content,
        mood,
        date: new Date(date),
        localization: localization
          ? { x: localization.x, y: localization.y }
          : null,
        tags: tags || null,
        media: newMedia,
      },
      { session, new: true }
    );

    await session.commitTransaction();
    session.endSession();

    if (mediaToRemove.length > 0) {
      mediaToRemove.forEach((filePath) => {
        fs.unlink(filePath, (err) => {
          if (err) console.error(`Error deleting file: ${filePath}`, err);
        });
      });
    }

    return res.status(200).json(updatedEntry);
  } catch (e) {
    await session.abortTransaction();
    session.endSession();

    if (filePaths.length > 0) {
      filePaths.forEach((filePath) => {
        fs.unlink(filePath, (err) => {
          if (err) console.error(`Error deleting file: ${filePath}`, err);
        });
      });
    }

    console.error(e);
    return res.status(500).json({ msg: "Error updating entry." });
  }
};
