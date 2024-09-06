# Tutoriel: Surveillance des Performances du Serveur avec Python et Cron

Ce tutoriel explique comment mettre en place un système de surveillance des performances du serveur en utilisant Python et Cron. Le script Python envoie un email avec les détails des performances du serveur à un administrateur système toutes les minutes.

## Pré-requis

- Un serveur avec une distribution Linux (par exemple, Amazon Linux)
- Un accès root ou sudo
- Une adresse email pour envoyer les rapports

## Étape 1: Installation de Python et des Modules Nécessaires

Créez un script `installation_python.sh` pour installer Python et les modules nécessaires.

```bash
#/bin/bash
# Vérifier si Python est installé
python3 --version

# Si Python n'est pas installé, mettre à jour les paquets et installer Python
sudo yum update
sudo yum install python3

# Installation des modules nécessaires
sudo yum install python3-pip
pip3 install smtplib
pip3 install email
```

**Explications:**

- `python3 --version`: Vérifie si Python 3 est déjà installé.
- `sudo yum update`: Met à jour la liste des paquets.
- `sudo yum install python3`: Installe Python 3.
- `sudo yum install python3-pip`: Installe pip pour Python 3.
- `pip3 install smtplib`: Installe le module smtplib.
- `pip3 install email`: Installe le module email.

## Étape 2: Création du Script Python

Créez un script `creation_script_py.sh` pour créer le répertoire et le fichier Python nécessaires.

```bash
#/bin/bash

# Création du répertoire pour le script Python
mkdir lab8_Sys_Admin_Mailing

# Aller dans le répertoire créé
cd lab8_Sys_Admin_Mailing

# Création du fichier sysmail.py
sudo touch sysmail.py

# Donner les permissions d'exécution au fichier
chmod +x sysmail.py
```

**Explications:**

- `mkdir lab8_Sys_Admin_Mailing`: Crée un répertoire pour le script.
- `cd lab8_Sys_Admin_Mailing`: Change le répertoire actuel pour le nouveau répertoire.
- `sudo touch sysmail.py`: Crée un fichier vide nommé `sysmail.py`.
- `chmod +x sysmail.py`: Donne les permissions d'exécution au fichier `sysmail.py`.

## Étape 3: Configuration de Cron

Créez un script `lancement_crontab.sh` pour configurer le daemon cron.

```bash
#/bin/bash

# Vérification de l'exécution du cron daemon
sudo systemctl status cron

# Démarrer cron si ce n'est pas encore le cas
sudo systemctl start cron

# Activer cron au démarrage du système
sudo systemctl enable cron
```

**Explications:**

- `sudo systemctl status cron`: Vérifie si le daemon cron est en cours d'exécution.
- `sudo systemctl start cron`: Démarre le daemon cron s'il n'est pas déjà en cours d'exécution.
- `sudo systemctl enable cron`: Configure cron pour démarrer automatiquement au démarrage du système.

## Étape 4: Script Python pour la Surveillance des Performances

Créez un fichier `sysmail.py` avec le contenu suivant:

```python
import smtplib
import subprocess
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

def get_system_performance():
    memory_usage = subprocess.check_output(['free', '-m']).decode('utf-8')
    cpu_usage = subprocess.check_output(['top', '-b', '-n1']).decode('utf-8').split('\n')[2]
    disk_usage = subprocess.check_output(['df', '-h']).decode('utf-8')
    return memory_usage, cpu_usage, disk_usage

def send_email(subject, body, to_email):
    from_email = "ton_email@gmail.com"
    password = "mot_de_passe_email"

    message = MIMEMultipart()
    message['From'] = from_email
    message['To'] = to_email
    message['Subject'] = subject
    message.attach(MIMEText(body, 'plain'))

    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login(from_email, password)
    server.sendmail(from_email, to_email, message.as_string())
    server.quit()

if __name__ == "__main__":
    memory, cpu, disk = get_system_performance()
    performance_report = f"Performancne Mémoire : \n{memory}\n\n CPU Usage : \n{cpu} %\n\n Disk Usage : \n{disk}"
    send_email("Server Performance Report Rapport de performance du Server (CPU)", performance_report, "destinataire@example.com")
```

**Explications:**

- `import smtplib, subprocess, MIMEMultipart, MIMEText`: Importation des modules nécessaires.
- `get_system_performance()`: Fonction pour obtenir l'utilisation de la mémoire, du CPU et du disque.
- `send_email(subject, body, to_email)`: Fonction pour envoyer un email avec les informations de performance du système.
- `if __name__ == "__main__":`: Partie principale du script pour exécuter les fonctions et envoyer l'email.

## Étape 5: Configuration de Cron pour Exécuter le Script

Ajoutez une tâche cron pour exécuter le script toutes les minutes.

Exécutez `crontab -e` et ajoutez la ligne suivante:

```
* * * * * /usr/bin/python3 /path/to/your_script.py
```

**Explications:**

- `* * * * *`: Configure cron pour exécuter la tâche chaque minute.
- `/usr/bin/python3 /path/to/your_script.py`: Spécifie le chemin vers l'interpréteur Python et le script à exécuter.

## Conclusion

En suivant ce tutoriel, vous aurez mis en place un système de surveillance des performances du serveur qui envoie des rapports par email à un administrateur système toutes les minutes. Ce système utilise des scripts shell pour l'installation et la configuration, un script Python pour la collecte et l'envoi des données, et cron pour l'automatisation de l'exécution du script.