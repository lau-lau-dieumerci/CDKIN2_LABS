#!/bin/bash
#!/bin/bash

MAX_SIZE=2048  # Taille maximale en byte (octect)

# Vérifie la taille du fichier log.txt
FILE_SIZE=$(du -b "$LOG_FILE_NODE" | cut -f1)

# cron du serveur node js
LOG_FILE_NODE="/home/lau/my_site/log.txt"
BACKUP_FILE_NODE="/home/lau/my_site/log_backup.txt"
# Vérifie la taille du fichier log.txt
FILE_SIZE_NODE=$(du -b "$LOG_FILE_NODE" | cut -f1)

if [ "$FILE_SIZE_NODE" -gt "$MAX_SIZE" ]; then
    # Copie le contenu dans le fichier log_backup.txt
    cat "$LOG_FILE_NODE" >> "$BACKUP_FILE_NODE"

    # Nettoie le fichier log.txt
    > "$LOG_FILE_NODE"

    echo "Rotation des journaux effectuée sur node js."
else
    echo "Pas besoin de rotation des journaux sur node js."
fi



# cron du serveur apache avec php
# Pour index.php
LOG_FILE_PHP="/var/www/html/my_site/log_index.txt"
BACKUP_FILE_PHP="/var/www/html/my_site/log_backup.txt"
# Vérifie la taille du fichier log.txt
FILE_SIZE_PHP=$(du -b "$LOG_FILE_PHP" | cut -f1)
if [ "$FILE_SIZE_PHP" -gt "$MAX_SIZE" ]; then
    # Copie le contenu dans le fichier log_backup.txt
    cat "$LOG_FILE_PHP" >> "$BACKUP_FILE_PHP"

    # Nettoie le fichier log.txt
    > "$LOG_FILE_PHP"

    echo "Rotation des journaux effectuée sur php."
else
    echo "Pas besoin de rotation des journaux sur php."
fi


# cron du serveur angular
LOG_FILE_ANGULAR="/home/lau/my_site_angular/log.txt"
BACKUP_FILE_ANGULAR="/home/lau/my_site_angular/log_backup.txt"
# Vérifie la taille du fichier log.txt
FILE_SIZE_ANGULAR=$(du -b "$LOG_FILE_ANGULAR" | cut -f1)
if [ "$FILE_SIZE_ANGULAR" -gt "$MAX_SIZE" ]; then
    # Copie le contenu dans le fichier log_backup.txt
    cat "$LOG_FILE_ANGULAR" >> "$BACKUP_FILE_ANGULAR"

    # Nettoie le fichier log.txt
    > "$LOG_FILE_ANGULAR"

    echo "Rotation des journaux effectuée sur angular."
else
    echo "Pas besoin de rotation des journaux sur angular."
fi

