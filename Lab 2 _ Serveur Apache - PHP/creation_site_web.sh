#!/bin/bash
cd /var/www/html/
sudo mkdir my_site
cd my_site
sudo touch index.php log.txt log_backup.txt log_server_php.sh help.php
sudo chmod +x index.php
sudo chmod +x help.php
sudo chmod +x log.txt
sudo chmod +x log_backup.txt
sudo chmod +x log_server_php.sh