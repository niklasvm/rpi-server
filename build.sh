#!/bin/bash

sudo docker stop rpi;
sudo docker rm rpi;
sudo docker build -t rpi_docker .;
