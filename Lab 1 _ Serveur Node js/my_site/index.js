const express = require('express');
const app = express();

// Route pour la page "home"
app.get('/home', (req, res) => {
  console.log('La page tourne sans problème');
  res.status(200).send('Je suis sur la home page!');
});

// Route pour la page "help"
app.get('/help', (req, res) => {
  console.error('La page comporte une simulation des erreurs');
  res.status(200).send('Je suis sur la help page !!!');
});

// Écoute du serveur sur le port 5000
app.listen(5000, () => {
  console.log('Le serveur tourne sur le port 5000');
});
