## Tutoriel : Installation et Configuration d'un Serveur Apache avec PHP et Journalisation

### Introduction
Ce tutoriel fournit le processus d'installation d'un serveur Apache sur un système Linux, ainsi que la création et la configuration d'un site web en PHP avec journalisation des activités.

### Installation du Serveur Apache

#### Script : `installation_serveur_apache.sh`
```bash
#!/bin/bash
sudo yum update
sudo yum install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `sudo yum update`
   - Met à jour tous les paquets installés à leur dernière version disponible. `sudo` élève les privilèges pour permettre cette action.

3. `sudo yum install httpd`
   - Installe le serveur HTTP Apache en utilisant le gestionnaire de paquets `yum`.

4. `sudo systemctl start httpd`
   - Démarre le service Apache immédiatement.

5. `sudo systemctl enable httpd`
   - Configure Apache pour démarrer automatiquement au démarrage du système.

### Création du Site Web

#### Script : `creation_site_web.sh`
```bash
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
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `sudo cd /var/www/html/`
   - Change le répertoire de travail actuel pour le répertoire racine des sites web d'Apache.

3. `sudo mkdir my_site`
   - Crée un répertoire nommé `my_site` dans le répertoire `/var/www/html/`.

4. `cd my_site`
   - Change le répertoire de travail actuel pour `my_site`.

5. `sudo touch index.php log.txt log_backup.txt log_server_php.sh help.php`
   - Crée cinq fichiers vides : `index.php`, `log.txt`, `log_backup.txt`, `log_server_php.sh`, et `help.php`.

6. `sudo chmod +x index.php`
   - Rend le fichier `index.php` exécutable.

7. `sudo chmod +x help.php`
   - Rend le fichier `help.php` exécutable.

8. `sudo chmod +x log.txt`
   - Rend le fichier `log.txt` exécutable.

9. `sudo chmod +x log_backup.txt`
   - Rend le fichier `log_backup.txt` exécutable.

10. `sudo chmod +x log_server_php.sh`
    - Rend le fichier `log_server_php.sh` exécutable.

### Script de Journalisation du Serveur PHP

#### Script : `log_server_php.sh`
```bash
#!/bin/bash
php /var/www/html/my_site/index.php >> /var/www/html/my_site/log.txt
php /var/www/html/my_site/help.php 2>> /var/www/html/my_site/log.txt
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `php /var/www/html/my_site/index.php >> /var/www/html/my_site/log.txt`
   - Exécute le fichier `index.php` avec PHP.
   - Redirige la sortie standard (`stdout`) vers le fichier `log.txt`.

3. `php /var/www/html/my_site/help.php 2>> /var/www/html/my_site/log.txt`
   - Exécute le fichier `help.php` avec PHP.
   - Redirige la sortie d'erreur (`stderr`) vers le fichier `log.txt`.

### Conclusion

L'ensemble de ces scripts permet de mettre en place un serveur Apache avec PHP, de créer les fichiers nécessaires pour un site web, et de configurer un système de journalisation des activités du serveur.