import { expect } from "chai";
import supertest from "supertest";
import mongoose from "mongoose";
import app from "../app.js";
import User from "../models/User.js";

describe("Authentication API Tests", async function () {
  after(async function () {
    await User.findOneAndDelete({ email: "testuser@example.com" });
    await User.findOneAndDelete({ email: "googleuser@example.com" });
    await mongoose.disconnect();
  });

  it("should register a new user", async function () {
    const res = await supertest(app).post("/auth/register").send({
      email: "testuser@example.com",
      password: "password123",
      name: "Test User",
      country: "Test Country",
    });

    expect(res.status).to.equal(201);
    expect(res.body.token).to.be.a("string");
  });

  it("should login an existing user", async function () {
    const res = await supertest(app).post("/auth/login").send({
      email: "testuser@example.com",
      password: "password123",
    });

    expect(res.status).to.equal(200);
    expect(res.body.token).to.be.a("string");
  });

  it("should handle Google authentication for new users", function () {
    supertest(app).post("/auth/google").send({
      uid: "unique_google_user_id",
      email: "googleuser@example.com",
      photoURL: "https://example.com/avatar.jpg",
      isNewUser: true,
    });
  });

  it("should handle Google authentication for existing users", function () {
    supertest(app).post("/auth/google").send({
      uid: "unique_google_user_id",
      email: "googleuser@example.com",
      photoURL: "https://example.com/avatar.jpg",
      isNewUser: false,
    });
  });
});
