## Tutoriel : Mise en Place d'un Script de Journalisation pour les Requêtes Curl vers Google

### Introduction
Ce tutoriel explique comment créer un script qui journalise l'exécution d'une requête `curl` vers `google.com` dans un fichier `curl_google.log` toutes les minutes à l'aide de cron. Il permet de savoir également comment utiliser la commande `tail -f` pour lire les logs en temps réel.

### Création des Scripts et du Fichier de Log

#### Script : `creation_log_script.sh`
```bash
#!/bin/bash
cd /home/lau/lab
sudo touch curl_google.sh curl_google.log
sudo chmod +x curl_google.sh
sudo chmod +x curl_google.log
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `cd /home/lau/lab`
   - Change le répertoire de travail actuel pour `/home/lau/lab`.

3. `sudo touch curl_google.sh curl_google.log`
   - Crée deux fichiers vides : `curl_google.sh` et `curl_google.log`. `touch` est utilisé pour créer des fichiers.

4. `sudo chmod +x curl_google.sh`
   - Rend le fichier `curl_google.sh` exécutable.

5. `sudo chmod +x curl_google.log`
   - Rend le fichier `curl_google.log` exécutable.

### Script de Journalisation

#### Script : `curl_google.sh`
```bash
#!/bin/bash
LOG_FILE="/home/lau/lab/curl_google.log"  # Chemin vers le fichier de journal
# Exécute la requête curl vers google.com
curl -s -o /dev/null -w "%{http_code}" "https://www.google.com" >> "$LOG_FILE"
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `LOG_FILE="/home/lau/lab/curl_google.log"`
   - Définit le chemin vers le fichier de journal `curl_google.log`.

3. `curl -s -o /dev/null -w "%{http_code}" "https://www.google.com" >> "$LOG_FILE"`
   - Exécute une requête `curl` vers `https://www.google.com`.
   - `-s` rend `curl` silencieux (pas de sortie de progression).
   - `-o /dev/null` redirige la sortie du corps de la réponse vers `/dev/null`.
   - `-w "%{http_code}"` affiche le code de statut HTTP de la réponse.
   - `>> "$LOG_FILE"` ajoute le code de statut HTTP au fichier de journal.

### Configuration de la Crontab

#### Fichier : `crontab -e`
```bash
* * * * * /home/lau/lab/curl_google.sh
```

#### Explication des commandes :
1. `* * * * *`
   - Définit une tâche cron pour qu'elle s'exécute toutes les minutes.
   - Les cinq astérisques signifient que la tâche doit s'exécuter à chaque minute de chaque heure de chaque jour.

2. `/home/lau/lab/curl_google.sh`
   - Spécifie le chemin du script `curl_google.sh` à exécuter.

### Lecture des Logs en Temps Réel

Pour lire les logs en temps réel, utilisez la commande suivante :
```bash
tail -f /home/lau/lab/curl_google.log
```

#### Explication des commandes :
1. `tail -f /home/lau/lab/curl_google.log`
   - Affiche les dernières lignes du fichier `curl_google.log` et continue à afficher les nouvelles lignes à mesure qu'elles sont ajoutées.

### Conclusion

L'ensemble de ces scripts permet de créer un fichier de log qui journalise les résultats des requêtes `curl` vers `google.com` toutes les minutes. Le script `curl_google.sh` ajoute le code de statut HTTP à `curl_google.log`, et la tâche cron configurée dans `crontab` s'assure que ce script est exécuté automatiquement chaque minute.