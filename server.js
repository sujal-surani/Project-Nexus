const express = require("express");
const app = express();
const path = require("path");

const port = 80;

app.get('/api/health', (req, res) =>{
    res.status(200).json({status : 'healthy', pipeline : 'active', version : "1.0" });
});


app.get('/', (req,res) =>{
    res.sendFile(path.join(__dirname,'public', 'index.html'));
});
app.listen(port,'0.0.0.0', () => console.log(`Nexus api running on port ${port}`));