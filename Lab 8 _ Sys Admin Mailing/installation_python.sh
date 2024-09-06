#/bin/bash
#Vérifier si Python est installé
python3 --version

# Si python n'est pas installé
sudo yum update
sudo yum install python3

# Inatllation des modules nécessaires
sudo yum install python3-pip
pip3 install smtplib
pip3 install email

