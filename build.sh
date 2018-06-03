#!/usr/bin/env bash

echo "Build and upload Docker image ..."
docker build -t sdia/abento:latest  .
# docker run -d -p 8000:8000 sdia/abento:latest
docker push sdia/abento:latest

echo "Updating Kubernetes ..."
kubectl delete -f ./deployment.yaml
kubectl create -f ./deployment.yaml
