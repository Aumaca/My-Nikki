import User from "../models/User.js";
import supertest from "supertest";
import { expect } from "chai";
import app from "../app.js";
import Entry from "../models/Entry.js";

before(async function () {
  try {
    await User.deleteOne({ email: "testuser@example.com" });
    await User.deleteOne({ email: "googleuser@example.com" });
  } catch (err) {
    console.error("Error during cleanup: ", err);
  }
});

after(async function () {
  try {
    await User.deleteOne({ email: "testuser@example.com" });
    await User.deleteOne({ email: "googleuser@example.com" });
  } catch (err) {
    console.error("Error during cleanup: ", err);
  }
});

describe("Authentication API Tests", () => {
  it("should register a new user", (done) => {
    supertest(app)
      .post("/auth/register")
      .send({
        email: "testuser@example.com",
        password: "password123",
        name: "Test User",
        country: "Test Country",
      })
      .end((err, res) => {
        if (err) {
          return done(err);
        }
        try {
          expect(res.statusCode).to.equal(201);
          expect(res.body.token).to.be.a("string");
          done();
        } catch (error) {
          done(error);
        }
      });
  });

  it("should login a user", (done) => {
    supertest(app)
      .post("/auth/login")
      .send({
        email: "testuser@example.com",
        password: "password123",
      })
      .end((err, res) => {
        if (err) {
          return done(err);
        }
        try {
          expect(res.statusCode).to.equal(200);
          expect(res.body.token).to.be.a("string");
          done();
        } catch (error) {
          done(error);
        }
      });
  });
});
