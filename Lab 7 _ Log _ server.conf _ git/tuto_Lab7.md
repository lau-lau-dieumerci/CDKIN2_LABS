## Tutoriel : Mise en Place d'un Script de Surveillance et de Journalisation des Performances du CPU

### Introduction
Ce tutoriel explique comment créer un script qui surveille l'utilisation du CPU et journalise les données dans un fichier CSV (`performance_cpu.csv`) toutes les minutes à l'aide de cron. Avec, notamment,l'utilisation  de la commande `tail -f` pour lire les logs en temps réel.

### Création des Scripts et du Fichier de Log CSV

#### Script : `creation_csv_script.sh`
```bash
#!/bin/bash
cd /home/lau/cpuLab
sudo touch cpuLab.sh performance_cpu.csv
sudo chmod +x cpuLab.sh
sudo chmod +x performance_cpu.csv
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `cd /home/lau/cpuLab`
   - Change le répertoire de travail actuel pour `/home/lau/cpuLab`.

3. `sudo touch cpuLab.sh performance_cpu.csv`
   - Crée deux fichiers vides : `cpuLab.sh` et `performance_cpu.csv`. `touch` est utilisé pour créer des fichiers.

4. `sudo chmod +x cpuLab.sh`
   - Rend le fichier `cpuLab.sh` exécutable.

5. `sudo chmod +x performance_cpu.csv`
   - Rend le fichier `performance_cpu.csv` exécutable.

### Script de Surveillance des Performances du CPU

#### Script : `cpuLab.sh`
```bash
#!/bin/bash
# Obtenir l'utilisation actuelle du CPU en pourcentage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Enregistrer l'utilisation dans le fichier CSV
echo "Performance du CPU toutes les 2 secondes"
echo "Date : $(date '+%Y-%m-%d %H:%M:%S') / CPU : $cpu_usage %" >> /home/lau/cpuLab/performance_cpu.csv
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')`
   - Utilise `top` pour obtenir l'utilisation actuelle du CPU et `awk` pour extraire les pourcentages d'utilisation du CPU utilisateur et système, puis les additionne.

3. `echo "Performance du CPU toutes les 2 secondes"`
   - Affiche un message indiquant que les performances du CPU sont enregistrées toutes les 2 secondes.

4. `echo "Date : $(date '+%Y-%m-%d %H:%M:%S') / CPU : $cpu_usage %" >> /home/lau/cpuLab/performance_cpu.csv`
   - Ajoute la date et l'heure actuelles suivies de l'utilisation du CPU en pourcentage au fichier `performance_cpu.csv`.
   - `$(date '+%Y-%m-%d %H:%M:%S')` insère la date et l'heure actuelles dans le format spécifié.

### Configuration de la Crontab

#### Fichier : `crontab -e`
```bash
* * * * * /home/lau/cpuLab/cpuLab.sh
```

#### Explication des commandes :
1. `* * * * *`
   - Définit une tâche cron pour qu'elle s'exécute toutes les minutes.
   - Les cinq astérisques signifient que la tâche doit s'exécuter à chaque minute de chaque heure de chaque jour.

2. `/home/lau/cpuLab/cpuLab.sh`
   - Spécifie le chemin du script `cpuLab.sh` à exécuter.

### Lecture des Logs en Temps Réel

Pour lire les logs en temps réel, utilisez la commande suivante :
```bash
tail -f /home/lau/cpuLab/performance_cpu.csv
```

#### Explication des commandes :
1. `tail -f /home/lau/cpuLab/performance_cpu.csv`
   - Affiche les dernières lignes du fichier `performance_cpu.csv` et continue à afficher les nouvelles lignes à mesure qu'elles sont ajoutées.

### Conclusion

L'ensemble de ces scripts permet de créer un fichier de log CSV qui journalise les performances du CPU toutes les minutes. Le script `cpuLab.sh` ajoute l'utilisation actuelle du CPU à `performance_cpu.csv`, et la tâche cron configurée dans `crontab` s'assure que ce script est exécuté automatiquement chaque minute. 