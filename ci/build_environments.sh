#! /bin/bash
docker build -t xitric/ca-project-test:latest environment/test/
docker build -t xitric/ca-project-zip:latest environment/artifact/
