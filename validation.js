const { z } = require('zod');

// Define the "Front Door" security rules
const signUpSchema = z.object({
  email: z.string().email({ message: "Invalid email address" }),
  password: z.string()
    .min(8, { message: "Password must be at least 8 characters long" })
    .regex(/[0-9]/, { message: "Password must contain at least one number" })
    .regex(/[a-z]/, { message: "Password must contain at least one lowercase letter" }),
  role: z.enum(["farmer", "buyer", "admin"], { message: "Invalid user role" })
});

// TEST: Simulate a hacker trying to use a 3-character password
try {
  const result = signUpSchema.parse({
    email: "hacker@evil.com",
    password: "123", // Too short!
    role: "admin"
  });
  console.log("Data is clean:", result);
} catch (e) {
  console.error("❌ SECURITY ALERT:", e.errors.map(err => err.message));
}
