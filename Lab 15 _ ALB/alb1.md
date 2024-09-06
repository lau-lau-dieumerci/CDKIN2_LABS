
# Tutoriel : Déploiement d'une Application Load Balancer (ALB) avec Deux Target Groups sur AWS

Ce tutoriel vous guidera à travers les étapes nécessaires pour configurer un Application Load Balancer (ALB) sur AWS, qui redirige le trafic vers deux groupes de cibles (Target Groups) distincts en fonction des paramètres de l'URL (`/user` et `/admin`). Vous allez également configurer l'auto-scaling pour les instances dans chaque groupe de cibles et déployer des applications Node.js avec Express.

## Prérequis

- Un compte AWS actif
- AWS CLI installé et configuré
- Node.js installé sur votre machine locale
- Connaissance de base en AWS, EC2, Auto Scaling et Elastic Load Balancing

## Étape 1 : Création des Applications Node.js

Créez deux applications Node.js simples qui répondront aux requêtes pour les routes `/user` et `/admin`.

1. **Application User**

   Créez un répertoire pour l'application User :
   ```bash
   mkdir user-app && cd user-app
   ```

   Initialisez un projet Node.js :
   ```bash
   npm init -y
   ```

   Installez Express :
   ```bash
   npm install express
   ```

   Créez un fichier `index.js` et ajoutez le code suivant :
   ```javascript
   const express = require('express');
   const app = express();
   const port = 3000;

   app.get('/user', (req, res) => {
       res.send('Hello User!');
   });

   app.listen(port, () => {
       console.log(`User app listening on port ${port}`);
   });
   ```

   Testez l'application localement :
   ```bash
   node index.js
   ```
   Accédez à `http://localhost:3000/user` pour vérifier que l'application fonctionne correctement.

2. **Application Admin**

   Répétez les étapes ci-dessus pour créer une application Admin. Dans le fichier `index.js`, remplacez la route `/user` par `/admin` :
   ```javascript
   const express = require('express');
   const app = express();
   const port = 3000;

   app.get('/admin', (req, res) => {
       res.send('Hello Admin!');
   });

   app.listen(port, () => {
       console.log(`Admin app listening on port ${port}`);
   });
   ```

## Étape 2 : Préparation des AMI pour les Applications

Pour déployer ces applications sur AWS, vous devez créer une image AMI pour chaque application.

1. **Création d'une Instance EC2**

   - Connectez-vous à la console AWS.
   - Lancez une instance EC2 (Amazon Linux 2 AMI).
   - Connectez-vous à l'instance via SSH.

2. **Installation de Node.js et Déploiement de l'Application**

   Sur l'instance EC2, installez Node.js :
   ```bash
   sudo yum update -y
   sudo yum install -y gcc-c++ make
   curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash -
   sudo yum install -y nodejs
   ```

   Clonez votre application depuis votre machine locale ou copiez les fichiers via SCP.

   Démarrez l'application pour s'assurer qu'elle fonctionne :
   ```bash
   node index.js
   ```

3. **Création d'une AMI**

   - Arrêtez l'application (`Ctrl + C`).
   - Sur la console AWS, créez une image AMI à partir de cette instance EC2.
   - Répétez cette procédure pour l'application Admin.

## Étape 3 : Configuration de l'Auto Scaling

1. **Création de Groupes de Cibles (Target Groups)**

   - Accédez à la console AWS EC2.
   - Créez deux Target Groups : `user-target-group` et `admin-target-group`.
   - Sélectionnez `Instance` comme type de cible et `HTTP` comme protocole.
   - Configurez les vérifications d'état (health checks) sur les chemins `/user` et `/admin` respectivement.

2. **Création de Groupes Auto Scaling**

   - Créez un Auto Scaling Group pour chaque Target Group.
   - Lors de la création, sélectionnez les AMI respectives (une pour User, une pour Admin).
   - Associez chaque Auto Scaling Group avec le Target Group correspondant.
   - Configurez les politiques d'auto-scaling basées sur l'utilisation du CPU ou d'autres métriques pertinentes.

## Étape 4 : Configuration de l'Application Load Balancer (ALB)

1. **Création de l'ALB**

   - Accédez à la section "Load Balancers" dans la console EC2.
   - Créez un ALB.
   - Sélectionnez au moins deux sous-réseaux pour la haute disponibilité.
   - Configurez le Listener HTTP (port 80).

2. **Ajout de Règles de Routage**

   - Dans la section "Listeners", ajoutez des règles de routage basées sur les URL :
     - Si l'URL contient `/user`, redirigez vers `user-target-group`.
     - Si l'URL contient `/admin`, redirigez vers `admin-target-group`.

3. **Attacher les Groupes de Cibles**

   - Attachez `user-target-group` et `admin-target-group` à l'ALB en fonction des règles de routage définies.

## Étape 5 : Test et Validation

1. **Obtenez l'URL du Load Balancer**

   - Une fois le déploiement terminé, notez l'URL DNS de votre ALB.

2. **Testez les Applications**

   - Accédez à `http://<ALB-DNS>/user` pour vérifier que la demande est redirigée vers l'application User.
   - Accédez à `http://<ALB-DNS>/admin` pour vérifier que la demande est redirigée vers l'application Admin.

## Conclusion

Vous avez maintenant configuré avec succès un Application Load Balancer (ALB) sur AWS qui redirige le trafic vers deux groupes de cibles distincts en fonction des paramètres de l'URL. Vous avez également configuré l'auto-scaling pour gérer automatiquement la charge sur vos applications.
