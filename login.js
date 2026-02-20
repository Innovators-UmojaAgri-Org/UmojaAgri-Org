require('dotenv').config();
const { z } = require('zod');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// 1. The Gatekeeper (Zod)
const loginSchema = z.object({
    email: z.string().email(),
    password: z.string().min(8)
});

async function loginHandshake(email, inputPassword, storedHash) {
    try {
        // Validate inputs
        loginSchema.parse({ email, password: inputPassword });

        // 2. The Password Check (Bcrypt)
        const isMatch = await bcrypt.compare(inputPassword, storedHash);
        
        if (!isMatch) {
            throw new Error("Invalid credentials");
        }

        // 3. The Digital Handshake (JWT)
        // We sign the token with a secret from your .env file
        const token = jwt.sign(
            { userEmail: email, role: 'farmer' }, 
            process.env.DB_PASSWORD || 'fallback_secret', 
            { expiresIn: '2h' }
        );

        console.log("✅ Handshake Complete: User Authenticated.");
        console.log("🎟️ Issued JWT Passport:", token);
        return token;

    } catch (error) {
        console.error("❌ Handshake Failed:", error.message);
    }
}

// SIMULATION: In reality, 'storedHash' comes from your database
const mockHash = "$2b$10$9wdm49yqvzccc6QLQYG8L.QBkdwBC8x7KC40DS3HisgMazFO6amOC"; 
loginHandshake("farmer_joy@umoja.com", "GreenFields2026!", "$2b$10$9wdm49yqvzccc6QLQYG8L.QBkdwBC8x7KC40DS3HisgMazFO6amOC");
