# rpi-server
Repo to house scripts to build a docker container for the Raspberry Pi

As a start, the aim is to build a container that is running:
* R
* Shiny Server
* RStudio Server

The container will run on a Raspberry Pi 3 on my local network.

The dockerfile contains the following steps:

1. Start with image **resin/raspberrypi3-debian:stretch**
1. Install the latest version of R
1. Install some build dependencies
1. Build and install cmake from source (this may not be necessary)
1. Install shiny R package
1. Install tidyverse R package
1. Create a shiny user
1. Install shiny-server (as the shiny user created above)
1. Make install shiny-server
1. Shiny-server post-install
1. Copies a working init.d file and start script
1. exposes port 3838

Further plans:

* Remove cmake build
* Install rstudio-server
