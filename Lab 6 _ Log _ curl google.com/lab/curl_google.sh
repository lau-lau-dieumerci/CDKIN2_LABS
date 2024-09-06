#!/bin/bash
LOG_FILE="/home/lau/lab/curl_google.log"  # Chemin vers le fichier de journal
# Exécute la  requête curl vers google.com
curl -s -o /dev/null -w "%{http_code}" "https://www.google.com" >> "$LOG_FILE"
