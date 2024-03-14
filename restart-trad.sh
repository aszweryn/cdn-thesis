#!/bin/bash

echo "Restarting the traditional version of the application\n"

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

docker compose --file ./docker-compose-trad.yaml up