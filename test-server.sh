#!/bin/bash

# Start the server in the background
/run-server.sh "$@" &

sleep 5s

/usr/local/bin/goss -g /goss.yaml validate -f documentation

exit $?