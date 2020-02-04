#!/bin/bash

JMETER_VERSION="5.1.1"

# Example build line
# --build-arg IMAGE_TIMEZONE="America/New_York"
docker build  --build-arg JMETER_VERSION=${JMETER_VERSION} -t "petedaguru/docker-jmeter:${JMETER_VERSION}" .
