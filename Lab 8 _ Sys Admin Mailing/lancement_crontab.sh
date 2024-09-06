#/bin/bash

# Vérification de l'exécution du cron daemon
sudo systemctl status cron

# Démarrer cron si ce n'est pas encor le cas
sudo systemctl start cron

# Activer cron au démarrage du système
sudo systemctl enable cron
