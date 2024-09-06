const express = require('express');
const app = express();

app.get('/home', (req, res) => {
    console.log("Tout tourne sans problème");
    res.status(200).sendFile(__dirname + '/home.html');
});

app.get('/help', (req, res) => {
    console.error("Simulation d'erreur");
    res.status(200).sendFile(__dirname + '/help.html');
});

app.listen(9000, () => {
    console.log('Le serveur tourne sur le port 9000');
});
