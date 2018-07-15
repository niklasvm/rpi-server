#!/bin/bash

# start shiny server
/etc/init.d/shiny-server start;

# keep container running
tail -f /dev/null
