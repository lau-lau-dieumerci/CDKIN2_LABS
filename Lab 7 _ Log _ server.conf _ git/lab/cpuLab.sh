#!/bin/bash
# Boucle pour surveiller en continu
# Obtenir l'utilisation actuelle du CPU en pourcentage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Enregistrer l'utilisation dans le fichier CSV
echo "Performance du CPU toutes les 2 secondes"
echo "Date : $(date '+%Y-%m-%d %H:%M:%S') / CPU : $cpu_usage %" >> performance_cpu.csv