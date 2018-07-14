FROM resin/raspberrypi3-debian:stretch

# Enable systemd
ENV INITSYSTEM on

# install latest R
RUN echo "deb http://cran.rstudio.com/bin/linux/debian stretch-cran35/" >> /etc/apt/sources.list; \
    apt install dirmngr; \
    apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'; \
    apt-get update && apt-get upgrade && apt-get install -y r-base r-base-dev


# install required programs
RUN apt-get install -y wget python gcc cpp git

# install cmake
RUN wget https://cmake.org/files/v3.12/cmake-3.12.0-rc2.tar.gz && \
    tar xzf cmake-3.12.0-rc2.tar.gz && \
    cd cmake-3.12.0-rc2 && \
    ./bootstrap && \
    make && \
    make install;

# install shiny-server
