#!/bin/bash

echo "Restarting the CDN version of the application\n"

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

docker compose --file ./docker-compose-rr.yaml up