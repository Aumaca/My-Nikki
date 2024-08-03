import mongoose from "mongoose";

const { Schema } = mongoose;
const { Types } = Schema;
const { Decimal128, ObjectId } = Types;

const LocalizationSchema = new mongoose.Schema({
  x: { type: Decimal128, required: true },
  y: { type: Decimal128, required: true },
});

const EntrySchema = new mongoose.Schema({
  content: { type: String },
  mood: { type: String },
  date: { type: Date },
  localization: { type: LocalizationSchema },
  tags: [{ type: String }],
  media: [{ type: String }],
  createdAt: { type: Date, default: Date.now },
});

const Entry = mongoose.model("Entry", EntrySchema);

export default Entry;
