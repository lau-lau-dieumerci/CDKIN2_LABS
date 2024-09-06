
# Tutoriel : Mise en Place d'une Réplication Master-Master MySQL avec un Load Balancer sur AWS

Dans ce tutoriel, nous allons vous guider à travers les étapes nécessaires pour configurer une infrastructure AWS qui inclut la balance des charges et la réplication Master-Master pour MySQL. Nous allons utiliser trois instances EC2 : une pour le proxy (avec Nginx) et deux pour les bases de données MySQL, réparties sur deux sous-réseaux différents.

## Prérequis

- Un compte AWS actif.
- Connaissance de base de la gestion des instances EC2 et de MySQL.
- Accès à la console AWS et à un terminal (pour SSH).

## Étape 1 : Lancer les Instances EC2

### 1.1. Créer les Instances EC2

1. Connectons-nous à la console AWS.
2. Allons dans la section **EC2** et cliquons sur **Launch Instance**.
3. Sélectionnons un **Amazon Machine Image (AMI)** basé sur **Amazon Linux 2**.
4. Choisissons un type d'instance (t2.micro suffira pour ce tutoriel).
5. Créons trois instances :
    - Une instance dans un **subnet public** (serveur proxy).
    - Deux instances dans des **subnets privés** différents (serveurs MySQL).

### 1.2. Configurer la Sécurité

1. Configurons les **Groupes de Sécurité** pour permettre :
   - SSH (port 22) pour accéder aux instances.
   - HTTP (port 80) et/ou HTTPS (port 443) pour le proxy.
   - MySQL (port 3306) pour permettre la communication entre les serveurs MySQL.

## Étape 2 : Configurer MySQL sur les Instances

### 2.1. Installer MySQL

1. Connectons-nous à chaque instance MySQL via SSH.
2. Installons MySQL sur chaque instance :

   ```bash
   sudo yum update -y
   sudo yum install mysql-server -y
   sudo systemctl start mysqld
   sudo systemctl enable mysqld
   ```

3. Accédons à MySQL pour définir un mot de passe root :

   ```bash
   sudo mysql_secure_installation
   ```

### 2.2. Configurer la Réplication Master-Master

1. Ouvrons le fichier de configuration MySQL sur chaque instance :

   ```bash
   sudo nano /etc/my.cnf
   ```

2. Ajoutons les configurations suivantes pour la réplication :

   **Instance 1 (Master 1):**

   ```ini
   [mysqld]
   server-id=1
   log-bin=mysql-bin
   auto_increment_increment=2
   auto_increment_offset=1
   ```

   **Instance 2 (Master 2):**

   ```ini
   [mysqld]
   server-id=2
   log-bin=mysql-bin
   auto_increment_increment=2
   auto_increment_offset=2
   ```

3. Redémarrons MySQL sur chaque instance :

   ```bash
   sudo systemctl restart mysqld
   ```

4. Créons un utilisateur de réplication sur **Master 1** :

   ```sql
   CREATE USER 'repl'@'%' IDENTIFIED BY 'password';
   GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
   ```

5. Faisons une sauvegarde de la base de données actuelle sur **Master 1** :

   ```bash
   mysqldump -u root -p --all-databases --master-data > dbdump.sql
   ```

6. Importons cette sauvegarde sur **Master 2** :

   ```bash
   mysql -u root -p < dbdump.sql
   ```

7. Configurons **Master 1** comme esclave de **Master 2** et vice versa :

   **Sur Master 1 :**

   ```sql
   CHANGE MASTER TO MASTER_HOST='Master2_IP', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=0;
   START SLAVE;
   ```

   **Sur Master 2 :**

   ```sql
   CHANGE MASTER TO MASTER_HOST='Master1_IP', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=0;
   START SLAVE;
   ```

8. Vérifions l'état de la réplication :

   ```sql
   SHOW SLAVE STATUS\G
   ```

## Étape 3 : Configurer Nginx comme Proxy et Load Balancer

### 3.1. Installer Nginx

1. Connectons-nous à l'instance publique (proxy) via SSH.
2. Installons Nginx :

   ```bash
   sudo yum update -y
   sudo amazon-linux-extras install nginx1 -y
   sudo systemctl start nginx
   sudo systemctl enable nginx
   ```

### 3.2. Configurer Nginx pour la Balance des Charges

1. Ouvrons le fichier de configuration Nginx :

   ```bash
   sudo nano /etc/nginx/nginx.conf
   ```

