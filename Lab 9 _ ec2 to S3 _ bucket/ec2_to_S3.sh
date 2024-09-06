#!/bin/bash

# Dossier de travail
backup_dir="lab9_backup_S3"
archive_prefix="backup_archive"
bucket_name="myS3Bucket"

# Créer le dossier s'il n'existe pas
mkdir -p $backup_dir

# Créer 5 fichiers dans le dossier
for i in {1..5}; do
    echo "Contenu du fichier $i" > "$backup_dir/file$i.txt"
done

# Archiver les fichiers
archive_name_upload="${archive_prefix}_$(date +%Y%m%d%H%M%S).tar.gz"




# Envoyer l'archive dans le bucket S3
tar -czf "$backup_dir/$archive_name_upload" -C "$backup_dir" .
aws s3 cp "$backup_dir/$archive_name_upload" "s3://firstbackuplab9/lab9_ec2_to_S3/"

# Ajouter une tâche cron pour envoyer l'archive toutes les minutes
(crontab -l 2>/dev/null; echo "* * * * * /home/ec2-user/lab9_backupS3/backup_scipt.sh >> /home/ec2-user/lab9_backupS3/backup_log.log 2>&1") | crontab -

# Compteur pour arrêter après 4 backups
backup_counter_file="/home/ec2-user/lab9_backupS3/backup_counter.txt"
if [ ! -f $backup_counter_file ]; then
    echo 0 > $backup_counter_file
fi

backup_count=$(cat $backup_counter_file)
backup_count=$((backup_count + 1))

# Mettre à jour le compteur
echo $backup_count > $backup_counter_file

# Arrêter après 4 backups
if [ $backup_count -ge 4 ]; then
    crontab -l | grep -v "/home/ec2-user/lab9_backupS3/backup_script.sh" | crontab -
    rm $backup_counter_file
fi
