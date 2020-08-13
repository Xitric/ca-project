#! /bin/bash
docker build -t xitric/ca-project-test:latest environment/test/Dockerfile
docker build -t xitric/ca-project-zip:latest environment/artifact/Dockerfile
