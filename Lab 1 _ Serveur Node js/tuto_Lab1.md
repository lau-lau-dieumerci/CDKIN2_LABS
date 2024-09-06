## Tutoriel : Installation et Configuration d'un Serveur Node.js avec Journalisation

### Introduction
Ce tutoriel fournit un processus d'installation de Node.js sur un serveur Linux et la création d'un site web avec un script de journalisation. Les scripts fournis permettront de configurer le serveur, de créer les fichiers nécessaires, et de lancer le serveur tout en enregistrant les journaux d'activité.

### Installation de Node.js

#### Script : `installation_serveur_nodejs.sh`
```bash
#!/bin/bash
sudo dnf install nodejs
node --version
curl -o- https://nodejs.org/dist/latest/node-v22.3.0-linux-x64.tar.xz | sudo tar -xJf - -C /usr/local --strip-components=1
node --version
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.
   
2. `sudo dnf install nodejs`
   - Utilise le gestionnaire de paquets `dnf` pour installer Node.js. `sudo` élève les privilèges pour permettre l'installation.

3. `node --version`
   - Vérifie l'installation de Node.js en affichant la version installée.

4. `curl -o- https://nodejs.org/dist/latest/node-v22.3.0-linux-x64.tar.xz | sudo tar -xJf - -C /usr/local --strip-components=1`
   - Télécharge la dernière version de Node.js depuis le site officiel.
   - Décompresse le fichier téléchargé directement dans le répertoire `/usr/local` pour l'installation. `--strip-components=1` supprime le premier niveau de répertoire de l'archive.

5. `node --version`
   - Vérifie à nouveau la version de Node.js pour s'assurer que la nouvelle version est installée correctement.

### Création du Site Web

#### Script : `creation_site_web.sh`
```bash
#!/bin/bash
sudo mkdir my_site
cd my_site
sudo touch index.js log.txt log_backup.txt log_server.sh
sudo chmod +x index.js
sudo chmod +x log.txt
sudo chmod +x log_backup.txt
sudo chmod +x log_server.sh
```

#### Explication des commandes :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.
   
2. `sudo mkdir my_site`
   - Crée un répertoire nommé `my_site` avec des privilèges élevés (`sudo`).

3. `cd my_site`
   - Change le répertoire de travail actuel pour `my_site`.

4. `sudo touch index.js log.txt log_backup.txt log_server.sh`
   - Crée quatre fichiers vides : `index.js`, `log.txt`, `log_backup.txt`, et `log_server.sh` avec des privilèges élevés.

5. `sudo chmod +x index.js`
   - Rend le fichier `index.js` exécutable.

6. `sudo chmod +x log.txt`
   - Rend le fichier `log.txt` exécutable.

7. `sudo chmod +x log_backup.txt`
   - Rend le fichier `log_backup.txt` exécutable.

8. `sudo chmod +x log_server.sh`
   - Rend le fichier `log_server.sh` exécutable.

### Script de Journalisation du Serveur

#### Script : `log_server.sh`
```bash
#!/bin/bash
node /home/lau/my_site/index.js >> /home/lau/my_site/log.txt 2>&1
```

#### Explication des commande :
1. `#!/bin/bash`
   - Indique que le script doit être exécuté avec Bash.
   
2. `node /home/lau/my_site/index.js >> /home/lau/my_site/log.txt 2>&1`
   - Lance le fichier `index.js` avec Node.js.
   - Redirige la sortie standard (`stdout`) et la sortie d'erreur (`stderr`) vers le fichier `log.txt`. `2>&1` signifie que la sortie d'erreur (`stderr`) est redirigée vers la sortie standard (`stdout`), qui est ensuite redirigée vers `log.txt`.

### Conclusion

L'ensemble de ces scripts permettent de mettre en place un serveur Node.js, de créer les fichiers nécessaires pour un site web, et de configurer un système de journalisation des activités du serveur. Vous pouvez maintenant adapter et développer votre site en ajoutant du code à `index.js` et en utilisant les fichiers de journalisation pour suivre les activités et les erreurs du serveur.