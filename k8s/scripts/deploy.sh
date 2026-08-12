#!/bin/bash
NAMESPACE=${1:-dev}
echo "Deploying to $NAMESPACE"

kubectl apply -f namespaces/
kubectl apply -k overlays/$NAMESPACE
