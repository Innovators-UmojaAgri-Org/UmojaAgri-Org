const bcrypt = require("bcryptjs");
const { registerUser, findUserByEmail, getUserProfile, updateUserProfile } = require("./usersService");
const { generateToken } = require("../../shared/utils/jwt");

async function register(req, res) {
  try {
    const user = await registerUser(req.body);
    res.status(201).json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function login(req, res) {
  try {
    const user = await findUserByEmail(req.body.email);

    if (!user) {
      return res.status(401).json({ error: "User is not registered. Please sign up first" });
    }

    const valid = await bcrypt.compare(req.body.password, user.password);

    if (!valid) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    const token = generateToken(user);

    res.json({ token });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getProfile(req, res) {
  try {
    const user = await getUserProfile(req.user.userId);
    if (!user) return res.status(404).json({ error: "User not found" });
    res.json({ success: true, data: user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function updateProfile(req, res) {
  try {
    const user = await updateUserProfile(req.user.userId, req.body);
    res.json({ success: true, data: user });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

module.exports = { register, login, getProfile, updateProfile };
