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

# install shiny
RUN R -e "install.packages('shiny', repos='https://cran.rstudio.com/')";

# install tidyverse
RUN R -e "install.packages('tidyverse')";

# create shiny user
RUN useradd -r -m shiny && \
    usermod -aG sudo shiny

USER shiny

# install shiny-server
RUN cd && \
    git clone https://github.com/rstudio/shiny-server.git && \
    cd shiny-server && \
    mkdir tmp && \
    cd tmp && \
    DIR=`pwd` && \
    PATH=$DIR/../bin:$PATH && \
    PYTHON=`which python` && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DPYTHON="$PYTHON" ../ && \
    make && \
    mkdir ../build && \
    sed -i '8s/.*/NODE_SHA256=7a2bb6e37615fa45926ac0ad4e5ecda4a98e2956e468dedc337117bfbae0ac68/' ../external/node/install-node.sh && \
    sed -i 's/linux-x64.tar.xz/linux-armv7l.tar.xz/' ../external/node/install-node.sh && \
    (cd .. && ./external/node/install-node.sh) && \
    (cd .. && ./bin/npm --python="${PYTHON}" install --no-optional) && \
    (cd .. && ./bin/npm --python="${PYTHON}" rebuild)

USER root

RUN cd /home/shiny/shiny-server/tmp/ && \
    sudo make install

# shiny-server post-install
RUN ln -s /usr/local/shiny-server/bin/shiny-server /usr/bin/shiny-server && \
    sudo mkdir -p /var/log/shiny-server && \
    sudo mkdir -p /srv/shiny-server && \
    sudo mkdir -p /var/lib/shiny-server && \
    sudo chown shiny /var/log/shiny-server && \
    sudo mkdir -p /etc/shiny-server && \
    # configuration
    cd && \
    cp /home/shiny/shiny-server/config/default.config /etc/shiny-server/ && \
    cd /etc/shiny-server/ && \
    sudo cp default.config shiny-server.conf && \
    # example app
    sudo mkdir /srv/shiny-server/example && \
    sudo cp /home/shiny/shiny-server/samples/sample-apps/hello/ui.R /srv/shiny-server/example/ && \
    sudo cp /home/shiny/shiny-server/samples/sample-apps/hello/server.R /srv/shiny-server/example/

# clean up
RUN rm -R cmake-3.12.0-rc2 && \
    rm -R /home/shiny/shiny-server

# copy files
COPY init.d-shiny-server /etc/init.d/shiny-server
COPY ./start.sh /start.sh
RUN chmod 755 /start.sh


EXPOSE 3838

ENTRYPOINT ["/start.sh"]
