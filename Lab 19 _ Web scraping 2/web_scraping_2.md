# Tutoriel GitHub : Web Scraping des Données sur l'Or avec AWS

## Objectif

Effectuer du web scraping sur des données susceptibles d'impacter la fluctuation du prix de l'or et envoyer un e-mail avec l'heure et la date de l'information obtenue.

## Prérequis

- Compte AWS
- Accès à AWS Lambda, AWS SES (Simple Email Service), et AWS CloudWatch
- Connaissances de base en Python et en web scraping

## Étapes

### 1. Configurer les Ressources AWS

#### 1.1. Configurer AWS SES pour l'Envoi d'E-mails

1. Connectez-vous à la [console AWS SES](https://console.aws.amazon.com/ses).
2. Configurez un domaine ou une adresse e-mail pour l'envoi d'e-mails. Suivez les [instructions d'Amazon SES](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/Welcome.html) pour vérifier votre domaine ou votre adresse e-mail.

#### 1.2. Créer une Fonction Lambda

1. Accédez à la [console AWS Lambda](https://console.aws.amazon.com/lambda).
2. Cliquez sur **Create function**.
3. Choisissez **Author from scratch**.
4. Configurez les détails de la fonction (nom, rôle IAM avec les permissions nécessaires pour SES et CloudWatch).
5. Créez la fonction Lambda.

### 2. Développer le Script de Web Scraping

#### 2.1. Préparer l'Environnement

1. Créez un répertoire pour votre projet.
2. Installez les dépendances nécessaires :

```bash
pip install requests beautifulsoup4 boto3
```

#### 2.2. Écrire le Script

Voici un exemple de script Python pour le web scraping et l'envoi d'e-mail avec AWS SES :

```python
import requests
from bs4 import BeautifulSoup
import boto3
from datetime import datetime
from botocore.exceptions import NoCredentialsError

# Configuration AWS SES
AWS_REGION = "us-east-1"
SENDER = "your-email@example.com"
RECIPIENT = "recipient@example.com"
SUBJECT = "Gold Price Data Alert"

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

def fetch_gold_data():
    url = "https://example.com/gold-price"  # Remplacez par une URL réelle
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    data = soup.find('div', class_='gold-price').text  # Adaptez en fonction de la structure de la page
    return data

def main():
    gold_data = fetch_gold_data()
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    email_body = f"Gold Price Data as of {current_time}:\n\n{gold_data}"
    send_email(SUBJECT, email_body)

if __name__ == "__main__":
    main()
```

### 3. Déployer le Script sur AWS Lambda

#### 3.1. Préparer le Package de Déploiement

1. Créez un fichier ZIP contenant votre script Python et toutes les dépendances.
   ```bash
   zip -r function.zip .
   ```

#### 3.2. Déployer le Script

1. Accédez à la [console AWS Lambda](https://console.aws.amazon.com/lambda).
2. Téléversez le fichier ZIP dans la section **Code** de votre fonction Lambda.
3. Configurez les variables d'environnement nécessaires (si besoin).

### 4. Automatiser l'Exécution

#### 4.1. Configurer une Règle CloudWatch pour Exécuter Lambda

1. Accédez à la [console AWS CloudWatch](https://console.aws.amazon.com/cloudwatch).
2. Cliquez sur **Rules** puis sur **Create rule**.
3. Configurez un événement planifié pour déclencher votre fonction Lambda à des intervalles réguliers (par exemple, toutes les heures).
4. Sélectionnez votre fonction Lambda comme cible et configurez les permissions nécessaires.