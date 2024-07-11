import mongoose from "mongoose"

const EntrySchema = new mongoose.Schema({
  createdAt: {type: String},
  content: {type: Text},
  localization: {type: Text},
  tags: [{type: String}],
  mood: {type: String},
})

const Entry = mongoose.model("Entry", EntrySchema)

export default Entry