const bcrypt = require('bcryptjs'); // Using the JS version for better compatibility

// This is what happens when a farmer registers on your "Sign Up" screen
async function hashFarmerPassword(password) {
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    console.log("Secure Hash to save in DB:", hashedPassword);
}

hashFarmerPassword("FarmerSecure2026!");
