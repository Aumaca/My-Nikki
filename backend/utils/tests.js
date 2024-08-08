import supertest from "supertest";
import app from "../app.js";
import path from "path";
import fs from "fs";

export const removeFiles = (__dirname, filenames) => {
  const uploadDir = path.join(__dirname, "../uploads");
  filenames.forEach((file) => {
    fs.unlink(path.join(uploadDir, file), (err) => {
      if (err) throw err;
    });
  });
};

export const createUser = async (data) => {
  await supertest(app)
    .post("/auth/register")
    .send({ ...data });
};

export const loginUser = async (data) => {
  const res = await supertest(app)
    .post("/auth/login")
    .send({ ...data });
  return res.body.token;
};

export const createEntry = async (token, data, files, dirname, output) => {
  const filenames = [];
  const res = await supertest(app)
    .post("/entry")
    .set("Authorization", `Bearer ${token}`)
    .field("data", JSON.stringify(data))
    .attach("media", path.join(dirname, files[0]))
    .attach("media", files[1] ? path.join(dirname, files[1]) : "")
    .attach("media", files[2] ? path.join(dirname, files[2]) : "")
    .attach("media", files[3] ? path.join(dirname, files[3]) : "");

  if (res.statusCode === 201) {
    res.body.media.forEach((file) => filenames.push(file.split("\\")[1]));
  }

  if (output === "files") return filenames;
  else return res;
};

export const updateEntry = async (
  token,
  entryID,
  data,
  files,
  dirname,
  output
) => {
  const filenames = [];
  const res = await supertest(app)
    .put(`/entry/${entryID}`)
    .set("Authorization", `Bearer ${token}`)
    .field("data", JSON.stringify(data))
    .attach("media", path.join(dirname, files[0]))
    .attach("media", files[1] ? path.join(dirname, files[1]) : "")
    .attach("media", files[2] ? path.join(dirname, files[2]) : "")
    .attach("media", files[3] ? path.join(dirname, files[3]) : "");

  if (res.statusCode === 200) {
    res.body.media.forEach((file) => filenames.push(file.split("\\")[1]));
  }

  if (output === "files") return filenames;
  else return res;
};
