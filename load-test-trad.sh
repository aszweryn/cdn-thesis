#!/bin/bash

trap "rm --force output1.txt output2.txt" INT EXIT
trap "echo -e '\e[31mABORTED!\e[0m'" INT

echo -e "\e[32mLoad testingn the non-CDN version of the application\e[0m"

{
wrk \
  --connections 5 \
  --threads 2 \
  --duration 1s \
  --script ./src/load-tests.lua \
  --latency \
  http://localhost:8080 \
  >> b1.txt 2>&1
} &

{
wrk \
  --connections 5 \
  --threads 2 \
  --duration 1s \
  --script ./src/load-tests.lua \
  --latency \
  http://localhost:8081 \
  >> b2.txt 2>&1
} &

wait

[ -f b1.txt ] && echo -e "\e[33m$(cat b1.txt)\e[0m"
[ -f b2.txt ] && echo -e "\e[96m$(cat b2.txt)\e[0m"

rm --force b1.txt b2.txt