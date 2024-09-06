#!/bin/bash
sudo yum update
sudo yum install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
