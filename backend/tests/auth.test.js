import { expect } from "chai";
import supertest from "supertest";
import mongoose from "mongoose";
import app from "../app.js";
import User from "../models/User.js";

let token = "";

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

  it("should login an existing user", (done) => {
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

          token = res.body.token;

          done();
        } catch (error) {
          done(error);
        }
      });
  });

  it("should sign up Google new user (as incomplete)", (done) => {
    supertest(app)
      .post("/auth/google")
      .send({
        uid: "unique_google_user_id",
        email: "googleuser@example.com",
        photoURL: "https://example.com/avatar.jpg",
        isNewUser: true,
      })
      .end((err, res) => {
        if (err) {
          return done(err);
        }
        try {
          expect(res.statusCode).to.be.equal(201);
          done();
        } catch (error) {
          done(error);
        }
      });
  });

  it("should finish signing up Google user (now as complete)", (done) => {
    supertest(app)
      .post("/auth/google")
      .send({
        uid: "unique_google_user_id",
        email: "googleuser@example.com",
        photoURL: "https://example.com/avatar.jpg",
        name: "google",
        country: "Brazil",
        isNewUser: false,
      })
      .end((err, res) => {
        if (err) {
          return done(err);
        }
        try {
          expect(res.statusCode).to.be.equal(201);
          expect(res.body.token).to.be.a("string");
          done();
        } catch (error) {
          done(error);
        }
      });
  });

  it("should login Google user (now as complete)", (done) => {
    supertest(app)
      .post("/auth/google")
      .send({
        uid: "unique_google_user_id",
        email: "googleuser@example.com",
        photoURL: "https://example.com/avatar.jpg",
        name: "google",
        country: "Brazil",
        isNewUser: false,
      })
      .end((err, res) => {
        if (err) {
          return done(err);
        }
        try {
          expect(res.statusCode).to.be.equal(200);
          expect(res.body.token).to.be.a("string");
          done();
        } catch (error) {
          done(error);
        }
      });
  });
});

describe("User", () => {
  it("should return user's data", (done) => {
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
          done();
        } catch (error) {
          done(error);
        }
      });
  });
});
