#!/bin/bash

docker build -t item-app:v1 .
docker images
docker tag item-app:v1 ghcr.io/mashumabduljabbar/item-app:v1
echo $PAT | docker login ghcr.io -u mashumabduljabbar --password-stdin
docker push ghcr.io/mashumabduljabbar/item-app:v1