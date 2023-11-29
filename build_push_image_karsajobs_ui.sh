#!/bin/bash

# Set username Docker Hub & Login
export USERNAME="mashumabduljabbar"
echo $PAT | docker login -u $USERNAME --password-stdin

# Set Image Name
export IMAGE_FRONTEND="karsajobs-ui:latest"

# Nama repo untuk backend
export REPO_FRONTEND="ghcr.io/$USERNAME/$IMAGE_FRONTEND"

# Build Docker image untuk backend
docker build -t $IMAGE_FRONTEND -f Dockerfile .

# Cek Docker
docker images

# Tag Local Image dengan Docker Registry
docker tag $IMAGE_FRONTEND $REPO_FRONTEND

# Push image ke Docker Hub
docker push $REPO_FRONTEND
