require('dotenv').config();
const jwt = require('jsonwebtoken');

// 1. The Secret Key (Loaded from your .env for security)
const secretKey = process.env.DB_PASSWORD || 'emergency_secret';

// 2. The Notification Payload
const notification = {
    farmerId: "FARM-772",
    message: "Payment of 50,000 NGN confirmed for Maize delivery.",
    timestamp: new Date().toISOString()
};

// 3. Signing the Notification (The Handshake)
// This creates a "Digital Signature" that only your server can produce
function generateSecureNotice(data) {
    return jwt.sign(data, secretKey, { expiresIn: '24h' });
}

const secureToken = generateSecureNotice(notification);

console.log("✉️  --- UmojaAgri Secure Notification ---");
console.log("Original Message:", notification.message);
console.log("Signed Secure Token (Send this to the farmer):", secureToken);
