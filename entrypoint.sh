#!/bin/bash
# Inspired from https://github.com/hhcordero/docker-jmeter-client
# Basically runs jmeter, assuming the PATH is set to point to JMeter bin-dir (see Dockerfile)
#
# This script expects the standdard JMeter command parameters.
#
set -e
if [ -z "${JVM_ARGS}"] ; then
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"
fi

if [ $# -ne 0 ] ; then
echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
if [ "$1" == "--gui" ] ; then
  shift
fi
echo "jmeter args=$@"
# Keep entrypoint simple: we must pass the standard JMeter arguments
jmeter $@
echo "END Running Jmeter on `date`"
else
echo "Alpine Linux $(cat /etc/alpine-release) with Jmeter ${JMETER_VERSION}"
sh
fi

#     -n \
#    -t "/tests/${TEST_DIR}/${TEST_PLAN}.jmx" \
#    -l "/tests/${TEST_DIR}/${TEST_PLAN}.jtl"
# exec tail -f jmeter.log
#    -D "java.rmi.server.hostname=${IP}" \
#    -D "client.rmi.localport=${RMI_PORT}" \
#  -R $REMOTE_HOSTS
