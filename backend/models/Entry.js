import mongoose, { Schema } from "mongoose";

const EntrySchema = new mongoose.Schema({
  createdAt: { type: String },
  content: { type: String },
  localization: { type: String },
  tags: [{ type: String }],
  mood: { type: String },
  user: { type: Schema.Types.ObjectId, ref: "user" },
  media: [{ type: Schema.Types.ObjectId, ref: "media" }],
});

const Entry = mongoose.model("Entry", EntrySchema);

export default Entry;
