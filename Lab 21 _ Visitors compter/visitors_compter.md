# Tutoriel GitHub : Compteur de Visiteurs sur un Site Web avec AWS

## Objectif

Implémenter un compteur de visiteurs pour un site web hébergé sur une instance EC2. Le compteur doit suivre le nombre de visiteurs uniques et l'afficher sur le site web.

## Prérequis

- Compte AWS
- Instance EC2 avec un serveur web (Apache, Nginx, etc.)
- Base de données RDS ou DynamoDB pour stocker les données du compteur
- Connaissances de base en PHP, Python, ou un autre langage de script côté serveur

## Étapes

### 1. Configurer la Base de Données

#### 1.1. Créer une Base de Données

Vous pouvez utiliser RDS (MySQL) ou DynamoDB pour stocker les données du compteur. Voici un exemple avec MySQL sur RDS.

1. Accédez à la [console RDS](https://console.aws.amazon.com/rds).
2. Créez une nouvelle instance de base de données MySQL.

#### 1.2. Créer une Table pour le Compteur

Connectez-vous à votre base de données RDS via un client SQL et créez une table pour stocker les visiteurs.

```sql
CREATE TABLE visitors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ip_address VARCHAR(45) NOT NULL UNIQUE,
    visit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. Développer le Script de Compteur de Visiteurs

#### 2.1. Préparer l'Environnement

Assurez-vous que vous avez les outils nécessaires sur votre instance EC2. Pour cet exemple, nous utiliserons PHP avec MySQL. Vous pouvez adapter le tutoriel à d'autres langages si nécessaire.

#### 2.2. Écrire le Script PHP

Créez un script PHP pour incrémenter le compteur à chaque visite et afficher le nombre total de visiteurs uniques.

```php
<?php
$servername = "your-rds-endpoint";
$username = "your-db-username";
$password = "your-db-password";
$dbname = "your-db-name";

// Créer une connexion
$conn = new mysqli($servername, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Obtenir l'adresse IP du visiteur
$ip_address = $_SERVER['REMOTE_ADDR'];

// Vérifier si l'adresse IP existe déjà dans la base de données
$sql = "SELECT * FROM visitors WHERE ip_address = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $ip_address);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows == 0) {
    // Si l'adresse IP n'existe pas, ajouter une nouvelle entrée
    $sql = "INSERT INTO visitors (ip_address) VALUES (?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $ip_address);
    $stmt->execute();
}

// Obtenir le nombre total de visiteurs uniques
$sql = "SELECT COUNT(*) as total_visitors FROM visitors";
$result = $conn->query($sql);
$row = $result->fetch_assoc();
$total_visitors = $row['total_visitors'];

// Afficher le nombre total de visiteurs uniques
echo "<p>Total visitors: $total_visitors</p>";

// Fermer la connexion
$conn->close();
?>
```

### 3. Déployer le Script sur votre Instance EC2

#### 3.1. Transférer le Script PHP

1. Connectez-vous à votre instance EC2 via SSH.
2. Transférez le script PHP dans le répertoire racine de votre serveur web, par exemple `/var/www/html`.

```bash
scp -i your-key.pem your-script.php ec2-user@your-ec2-public-dns:/var/www/html
```

#### 3.2. Configurer les Permissions

Assurez-vous que les permissions du fichier sont correctes pour qu'il soit accessible via le serveur web.

```bash
sudo chmod 644 /var/www/html/your-script.php
```

### 4. Configurer le Serveur Web

#### 4.1. Configurer Apache ou Nginx

Assurez-vous que votre serveur web (Apache ou Nginx) est configuré pour exécuter les fichiers PHP.

- **Pour Apache**, vous pouvez vérifier que le module PHP est activé.
- **Pour Nginx**, assurez-vous que PHP-FPM est correctement configuré.

### 5. Tester le Compteur

Accédez à votre site web en utilisant l'URL de votre instance EC2. Vous devriez voir le compteur de visiteurs affiché sur la page.

### Conclusion

Ce tutoriel guide la mise en place d'un compteur de visiteurs pour un site web hébergé sur une instance EC2 en utilisant une base de données RDS. Vous pouvez adapter le script à différents langages ou bases de données selon vos besoins. Assurez-vous de tester et de sécuriser votre solution avant de la déployer en production.