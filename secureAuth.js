require('dotenv').config(); // Load the vault
const { z } = require('zod');
const bcrypt = require('bcryptjs');

// Accessing secrets safely from the environment
const saltRounds = parseInt(process.env.SALT_ROUNDS) || 10;

async function registerUser(userInput) {
    // ... validation logic stays the same ...
    const salt = await bcrypt.genSalt(saltRounds); 
    const hashedPassword = await bcrypt.hash(userInput.password, salt);
    console.log("Using Salt Rounds from .env:", saltRounds);
    // ...
}

// 1. FRONT DOOR: Define the Schema (Zod)
const userSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).regex(/[0-9]/),
  role: z.enum(["farmer", "buyer"])
});

async function registerUser(userInput) {
  try {
    // 2. VALIDATION: Check if data is malicious or malformed
    const validatedData = userSchema.parse(userInput);
    console.log("✅ Step 1: Input Validation Passed.");

    // 3. BACK DOOR: Hash the password once data is confirmed "clean"
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(validatedData.password, salt);
    
    // 4. RESULT: This object is what actually goes to your database
    const secureUserEntry = {
      email: validatedData.email,
      password: hashedPassword,
      role: validatedData.role
    };

    console.log("✅ Step 2: Password Hashed Successfully.");
    console.log("Final Secure Object:", secureUserEntry);
    
  } catch (error) {
    console.error("❌ SECURITY BLOCK:", error.errors ? error.errors.map(e => e.message) : error.message);
  }
}

// TEST: Simulate a successful registration
registerUser({
  email: "farmer_joy@umoja.com",
  password: "SafePassword2026",
  role: "farmer"
});


