#!/bin/bash

docker build -t item-app:v1 .
docker images
docker tag item-app:v1 mashumjabbar/item-app:v1
echo $PASSWORD_DOCKER_HUB | docker login -u mashumjabbar --password-stdin
docker push mashumjabbar/item-app:v1