const createToken = (user) => {
  return jwt.sign({ userID: user.id }, process.env.JWT_SECRET, {
    expiresIn: "30d",
  });
};

export const hashPassword = async (password) => {
  return await bcrypt.hash(password, await bcrypt.genSalt());
};

export const returnToken = async ({ user, req, res }) => {
  try {
    if (user) {
      const token = createToken(user);
      return res.status(200).json({ token });
    } else {
      throw new Error();
    }
  } catch (err) {
    return res.status(400).json({ msg: "Error returning token" });
  }
};

export const saveUserAndReturnToken = async ({ user, req, res }) => {
  try {
    await user.save();
    const token = createToken(user);
    return res.status(201).json({ token });
  } catch (err) {
    return res.status(400).json({ msg: "Error saving and returning token" });
  }
};
