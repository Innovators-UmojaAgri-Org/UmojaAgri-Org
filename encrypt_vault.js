require('dotenv').config();
const crypto = require('crypto');

const algorithm = 'aes-256-cbc';
// Deriving a secure key from your .env
const key = crypto.scryptSync(process.env.DB_PASSWORD || 'default_secret', 'salt', 32);
const iv = crypto.randomBytes(16); 

function encrypt(text) {
    let cipher = crypto.createCipheriv(algorithm, key, iv);
    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return { iv: iv.toString('hex'), data: encrypted };
}

const farmerData = "Account_No: 9988776655";
const securePackage = encrypt(farmerData);

console.log("🔒 --- UmojaAgri Encryption at Rest ---");
console.log("Encrypted Hex:", securePackage.data);
console.log("IV (Needed for decryption):", securePackage.iv);
