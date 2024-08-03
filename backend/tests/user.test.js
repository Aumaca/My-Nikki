import {
  removeFiles,
  createUser,
  loginUser,
  createEntry,
} from "../utils/tests.js";
import Entry from "../models/Entry.js";
import User from "../models/User.js";
import { fileURLToPath } from "url";
import supertest from "supertest";
import { expect } from "chai";
import app from "../app.js";
import path from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
let filenames = [];

let token = "";

before(async function () {
  try {
    // Create user
    await createUser({
      email: "user@example.com",
      password: "password123",
      name: "Test User",
      country: "Test Country",
    });

    // Login user
    token = await loginUser({
      email: "user@example.com",
      password: "password123",
    });

    // entry 1
    const filenames1 = await createEntry(
      token,
      {
        content: "User Test1",
        mood: "happy",
        date: new Date().toUTCString(),
        localization: {
          x: 10.0,
          y: 20.0,
        },
        tags: ["tag1", "tag2"],
      },
      ["entry_files/bocchi.jpg", "entry_files/lelouch.jpg"],
      __dirname,
      "files"
    );

    // entry 2
    const filenames2 = await createEntry(
      token,
      {
        content: "User Test2",
        mood: "sad",
        date: new Date().toUTCString(),
        localization: {
          x: 20.0,
          y: 40.0,
        },
        tags: ["tag3", "tag4"],
      },
      ["entry_files/bocchi.jpg"],
      __dirname,
      "files"
    );

    filenames = filenames.concat(filenames1, filenames2);
  } catch (err) {
    console.error("Error during setup: ", err);
  }
});

after(async function () {
  try {
    await User.deleteOne({ email: "user@example.com" });
    await Entry.deleteMany({ content: { $regex: "^User Test" } });

    removeFiles(__dirname, filenames);
  } catch (err) {
    console.error("Error during cleanup of files: ", err);
  }
});

describe("User", () => {
  it("should return user's data", function (done) {
    supertest(app)
      .get("/user/getUser")
      .set("Authorization", `Bearer ${token}`)
      .end((err, res) => {
        if (err) {
          return done(err);
        }
        try {
          expect(res.statusCode).to.be.equal(200);
          expect(res.body).to.have.property("user");
          expect(res.body.user).to.have.property("medias");
          expect(res.body.user.medias).to.have.lengthOf(3);
          done();
        } catch (error) {
          done(error);
        }
      });
  });
});
