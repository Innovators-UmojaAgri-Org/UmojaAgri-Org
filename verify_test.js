const bcrypt = require('bcryptjs');

async function loginSimulator(inputPassword, storedHashFromDatabase) {
    console.log("Checking password...");
    
    // bcrypt.compare handles extracting the salt and re-hashing automatically
    const isMatch = await bcrypt.compare(inputPassword, storedHashFromDatabase);
    
    if (isMatch) {
        console.log("✅ Access Granted: Welcome back to UmojaAgri!");
    } else {
        console.log("❌ Access Denied: The password you entered is incorrect.");
    }
}

// SIMULATION: This hash would normally come from your database
const mockStoredHash = "$2a$10$R9h/cIPz0gi.URNNX3kh2OPST9/PgBkqquzi.Ss7KIUgO2t0jWMUW";

// Test 1: Wrong Password
loginSimulator("WrongPassword123", mockStoredHash);

// Test 2: Correct Password (assuming the hash above matches this)
loginSimulator("FarmerSecure2026!", mockStoredHash);
