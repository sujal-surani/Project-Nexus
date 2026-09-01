const express = require("express");
const app = express();

const port = 80;

app.get('/api/health', (res, req) =>{
    res.status(200).json({status : 'healthy', pipeline : 'active', version : "1.0" });
});

app.listen(port, () => console.log(`Nexus api running on port ${port}`));