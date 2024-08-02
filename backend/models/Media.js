import mongoose from "mongoose";

const mediaSchema = new mongoose.Schema({
  name: String,
  media: {
    data: Buffer,
    contentType: String,
  },
});

const Media = mongoose.model("Media", mediaSchema);

export default Media;
