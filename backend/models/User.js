import mongoose from "mongoose";

const UserSchema = new mongoose.Schema({
  uid: { type: String },
  email: {
    type: String,
    unique: [true],
    validate: [
      {
        validator: (v) => {
          return /^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(v);
        },
        message: "Invalid email",
      },
      {
        validator: async function (v) {
          const emailIsUsed = await mongoose
            .model("User")
            .findOne({ email: v });
          return !emailIsUsed;
        },
        message: "This email is already in use.",
      },
    ],
    required: [true, "Missing email"],
    // minlength: [10, "Email must have more than 10 characters"],
    // maxlength: [60, "Email must have less than 60 characters"],
  },
  name: {
    type: String,
  },
  password: {
    type: String,
  },
  photoURL: {
    type: String,
  },
  photoFile: {
    type: String,
  },
  entries: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Entry",
    },
  ],
  country: {
    type: String,
  },
  isComplete: {
    type: Boolean,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

UserSchema.methods.entriesCounter = function (cb) {
  return this.entries.length();
};

UserSchema.methods.moodCounter = function (cb) {
  const moodCounter = {
    joyful: 0,
    content: 0,
    neutral: 0,
    gloomy: 0,
    depressed: 0,
  };

  this.entries.forEach((entry) => {
    switch (entry.mood) {
      case "Joyful":
        entry.joyful++;
        break;
      case "Content":
        entry.content++;
        break;
      case "Neutral":
        entry.neutral++;
        break;
      case "Gloomy":
        entry.gloomy++;
        break;
      case "Depressed":
        entry.depressed++;
        break;
    }
  });

  return moodCounter;
};

const User = mongoose.model("User", UserSchema);

export default User;
