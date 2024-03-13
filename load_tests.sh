#!/bin/bash

wrk -c20 -t4 -d600s -s ./src/load-tests.lua --latency http://localhost:18080
