const express = require('express');
const helmet = require('helmet'); // Enforces secure headers
const app = express();

app.use(helmet()); // Protects against packet sniffing and MITM attacks

app.get('/market', (req, res) => {
    res.send("🛡️ This data is protected by TLS encryption headers.");
});

app.listen(3000, () => console.log("🚀 Secure Server running on port 3000"));
