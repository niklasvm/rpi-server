#!/bin/bash

sudo docker stop rpi;
sudo docker rm rpi;
sudo docker run -ti -d --name rpi rpi_docker;
sudo docker exec -ti rpi bash;
