# Tutoriel GitHub : Gestion des Privilèges d'Utilisateur dans une Base de Données AWS

## Objectif

Créer des tables dans une base de données AWS et configurer les privilèges pour un utilisateur spécifique afin de répondre aux exigences suivantes :
- Ne pas voir la table `RESET`
- Voir la liste des employés sans la colonne `PASSWORD`
- Lister les départements sans INSERT ni UPDATE
- Lister et insérer dans la table `TACHES`, sans UPDATE ni DELETE

## Prérequis

- Compte AWS
- Base de données RDS (ou DynamoDB, mais l'exemple utilisera RDS avec MySQL ou PostgreSQL)
- Accès à AWS Management Console ou outils de gestion de base de données (par exemple, MySQL Workbench, pgAdmin)

## Étapes

### 1. Créer les Tables

#### 1.1. Connectez-vous à votre Base de Données

Utilisez un client SQL ou l'interface de gestion de base de données de votre choix pour vous connecter à votre instance RDS.

#### 1.2. Créer les Tables

Voici les instructions SQL pour créer les tables demandées. Assurez-vous de remplacer les valeurs par celles adaptées à votre cas d'utilisation.

```sql
-- Créer la table RESET
CREATE TABLE RESET (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255) NOT NULL
);

-- Créer la table EMPLOYES
CREATE TABLE EMPLOYES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Créer la table DEPARTMENTS
CREATE TABLE DEPARTMENTS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL
);

-- Créer la table TACHES
CREATE TABLE TACHES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    task_description TEXT NOT NULL
);
```

### 2. Créer et Configurer l'Utilisateur

#### 2.1. Créer un Nouvel Utilisateur

Créez un utilisateur `Victoria` et attribuez-lui un mot de passe :

```sql
-- Pour MySQL
CREATE USER 'victoria'@'%' IDENTIFIED BY 'password123';

-- Pour PostgreSQL
CREATE USER victoria WITH PASSWORD 'password123';
```

#### 2.2. Configurer les Privilèges pour Victoria

Attribuez les privilèges requis pour l'utilisateur Victoria.

```sql
-- Pour MySQL

-- Ne pas voir la table RESET
REVOKE ALL PRIVILEGES ON RESET FROM 'victoria'@'%';

-- Voir la liste des employés sans la colonne PASSWORD
GRANT SELECT ON EMPLOYES TO 'victoria'@'%';
CREATE VIEW EMPLOYES_VIEW AS SELECT id, name FROM EMPLOYES;
REVOKE SELECT ON EMPLOYES FROM 'victoria'@'%';
GRANT SELECT ON EMPLOYES_VIEW TO 'victoria'@'%';

-- Lister tous les départements sans INSERT ni UPDATE
GRANT SELECT ON DEPARTMENTS TO 'victoria'@'%';
REVOKE INSERT, UPDATE ON DEPARTMENTS FROM 'victoria'@'%';

-- Lister et insérer dans la table TACHES, sans UPDATE ni DELETE
GRANT SELECT, INSERT ON TACHES TO 'victoria'@'%';
REVOKE UPDATE, DELETE ON TACHES FROM 'victoria'@'%';

-- Pour PostgreSQL

-- Ne pas voir la table RESET
REVOKE ALL PRIVILEGES ON RESET FROM victoria;

-- Voir la liste des employés sans la colonne PASSWORD
GRANT SELECT ON EMPLOYES TO victoria;
CREATE VIEW EMPLOYES_VIEW AS SELECT id, name FROM EMPLOYES;
REVOKE SELECT ON EMPLOYES FROM victoria;
GRANT SELECT ON EMPLOYES_VIEW TO victoria;

-- Lister tous les départements sans INSERT ni UPDATE
GRANT SELECT ON DEPARTMENTS TO victoria;
REVOKE INSERT, UPDATE ON DEPARTMENTS FROM victoria;

-- Lister et insérer dans la table TACHES, sans UPDATE ni DELETE
GRANT SELECT, INSERT ON TACHES TO victoria;
REVOKE UPDATE, DELETE ON TACHES FROM victoria;
```

### 3. Vérifier les Privilèges

Connectez-vous en tant qu'utilisateur Victoria pour vérifier que les privilèges sont correctement configurés :

```sql
-- Pour vérifier l'accès aux tables
SHOW TABLES;

-- Pour vérifier l'accès aux vues
SELECT * FROM EMPLOYES_VIEW;

-- Pour vérifier les privilèges
SHOW GRANTS FOR 'victoria'@'%';
```

### 4. Bonus : Automatisation avec AWS IAM et RDS

Pour une gestion plus avancée des utilisateurs et des privilèges, envisagez d'utiliser AWS IAM pour gérer les accès à votre instance RDS et les rôles associés.

### Conclusion
Ce tutoriel vous guide à travers la création et la gestion des privilèges d'utilisateur dans une base de données AWS, en utilisant des requêtes SQL pour créer des tables, configurer des utilisateurs, et attribuer des privilèges spécifiques. 