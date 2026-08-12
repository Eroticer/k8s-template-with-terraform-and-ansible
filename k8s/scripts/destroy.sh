#!/bin/bash
NAMESPACE=${1:-dev}
kubectl delete -k overlays/$NAMESPACE
