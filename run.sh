#!/bin/bash

sudo docker stop rpi;
sudo docker rm rpi;
sudo docker run -ti -d --name rpi -p 3838:3838 rpi_docker;
sudo docker exec -ti rpi bash;
