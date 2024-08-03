import {
  removeFiles,
  createEntry,
  createUser,
  loginUser,
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
const filenames = [];

let token = "";

before(async function () {
  try {
    // Create user
    await createUser({
      email: "entrytestuser@example.com",
      password: "password123",
      name: "Test User",
      country: "Test Country",
    });

    // Login user
    token = await loginUser({
      email: "entrytestuser@example.com",
      password: "password123",
    });
  } catch (err) {
    console.error("Error during login of user for test purposes: ", err);
  }
});

after(async function () {
  try {
    await User.deleteOne({ email: "entrytestuser@example.com" });
    await Entry.deleteMany({ content: "Entry Test1" });

    removeFiles(__dirname, filenames);
  } catch (err) {
    console.error("Error during cleanup of files: ", err);
  }
});

describe("Entry API Tests", () => {
  it("should create a new entry", async () => {
    const res = await createEntry(
      token,
      {
        content: "Entry Test1",
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
      null
    );

    expect(res.statusCode).to.equal(201);
    const { media } = res.body;
    media.forEach((file) => filenames.push(file.split("\\")[1]));
  });
});
