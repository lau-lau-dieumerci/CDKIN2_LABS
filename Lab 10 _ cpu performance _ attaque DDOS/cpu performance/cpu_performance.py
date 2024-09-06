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
