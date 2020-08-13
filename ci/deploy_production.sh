#! /bin/bash

scp -o StrictHostKeyChecking=no ../docker-compose.yml ubuntu@35.195.148.16:/home/ubuntu/production
ssh -o StrictHostKeyChecking=no ubuntu@35.195.148.16 "cd /home/ubuntu/production && docker-compose up -d"
