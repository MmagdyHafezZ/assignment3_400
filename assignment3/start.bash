#!/bin/bash

# URL to request
URL="http://$(minikube ip)/"

# Loop 10 times
for i in {1..10}
do
  echo "Request $i:"
  curl $URL
  echo -e "\n"
done