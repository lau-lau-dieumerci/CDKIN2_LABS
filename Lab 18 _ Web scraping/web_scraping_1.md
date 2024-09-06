# Tutoriel GitHub : Web Scraping avec AWS

## Objectif

Créer un script de web scraping qui collecte des données, les stocke dans une base de données, et envoie un e-mail lorsque de nouvelles données sont ajoutées.

## Prérequis

- Compte AWS
- Accès à AWS Lambda, AWS RDS (ou DynamoDB), AWS SES (Simple Email Service) et AWS S3
- Connaissances de base en Python et en web scraping

## Étapes

### 1. Configurer la Base de Données

#### 1.1. Création d'une Base de Données RDS

1. Connectez-vous à la [console AWS](https://aws.amazon.com/console/).
2. Accédez au service **RDS**.
3. Cliquez sur **Create database**.
4. Choisissez **Standard Create**.
5. Sélectionnez le moteur de base de données (par exemple, MySQL ou PostgreSQL).
6. Configurez les paramètres de la base de données, y compris les identifiants de connexion et les paramètres de sécurité.
7. Cliquez sur **Create database**.

#### 1.2. Créer une Table pour Stocker les Données

- Connectez-vous à votre base de données via un client SQL (par exemple, MySQL Workbench ou pgAdmin).
- Créez une table pour stocker les données. Voici un exemple pour MySQL :

```sql
CREATE TABLE web_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. Développer le Script de Web Scraping

#### 2.1. Préparer l'Environnement

1. Créez un répertoire pour votre projet.
2. Installez les dépendances nécessaires :

```bash
pip install requests beautifulsoup4 sqlalchemy pymysql boto3
```

#### 2.2. Écrire le Script

Voici un exemple de script Python pour le web scraping et l'envoi d'e-mail :

```python
import requests
from bs4 import BeautifulSoup
import pymysql
from sqlalchemy import create_engine
import boto3
from botocore.exceptions import NoCredentialsError

# Configuration AWS SES
AWS_REGION = "us-east-1"
SENDER = "your-email@example.com"
RECIPIENT = "recipient@example.com"
SUBJECT = "New Data Available"
BODY_TEXT = "New data has been added to the database."

# Connexion à la base de données
DATABASE_HOST = 'your-database-host'
DATABASE_USER = 'your-database-user'
DATABASE_PASSWORD = 'your-database-password'
DATABASE_NAME = 'your-database-name'

engine = create_engine(f"mysql+pymysql://{DATABASE_USER}:{DATABASE_PASSWORD}@{DATABASE_HOST}/{DATABASE_NAME}")

def send_email(subject, body_text):
    client = boto3.client('ses', region_name=AWS_REGION)
    try:
        response = client.send_email(
            Source=SENDER,
            Destination={
                'ToAddresses': [RECIPIENT],
            },
            Message={
                'Subject': {
                    'Data': subject,
                },
                'Body': {
                    'Text': {
                        'Data': body_text,
                    },
                },
            },
        )
    except NoCredentialsError:
        print("Credentials not available")

def fetch_data():
    url = "http://example.com/data"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    data = soup.find('div', class_='data').text
    return data

def store_data(data):
    with engine.connect() as connection:
        result = connection.execute("SELECT * FROM web_data WHERE data = %s", (data,))
        if result.fetchone() is None:
            connection.execute("INSERT INTO web_data (data) VALUES (%s)", (data,))
            send_email(SUBJECT, BODY_TEXT)

def main():
    data = fetch_data()
    store_data(data)

if __name__ == "__main__":
    main()
```

### 3. Déployer le Script sur AWS Lambda

#### 3.1. Créer une Fonction Lambda

1. Accédez au service **Lambda** dans la console AWS.
2. Cliquez sur **Create function**.
3. Choisissez **Author from scratch**.
4. Configurez les détails de la fonction (nom, rôle IAM, etc.).
5. Téléchargez votre script Python dans un fichier ZIP.

#### 3.2. Configurer les Dépendances

- Assurez-vous que toutes les dépendances sont incluses dans le fichier ZIP ou utilisez un couche Lambda pour les inclure.

#### 3.3. Déployer et Tester

- Téléversez le fichier ZIP contenant le script et les dépendances.
- Configurez les variables d'environnement pour les informations de connexion à la base de données et AWS SES.
- Testez la fonction Lambda pour vous assurer qu'elle fonctionne correctement.

### 4. Automatiser l'Exécution

#### 4.1. Planifier la Fonction Lambda

1. Accédez à la section **Designer** de votre fonction Lambda.
2. Cliquez sur **Add trigger** et sélectionnez **EventBridge (CloudWatch Events)**.
3. Configurez une règle pour exécuter votre fonction à des intervalles réguliers (par exemple, toutes les heures).

