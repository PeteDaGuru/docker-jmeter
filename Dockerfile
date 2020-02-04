# inspired by https://github.com/hauptmedia/docker-jmeter
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile
# forked from https://github.com/justb4/docker-jmeter (MAINTAINER Just van den Broecke<just@justobjects.nl>)
FROM alpine:3.11

MAINTAINER PeteDaGuru<PeteDaGuru@gmail.com>

ARG JMETER_VERSION="5.1.1"
ENV JMETER_VERSION=${JMETER_VERSION}
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

# Install extra packages
# See https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-272703023
# PPD: added fontconfig and ttf-dejavu so jmeter GUI will work
ARG TZ="America/New_York"
RUN    apk update \
	&& apk upgrade \
	&& apk add --update ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --update fontconfig ttf-dejavu \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

# TODO: plugins (later)
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR	${JMETER_HOME}

ENTRYPOINT ["/entrypoint.sh"]
