#!/bin/bash
echo $(date) >> /home/lau/my_site_angular/log.txt
node /home/lau/my_site_angular/index.js >> /home/lau/my_site_angular/log.txt 2>&1

