#!/bin/bash

trap "echo -e '\n\e[31mABORTED!\e[0m'" INT

echo -e "\e[32mLoad testing the CDN version of the application\e[0m"

output=$(wrk \
  --connections 10 \
  --threads 4 \
  --duration 1m \
  --script ./src/load-tests.lua \
  --latency \
  http://localhost:18080)

echo -e "\e[96m${output}\e[0m"

# Save the output to a file
filename="$(date +%m-%d-%H:%M).txt"
echo "${output}" > "$PWD/docs/load-tests/${filename}"