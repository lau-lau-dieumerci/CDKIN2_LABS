## Tutoriel : Mise en Place de la Journalisation et de la Rotation des Journaux pour les Serveurs Node.js, Apache et Angular

### Introduction
Ce tutoriel explique comment mettre en place la journalisation et la rotation des journaux pour les serveurs Node.js, Apache avec PHP, et Angular. Les scripts permettent de vérifier la taille des fichiers de log, de sauvegarder leur contenu dans des fichiers de backup, et de vider les fichiers de log lorsqu'ils atteignent une taille spécifiée (2ko).

### Script de Journalisation et de Rotation des Journaux

#### Script : `journalisation_backup.sh`
```bash
#!/bin/bash

MAX_SIZE=2048  # Taille maximale en bytes (octets)

# Chemins des fichiers de log pour Node.js
LOG_FILE_NODE="/home/lau/my_site/log.txt"
BACKUP_FILE_NODE="/home/lau/my_site/log_backup.txt"

# Vérifie la taille du fichier log.txt pour Node.js
FILE_SIZE_NODE=$(du -b "$LOG_FILE_NODE" | cut -f1)
if [ "$FILE_SIZE_NODE" -gt "$MAX_SIZE" ]; then
    # Copie le contenu dans le fichier log_backup.txt
    cat "$LOG_FILE_NODE" >> "$BACKUP_FILE_NODE"
    # Nettoie le fichier log.txt
    > "$LOG_FILE_NODE"
    echo "Rotation des journaux effectuée sur Node.js."
else
    echo "Pas besoin de rotation des journaux sur Node.js."
fi

# Chemins des fichiers de log pour Apache avec PHP
LOG_FILE_PHP="/var/www/html/my_site/log_index.txt"
BACKUP_FILE_PHP="/var/www/html/my_site/log_backup.txt"

# Vérifie la taille du fichier log.txt pour Apache avec PHP
FILE_SIZE_PHP=$(du -b "$LOG_FILE_PHP" | cut -f1)
if [ "$FILE_SIZE_PHP" -gt "$MAX_SIZE" ]; then
    # Copie le contenu dans le fichier log_backup.txt
    cat "$LOG_FILE_PHP" >> "$BACKUP_FILE_PHP"
    # Nettoie le fichier log.txt
    > "$LOG_FILE_PHP"
    echo "Rotation des journaux effectuée sur PHP."
else
    echo "Pas besoin de rotation des journaux sur PHP."
fi

# Chemins des fichiers de log pour Angular
LOG_FILE_ANGULAR="/home/lau/my_site_angular/log.txt"
BACKUP_FILE_ANGULAR="/home/lau/my_site_angular/log_backup.txt"

# Vérifie la taille du fichier log.txt pour Angular
FILE_SIZE_ANGULAR=$(du -b "$LOG_FILE_ANGULAR" | cut -f1)
if [ "$FILE_SIZE_ANGULAR" -gt "$MAX_SIZE" ]; then
    # Copie le contenu dans le fichier log_backup.txt
    cat "$LOG_FILE_ANGULAR" >> "$BACKUP_FILE_ANGULAR"
    # Nettoie le fichier log.txt
    > "$LOG_FILE_ANGULAR"
    echo "Rotation des journaux effectuée sur Angular."
else
    echo "Pas besoin de rotation des journaux sur Angular."
fi
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `MAX_SIZE=2048`
   - Définit la taille maximale des fichiers de log à 2048 octets (2 Ko).

3. `LOG_FILE_NODE="/home/lau/my_site/log.txt"`
   - Spécifie le chemin du fichier de log pour le serveur Node.js.

4. `BACKUP_FILE_NODE="/home/lau/my_site/log_backup.txt"`
   - Spécifie le chemin du fichier de backup pour le serveur Node.js.

5. `FILE_SIZE_NODE=$(du -b "$LOG_FILE_NODE" | cut -f1)`
   - Vérifie la taille du fichier de log pour Node.js et stocke la taille dans `FILE_SIZE_NODE`.

6. `if [ "$FILE_SIZE_NODE" -gt "$MAX_SIZE" ]; then`
   - Si la taille du fichier de log dépasse la taille maximale définie, exécute les commandes suivantes.

7. `cat "$LOG_FILE_NODE" >> "$BACKUP_FILE_NODE"`
   - Copie le contenu du fichier de log dans le fichier de backup.

8. `> "$LOG_FILE_NODE"`
   - Vide le fichier de log.

9. `echo "Rotation des journaux effectuée sur Node.js."`
   - Affiche un message indiquant que la rotation des journaux a été effectuée.

10. `else`
    - Si la taille du fichier de log ne dépasse pas la taille maximale, exécute les commandes suivantes.

11. `echo "Pas besoin de rotation des journaux sur Node.js."`
    - Affiche un message indiquant que la rotation des journaux n'est pas nécessaire.

Les mêmes étapes sont répétées pour les serveurs Apache avec PHP et Angular, en remplaçant les chemins de fichiers appropriés.

### Configuration de la Crontab

#### Fichier : `crontab -e`
```bash
* * * * * sleep 5; /home/lau/journalisation_backup.sh
```

#### Explication des commandes :
1. `* * * * *`
   - Définit une tâche cron pour qu'elle s'exécute toutes les minutes.

2. `sleep 5;`
   - Ajoute un délai de 5 secondes avant d'exécuter le script.

3. `/home/lau/journalisation_backup.sh`
   - Spécifie le chemin du script de journalisation et de rotation des journaux à exécuter.

### Conclusion

L'ensemble de ces scripts permet de mettre en place un système de journalisation et de rotation des journaux pour les serveurs Node.js, Apache avec PHP, et Angular. Les fichiers de log sont sauvegardés dans des fichiers de backup lorsque leur taille atteint 2 Ko, et sont ensuite vidés pour permettre une journalisation continue sans risque de dépassement d'espace disque. Les tâches cron automatisent ce processus en vérifiant et en exécutant les rotations de journaux toutes les minutes.