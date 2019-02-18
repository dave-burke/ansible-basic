#!/bin/bash

echo "Cleaning images..."
docker images -f dangling=true -q | xargs --no-run-if-empty docker rmi

echo "Cleaning volumes..."
docker volume ls -qf dangling=true | xargs --no-run-if-empty docker volume rm

