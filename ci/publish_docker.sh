#!/bin/bash

echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin
docker push "$DOCKERCREDS_USR/ca-project-python:1.0-${GIT_COMMIT::4}" 
docker push "$DOCKERCREDS_USR/ca-project-python:latest" &
wait
