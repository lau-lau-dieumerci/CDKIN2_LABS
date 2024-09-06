
# Configuration d'un Application Load Balancer (ALB) avec Auto Scaling sur AWS

Ce tutoriel vous guide à travers la configuration d'un **Application Load Balancer (ALB)** qui distribue le trafic HTTP vers une application Node.js Express écoutant sur le port 5000. Le tutoriel inclut la création d'un Auto Scaling Group pour gérer automatiquement le nombre d'instances en fonction de la charge.

## Prérequis

Avant de commencer, assurez-vous d'avoir :

1. Un compte AWS.
2. AWS CLI installé et configuré.
3. Un VPC avec au moins deux sous-réseaux publics.
4. Une clé SSH pour accéder à vos instances EC2.

## Étape 1 : Préparer l'AMI avec Node.js et l'application Express

Commencez par lancer une instance EC2 qui sera utilisée pour créer une image AMI. Connectez-vous à l'instance et suivez les étapes suivantes :

```bash
# Mettre à jour le système
sudo yum update -y

# Installer Node.js et npm
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

# Créer un répertoire pour l'application
mkdir -p ~/myapp && cd ~/myapp

# Initialiser un projet Node.js et installer Express
npm init -y
npm install express --save

# Créer l'application Express de base
echo "const express = require('express');
const app = express();
const port = 5000;

app.get('/', (req, res) => res.send('Hello from Node.js on port 5000!'));

app.listen(port, () => console.log(\`App listening on port \${port}\`));" > index.js

# Exécuter l'application pour vérifier qu'elle fonctionne
node index.js
```

Si tout fonctionne, vous devriez voir `App listening on port 5000` dans la console.

### Créer une AMI

1. Arrêtez l'application avec `Ctrl+C`.
2. Revenez à la console AWS et créez une AMI à partir de cette instance.

## Étape 2 : Créer un Target Group

1. Allez dans la section **EC2** de la console AWS.
2. Sous **Load Balancing**, cliquez sur **Target Groups** puis sur **Create target group**.
3. Configurez le Target Group :
   - **Choose a target type** : Instances.
   - **Protocol** : HTTP.
   - **Port** : 5000.
   - **VPC** : Sélectionnez votre VPC.
   - **Health checks** : Gardez les valeurs par défaut.
4. Cliquez sur **Next** et **Create** sans ajouter d'instances pour le moment.

## Étape 3 : Créer un Application Load Balancer (ALB)

1. Allez dans la section **EC2** > **Load Balancers**.
2. Cliquez sur **Create Load Balancer** et sélectionnez **Application Load Balancer**.
3. Configurez l'ALB :
   - **Name** : `my-alb`.
   - **Scheme** : Internet-facing.
   - **IP address type** : IPv4.
   - **Listeners** : Gardez HTTP (port 80).
   - **VPC** : Sélectionnez votre VPC.
   - **Availability Zones** : Sélectionnez deux sous-réseaux publics.
4. Cliquez sur **Next: Configure Security Groups** et associez un groupe de sécurité qui autorise le trafic entrant sur le port 80.
5. Dans **Configure Routing**, sélectionnez le **Target Group** que vous avez créé précédemment.
6. Cliquez sur **Create Load Balancer**.

## Étape 4 : Configurer un Auto Scaling Group

1. Allez dans la section **EC2** > **Auto Scaling Groups**.
2. Cliquez sur **Create Auto Scaling group**.
3. Configurez le groupe d'auto scaling :
   - **Name** : `my-asg`.
   - **Launch Template** : Utilisez l'AMI que vous avez créée.
   - **VPC** : Sélectionnez votre VPC.
   - **Subnets** : Sélectionnez les mêmes sous-réseaux que pour l'ALB.
4. Attachez le **Target Group** au groupe d'auto scaling.
5. Configurez le nombre minimal, maximal et désiré d'instances.
6. Cliquez sur **Create Auto Scaling Group**.

## Étape 5 : Vérification

1. Allez dans la section **Load Balancers** et copiez l'URL DNS de votre ALB.
2. Collez l'URL dans un navigateur, vous devriez voir le message "Hello from Node.js on port 5000!".

## Conclusion

Vous avez maintenant configuré un **Application Load Balancer (ALB)** avec un **Auto Scaling Group** sur AWS pour distribuer le trafic HTTP vers votre application Node.js Express. L'Auto Scaling Group va gérer automatiquement le nombre d'instances pour s'adapter à la charge, assurant ainsi la haute disponibilité de votre application.