2. Ajoutons un bloc de configuration pour le load balancing :

   ```nginx
   http {
       upstream mysqlcluster {
           server Master1_IP:3306;
           server Master2_IP:3306;
       }

       server {
           listen 80;
           location / {
               proxy_pass http://mysqlcluster;
           }
       }
   }
   ```

3. Testons la configuration et redémarrons Nginx :

   ```bash
   sudo nginx -t
   sudo systemctl restart nginx
   ```

## Étape 4 : Vérifications et Tests

Pour vérifier que la configuration de la réplication Master-Master et du proxy Nginx fonctionne correctement, vous pouvez suivre les étapes suivantes :

### 4.1. Tester la Connexion au Proxy Nginx

Tout d'abord, assurez-vous que Nginx est bien configuré et que le proxy balance les charges entre les deux serveurs MySQL.

#### 4.1.1. Connexion via le Proxy

1. **Installer le client MySQL** sur votre machine locale si ce n'est pas déjà fait.
   - Sur une machine Linux ou macOS, vous pouvez installer le client MySQL en utilisant la commande suivante :
     ```bash
     sudo apt-get install mysql-client
     ```
   - Sur Windows, vous pouvez télécharger MySQL Workbench ou utiliser le client MySQL via la ligne de commande.

2. **Connectez-vous au proxy Nginx** en utilisant l'adresse IP publique de l'instance EC2 où Nginx est installé :

   ```bash
   mysql -h <Nginx_Public_IP> -u root -p
   ```

   - `<Nginx_Public_IP>` est l'adresse IP publique de l'instance EC2 où Nginx est configuré.

3. Une fois connecté, exécutez des commandes SQL simples, comme lister les bases de données disponibles :

   ```sql
   SHOW DATABASES;
   ```

   Cette commande doit renvoyer les bases de données disponibles, ce qui confirme que vous êtes connecté à un des serveurs MySQL via le proxy Nginx.

#### 4.1.2. Vérifier la Distribution des Requêtes

Pour vérifier que les requêtes sont bien distribuées entre les deux serveurs MySQL :

1. **Surveiller les Logs MySQL** : Connectez-vous à chaque serveur MySQL via SSH et surveillez les logs MySQL pour voir les requêtes entrantes :

   ```bash
   tail -f /var/log/mysqld.log
   ```

2. **Exécuter plusieurs requêtes via le proxy** : Dans la session MySQL connectée via le proxy Nginx, exécutez plusieurs commandes SQL, par exemple :

   ```sql
   SELECT DATABASE();
   ```

   - Les logs sur chaque serveur MySQL doivent montrer les requêtes, ce qui indiquera que Nginx distribue les requêtes entre les deux serveurs.

### 4.2. Vérifier la Réplication Master-Master

Pour vérifier que la réplication Master-Master fonctionne correctement :

#### 4.2.1. Créer une Base de Données et une Table sur Master 1

1. Connectez-vous directement à **Master 1** via SSH ou MySQL client.
2. Créez une nouvelle base de données et une table simple :

   ```sql
   CREATE DATABASE testdb;
   USE testdb;
   CREATE TABLE test_table (
       id INT PRIMARY KEY AUTO_INCREMENT,
       data VARCHAR(100)
   );
   INSERT INTO test_table (data) VALUES ('Hello from Master 1');
   ```

#### 4.2.2. Vérifier la Réplication sur Master 2

1. Connectez-vous à **Master 2** via SSH ou MySQL client.
2. Vérifiez que la base de données, la table et les données sont bien répliquées :

   ```sql
   USE testdb;
   SELECT * FROM test_table;
   ```

   - Vous devriez voir la table `test_table` avec la donnée insérée depuis **Master 1**.

#### 4.2.3. Tester la Réplication Inverse

1. Sur **Master 2**, insérez une nouvelle donnée dans la même table :

   ```sql
   INSERT INTO test_table (data) VALUES ('Hello from Master 2');
   ```

2. Revenez sur **Master 1** et vérifiez que la nouvelle entrée est bien répliquée :

   ```sql
   SELECT * FROM test_table;
   ```

   - Vous devriez voir à la fois l'entrée créée sur **Master 1** et celle créée sur **Master 2**.

## Conclusion

Nous avons maintenant une infrastructure fonctionnelle avec une réplication MySQL Master-Master, équilibrée par un proxy Nginx sur AWS. Cette configuration assure la haute disponibilité et la répartition des charges, garantissant la résilience et l'efficacité de votre base de données.
