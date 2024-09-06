
# Tutoriel : Mise en Place d'une Réplication Master-Slave MySQL avec un Load Balancer sur AWS

Dans ce tutoriel, nous allons configurer une infrastructure AWS qui inclut un load balancer (avec Nginx) et une réplication Master-Slave pour MySQL. Nous utiliserons trois instances EC2 : une pour le proxy Nginx et deux pour les bases de données MySQL réparties sur deux sous-réseaux différents.

## Prérequis

- Un compte AWS actif.
- Connaissance de base de la gestion des instances EC2 et de MySQL.
- Accès à la console AWS et à un terminal (pour SSH).

## Étape 1 : Lancer les Instances EC2

### 1.1. Créer les Instances EC2

1. Connectez-vous à la console AWS.
2. Allez dans la section **EC2** et cliquez sur **Launch Instance**.
3. Sélectionnez un **Amazon Machine Image (AMI)** basé sur **Amazon Linux 2**.
4. Choisissez un type d'instance (t2.micro suffira pour ce tutoriel).
5. Créez trois instances :
    - Une instance dans un **subnet public** (serveur proxy).
    - Deux instances dans des **subnets privés** différents (serveurs MySQL : un Master et un Slave).

### 1.2. Configurer la Sécurité

1. Configurez les **Groupes de Sécurité** pour permettre :
   - SSH (port 22) pour accéder aux instances.
   - HTTP (port 80) et/ou HTTPS (port 443) pour le proxy.
   - MySQL (port 3306) pour permettre la communication entre les serveurs MySQL.

## Étape 2 : Configurer MySQL sur les Instances

### 2.1. Installer MySQL

1. Connectez-vous à chaque instance MySQL (Master et Slave) via SSH.
2. Installez MySQL sur chaque instance :

   ```bash
   sudo yum update -y
   sudo yum install mysql-server -y
   sudo systemctl start mysqld
   sudo systemctl enable mysqld
   ```

3. Accédez à MySQL pour définir un mot de passe root :

   ```bash
   sudo mysql_secure_installation
   ```

### 2.2. Configurer la Réplication Master-Slave

#### 2.2.1. Configuration du Master

1. Ouvrez le fichier de configuration MySQL sur l'instance Master :

   ```bash
   sudo nano /etc/my.cnf
   ```

2. Ajoutez les configurations suivantes pour la réplication :

   ```ini
   [mysqld]
   server-id=1
   log-bin=mysql-bin
   ```

3. Redémarrez MySQL sur le Master :

   ```bash
   sudo systemctl restart mysqld
   ```

4. Connectez-vous à MySQL et créez un utilisateur de réplication :

   ```sql
   CREATE USER 'repl'@'%' IDENTIFIED BY 'password';
   GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
   FLUSH PRIVILEGES;
   ```

5. Verrouillez les tables et notez la position du log binaire :

   ```sql
   FLUSH TABLES WITH READ LOCK;
   SHOW MASTER STATUS;
   ```

   Notez le nom du fichier log (`File`) et la position (`Position`) affichés, vous en aurez besoin pour configurer le Slave.

6. Sauvegardez la base de données actuelle sur le Master :

   ```bash
   mysqldump -u root -p --all-databases --master-data > dbdump.sql
   ```

7. Déverrouillez les tables :

   ```sql
   UNLOCK TABLES;
   ```

#### 2.2.2. Configuration du Slave

1. Ouvrez le fichier de configuration MySQL sur l'instance Slave :

   ```bash
   sudo nano /etc/my.cnf
   ```

2. Ajoutez les configurations suivantes pour la réplication :

   ```ini
   [mysqld]
   server-id=2
   ```

3. Redémarrez MySQL sur le Slave :

   ```bash
   sudo systemctl restart mysqld
   ```

4. Transférez le fichier `dbdump.sql` du Master au Slave, puis importez-le sur le Slave :

   ```bash
   scp -i /path/to/key.pem ec2-user@<Master_IP>:/path/to/dbdump.sql .
   mysql -u root -p < dbdump.sql
   ```

5. Configurez le Slave pour commencer la réplication à partir du Master :

   ```sql
   CHANGE MASTER TO MASTER_HOST='<Master_IP>', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=0;
   START SLAVE;
   ```

6. Vérifiez que la réplication fonctionne correctement :

   ```sql
   SHOW SLAVE STATUS\G
   ```

   - Assurez-vous que `Slave_IO_Running` et `Slave_SQL_Running` sont tous deux sur `Yes`.

## Étape 3 : Configurer Nginx comme Proxy et Load Balancer

### 3.1. Installer Nginx

1. Connectez-vous à l'instance publique (proxy) via SSH.
2. Installez Nginx :

   ```bash
   sudo yum update -y
   sudo amazon-linux-extras install nginx1 -y
   sudo systemctl start nginx
   sudo systemctl enable nginx
   ```

### 3.2. Configurer Nginx pour la Balance des Charges

1. Ouvrez le fichier de configuration Nginx :

   ```bash
   sudo nano /etc/nginx/nginx.conf
   ```

2. Ajoutez un bloc de configuration pour le load balancing :

   ```nginx
   http {
       upstream mysqlcluster {
           server <Master_IP>:3306;
           server <Slave_IP>:3306 backup;
       }

       server {
           listen 80;
           location / {
               proxy_pass http://mysqlcluster;
           }
       }
   }
   ```

   - **Note :** Le mot-clé `backup` indique que Nginx enverra les requêtes au Slave uniquement si le Master est indisponible.

3. Testez la configuration et redémarrez Nginx :

   ```bash
   sudo nginx -t
   sudo systemctl restart nginx
   ```

## Étape 4 : Vérifications et Tests

### 4.1. Tester la Connexion au Proxy Nginx

1. Depuis votre machine locale, connectez-vous à MySQL via le proxy Nginx :

   ```bash
   mysql -h <Nginx_Public_IP> -u root -p
   ```

2. Exécutez des commandes SQL simples pour vérifier que vous pouvez accéder à la base de données :

   ```sql
   SHOW DATABASES;
   ```

### 4.2. Tester la Réplication Master-Slave

1. Sur le Master, créez une nouvelle base de données et une table simple :

   ```sql
   CREATE DATABASE testdb;
   USE testdb;
   CREATE TABLE test_table (
       id INT PRIMARY KEY AUTO_INCREMENT,
       data VARCHAR(100)
   );
   INSERT INTO test_table (data) VALUES ('Hello from Master');
   ```

2. Connectez-vous au Slave et vérifiez que la nouvelle base de données et la table ont été répliquées :

   ```sql
   USE testdb;
   SELECT * FROM test_table;
   ```

   - Vous devriez voir les données insérées depuis le Master.

### 4.3. Simuler une Défaillance du Master

1. Arrêtez MySQL sur le Master :

   ```bash
   sudo systemctl stop mysqld
   ```

2. Essayez d'insérer des données via le proxy Nginx. Nginx doit rediriger les requêtes vers le Slave. Cependant, étant donné que le Slave est en mode lecture seule, les tentatives d'écriture échoueront.

3. Redémarrez le service MySQL sur le Master :

   ```bash
   sudo systemctl start mysqld
   ```

## Conclusion

Vous avez maintenant une infrastructure AWS fonctionnelle avec une réplication MySQL Master-Slave, équilibrée par un proxy Nginx. Cette configuration assure la disponibilité des données tout en répartissant la charge de travail, garantissant ainsi la résilience de votre système.
