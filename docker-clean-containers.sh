#!/bin/bash

docker ps --filter "status=exited" | awk '{if(NR>1)print}' | awk '{print $1}' | xargs --no-run-if-empty docker rm
