
# Tutoriel : Déploiement d'un site Web avec API Gateway, Lambda, S3, EC2, MySQL, et Secrets Manager

## Introduction

Ce tutoriel vous guidera à travers le processus de création d'une application Web hébergée sur S3 avec des pages de connexion et d'enregistrement, en utilisant API Gateway et Lambda pour gérer les requêtes POST. Vous apprendrez également à automatiser le déploiement sur EC2, à configurer MySQL et Secrets Manager, et à résoudre les problèmes de CORS.

## Prérequis

- Compte AWS
- AWS CLI installé et configuré
- Node.js installé

## Étape 1 : Préparer les ressources AWS

### 1.1 Création du Bucket S3

1. Accédez à la console AWS S3.
2. Créez un nouveau bucket avec un nom unique.
3. Téléchargez les fichiers HTML pour les pages de connexion et d'enregistrement dans le bucket.

### 1.2 Création d'une instance EC2

1. Accédez à la console EC2.
2. Lancez une nouvelle instance (par exemple, Amazon Linux 2).
3. Configurez les groupes de sécurité pour autoriser les connexions HTTP/HTTPS et SSH.

### 1.3 Installation de MySQL sur EC2

1. Connectez-vous à l'instance EC2 via SSH.
2. Installez MySQL :
   ```bash
   sudo yum update -y
   sudo yum install mysql-server -y
   sudo service mysqld start
   sudo mysql_secure_installation
   ```
3. Créez une base de données et un utilisateur pour votre application.

### 1.4 Configuration de Secrets Manager

1. Accédez à la console Secrets Manager.
2. Créez un nouveau secret pour les identifiants MySQL :
   - Nom du secret : `MySQLCredentials`
   - Clés et valeurs :
     - `username` : `votre_utilisateur`
     - `password` : `votre_mot_de_passe`
     - `host` : `endpoint_mysql_ec2`

## Étape 2 : Développement des Lambdas

### 2.1 Création de Lambda pour /login

1. Accédez à la console Lambda.
2. Créez une nouvelle fonction Lambda :
   - Nom : `LoginFunction`
   - Runtime : Node.js 14.x

3. Collez le code suivant dans l'éditeur Lambda :

   ```javascript
   const AWS = require('aws-sdk');
   const mysql = require('mysql2');

   exports.handler = async (event) => {
       const secretsManager = new AWS.SecretsManager();
       const secret = await secretsManager.getSecretValue({ SecretId: 'MySQLCredentials' }).promise();
       const credentials = JSON.parse(secret.SecretString);

       const connection = mysql.createConnection({
           host: credentials.host,
           user: credentials.username,
           password: credentials.password
       });

       connection.query('SELECT * FROM users WHERE username = ?', [event.username], (error, results) => {
           if (error) throw error;
           return {
               statusCode: 200,
               body: JSON.stringify(results)
           };
       });
   };
   ```

### 2.2 Création de Lambda pour /register

1. Répétez les étapes de création de fonction Lambda pour une nouvelle fonction appelée `RegisterFunction`.
2. Collez le code suivant dans l'éditeur Lambda :

   ```javascript
   const AWS = require('aws-sdk');
   const mysql = require('mysql2');

   exports.handler = async (event) => {
       const secretsManager = new AWS.SecretsManager();
       const secret = await secretsManager.getSecretValue({ SecretId: 'MySQLCredentials' }).promise();
       const credentials = JSON.parse(secret.SecretString);

       const connection = mysql.createConnection({
           host: credentials.host,
           user: credentials.username,
           password: credentials.password
       });

       connection.query('INSERT INTO users (username, password) VALUES (?, ?)', [event.username, event.password], (error, results) => {
           if (error) throw error;
           return {
               statusCode: 200,
               body: JSON.stringify({ message: 'User registered successfully' })
           };
       });
   };
   ```

## Étape 3 : Configuration de API Gateway

### 3.1 Création d'un API Gateway

1. Accédez à la console API Gateway.
2. Créez une nouvelle API REST.
3. Configurez les ressources `/login` et `/register`.
4. Ajoutez des méthodes POST aux ressources :
   - Sélectionnez la méthode POST.
   - Intégrez la méthode avec les fonctions Lambda correspondantes (`LoginFunction` et `RegisterFunction`).

### 3.2 Déploiement de l'API

1. Créez un nouveau déploiement et assignez-le à un stage.
2. Notez l'URL de votre API.

## Étape 4 : Configurer les en-têtes CORS

1. Pour chaque méthode POST dans API Gateway :
   - Accédez aux paramètres CORS.
   - Activez CORS et ajoutez les en-têtes nécessaires (par exemple, `Access-Control-Allow-Origin`).

## Étape 5 : Automatisation du déploiement

### 5.1 Utilisation de AWS CLI pour déployer le site Web

1. Utilisez la CLI pour synchroniser les fichiers du bucket S3 :

   ```bash
   aws s3 sync ./votre_dossier_local s3://votre_bucket --delete
   ```

### 5.2 Déploiement de votre application sur EC2

1. Connectez-vous à l'instance EC2 via SSH.
2. Clonez votre dépôt Git contenant le code source de l'application :

   ```bash
   git clone https://github.com/votre_utilisateur/votre_depot.git
   ```

3. Déployez l'application et configurez le serveur Web pour servir votre site depuis S3.


## Conclusion

Vous avez maintenant configuré une application Web avec des pages de connexion et d'enregistrement, déployé sur S3 et EC2, utilisant API Gateway et Lambda pour gérer les requêtes. Vous avez également configuré MySQL et Secrets Manager pour sécuriser les informations d'identification, et résolu les problèmes de CORS.

Pour toute question ou problème, consultez la [documentation AWS](https://docs.aws.amazon.com/) ou posez vos questions sur [GitHub](https://github.com/).

