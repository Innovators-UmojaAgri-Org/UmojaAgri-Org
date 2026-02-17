const bcrypt = require("bcryptjs");
const { registerUser, findUserByEmail } = require("./usersService");
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
      return res.status(401).json({ error: "Invalid credentials" });
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

module.exports = { register, login };
