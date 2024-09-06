## Tutoriel : Mise en Place d'un Script de Journalisation "Hello World"

### Introduction
Ce tutoriel explique comment créer un script simple qui journalise le message "Hello World" avec un horodatage dans un fichier `hello_world.log` toutes les minutes à l'aide de cron.

### Création des Scripts et du Fichier de Log

#### Script : `creation_log_script.sh`
```bash
#!/bin/bash
cd /home/lau/lab
sudo touch hello_world.sh hello_world.log
sudo chmod +x hello_world.sh
sudo chmod +x hello_world.log
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `cd /home/lau/lab`
   - Change le répertoire de travail actuel pour `/home/lau/lab`.

3. `sudo touch hello_world.sh hello_world.log`
   - Crée deux fichiers vides : `hello_world.sh` et `hello_world.log`. `touch` est utilisé pour créer des fichiers.

4. `sudo chmod +x hello_world.sh`
   - Rend le fichier `hello_world.sh` exécutable.

5. `sudo chmod +x hello_world.log`
   - Rend le fichier `hello_world.log` exécutable.

### Script de Journalisation

#### Script : `hello_world.sh`
```bash
#!/bin/bash
echo " $(date) Hello world" >> hello_world.log
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `echo " $(date) Hello world" >> hello_world.log`
   - Ajoute la date et l'heure actuelles suivies de "Hello World" dans le fichier `hello_world.log`.
   - `$(date)` insère la date et l'heure actuelles.
   - `>>` est utilisé pour ajouter du texte à la fin du fichier sans effacer le contenu existant.

### Configuration de la Crontab

#### Fichier : `crontab -e`
```bash
* * * * * /home/lau/lab/hello_world.sh
```

#### Explication des commandes :
1. `* * * * *`
   - Définit une tâche cron pour qu'elle s'exécute toutes les minutes.
   - Les cinq astérisques signifient que la tâche doit s'exécuter à chaque minute de chaque heure de chaque jour.

2. `/home/lau/lab/hello_world.sh`
   - Spécifie le chemin du script `hello_world.sh` à exécuter.

### Lecture des Logs en Temps Réel

Pour lire les logs en temps réel, utilisez la commande suivante :
```bash
tail -f /home/lau/lab/hello_world.log
```


### Conclusion

L'ensemble de ces scripts permet de créer un fichier de log qui journalise le message "Hello World" avec un horodatage toutes les minutes. Le script `hello_world.sh` ajoute l'entrée à `hello_world.log`, et la tâche cron configurée dans `crontab` s'assure que ce script est exécuté automatiquement chaque minute. Cela constitue un exemple simple de journalisation automatisée à l'aide de scripts Bash et de cron.