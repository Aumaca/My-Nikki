import Entry from "../models/Entry.js";
import User from "../models/User.js";
import { fileURLToPath } from "url";
import supertest from "supertest";
import { expect } from "chai";
import app from "../app.js";
import path from "path";
import fs from "fs";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

let token = "";

before(async function () {
  try {
    await supertest(app).post("/auth/register").send({
      email: "entrytestuser@example.com",
      password: "password123",
      name: "Test User",
      country: "Test Country",
    });

    const res = await supertest(app).post("/auth/login").send({
      email: "entrytestuser@example.com",
      password: "password123",
    });

    token = res.body.token;
  } catch (err) {
    console.error("Error during login of user for test purposes: ", err);
  }
});

after(async function () {
  try {
    await User.deleteOne({ email: "entrytestuser@example.com" });
    await Entry.deleteMany({ content: "Content Test" });

    const uploadDir = path.join(__dirname, "../uploads");
    fs.readdir(uploadDir, (err, files) => {
      if (err) throw err;
      for (const file of files) {
        fs.unlink(path.join(uploadDir, file), (err) => {
          if (err) throw err;
        });
      }
    });
  } catch (err) {
    console.error("Error during cleanup of files: ", err);
  }
});

describe("Entry API Tests", () => {
  it("should create a new entry", (done) => {
    supertest(app)
      .post("/entry")
      .set("Authorization", `Bearer ${token}`)
      .field("content", "Content Test")
      .field("mood", "happy")
      .field("date", new Date().toISOString())
      .field("localization[x]", 10.0)
      .field("localization[y]", 20.0)
      .field("tags", JSON.stringify(["tag1", "tag2"]))
      .attach("media", path.join(__dirname, "entry_files/bocchi.jpg"))
      .attach("media", path.join(__dirname, "entry_files/lelouch.jpg"))
      .end((err, res) => {
        if (err) {
          return done(err);
        }
        try {
          expect(res.statusCode).to.equal(201);
          done();
        } catch (error) {
          done(error);
        }
      });
  });
});
