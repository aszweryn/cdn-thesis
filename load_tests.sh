#!/bin/bash

wrk -c10 -t2 -d600s -s ./src/load-tests.lua --latency http://localhost:8081
