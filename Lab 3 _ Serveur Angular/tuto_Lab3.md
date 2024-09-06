## Tutoriel : Installation et Configuration d'un Serveur Angular et Journalisation

### Introduction
Ce tutoriel guide à travers le processus d'installation d'un serveur Angular sur un système Linux, ainsi que la création et la configuration d'un site web avec journalisation des activités.

### Installation du Serveur Angular

#### Script : `installation_serveur_apache.sh`
```bash
#!/bin/bash
sudo yum install -y nodejs
sudo npm install -g @angular/cli
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `sudo yum install -y nodejs`
   - Installe Node.js en utilisant le gestionnaire de paquets `yum` avec l'option `-y` pour répondre automatiquement "yes" à toutes les invites.

3. `sudo npm install -g @angular/cli`
   - Installe Angular CLI globalement en utilisant npm (Node Package Manager). `-g` spécifie une installation globale, rendant Angular CLI disponible pour tous les utilisateurs du système.

### Création du Site Web

#### Script : `creation_site_web.sh`
```bash
#!/bin/bash
sudo mkdir my_site_angular
cd my_site_angular
sudo touch index.js log.txt log_backup.txt log_server_angular.sh home.html help.html
sudo chmod +x index.js
sudo chmod +x log.txt
sudo chmod +x log_backup.txt
sudo chmod +x log_server_angular.sh
sudo chmod +x home.html
sudo chmod +x help.html
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `sudo mkdir my_site_angular`
   - Crée un répertoire nommé `my_site_angular`.

3. `cd my_site_angular`
   - Change le répertoire de travail actuel pour `my_site_angular`.

4. `sudo touch index.js log.txt log_backup.txt log_server_angular.sh home.html help.html`
   - Crée six fichiers vides : `index.js`, `log.txt`, `log_backup.txt`, `log_server_angular.sh`, `home.html`, et `help.html`.

5. `sudo chmod +x index.js`
   - Rend le fichier `index.js` exécutable.

6. `sudo chmod +x log.txt`
   - Rend le fichier `log.txt` exécutable.

7. `sudo chmod +x log_backup.txt`
   - Rend le fichier `log_backup.txt` exécutable.

8. `sudo chmod +x log_server_angular.sh`
   - Rend le fichier `log_server_angular.sh` exécutable.

9. `sudo chmod +x home.html`
   - Rend le fichier `home.html` exécutable.

10. `sudo chmod +x help.html`
    - Rend le fichier `help.html` exécutable.

### Script de Journalisation du Serveur Angular

#### Script : `log_server_angular.sh`
```bash
#!/bin/bash
echo $(date) >> /home/lau/my_site_angular/log.txt
node /home/lau/my_site_angular/index.js >> /home/lau/my_site_angular/log.txt 2>&1
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.

2. `echo $(date) >> /home/lau/my_site_angular/log.txt`
   - Ajoute la date et l'heure actuelles au fichier `log.txt`.

3. `node /home/lau/my_site_angular/index.js >> /home/lau/my_site_angular/log.txt 2>&1`
   - Lance le fichier `index.js` avec Node.js.
   - Redirige la sortie standard (`stdout`) et la sortie d'erreur (`stderr`) vers le fichier `log.txt`. `2>&1` signifie que la sortie d'erreur (`stderr`) est redirigée vers la sortie standard (`stdout`), qui est ensuite redirigée vers `log.txt`.

### Conclusion

L'ensemble de ces scripts permet de mettre en place un serveur Angular avec Node.js, de créer les fichiers nécessaires pour un site web, et de configurer un système de journalisation des activités du serveur.