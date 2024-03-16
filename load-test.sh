#!/bin/bash

trap "echo -e '\n\e[31mABORTED!\e[0m'" INT

echo -e "\e[32mLoad testing the CDN version of the application\e[0m"

output=$(wrk \
  --connections 10 \
  --threads 2 \
  --duration 2m \
  --script ./src/load-tests.lua \
  --latency \
  http://localhost:18080)

echo -e "\e[96m${output}\e[0m"