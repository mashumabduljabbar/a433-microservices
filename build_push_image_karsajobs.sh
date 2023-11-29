#!/bin/bash

# Set username Github Package & Login
export USERNAME="mashumabduljabbar"
echo $PAT | docker login ghcr.io -u  $USERNAME --password-stdin

# Set Image Name
export IMAGE_BACKEND="karsajobs:latest"

# Nama repo untuk backend
export REPO_BACKEND="ghcr.io/$USERNAME/$IMAGE_BACKEND"

# Build Docker image untuk backend
docker build -t $IMAGE_BACKEND -f Dockerfile .

# Cek Docker
docker images

# Tag Local Image dengan Docker Registry
docker tag $IMAGE_BACKEND $REPO_BACKEND

# Push image ke Docker Hub
docker push $REPO_BACKEND
