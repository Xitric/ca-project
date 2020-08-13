#! /bin/bash

scp -o StrictHostKeyChecking=no ../ca-project-test.tar ubuntu@34.76.76.30:/home/ubuntu/test/ca-project-test.tar
scp -o StrictHostKeyChecking=no ../docker-compose.yml ubuntu@34.76.76.30:/home/ubuntu/test
ssh -o StrictHostKeyChecking=no ubuntu@34.76.76.30 "cd /home/ubuntu/test && docker load -i ca-project-test.tar"
ssh -o StrictHostKeyChecking=no ubuntu@34.76.76.30 "cd /home/ubuntu/test && docker-compose up -d"
