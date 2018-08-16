#!/bin/ash
set -e

if [ -n "${SYSLOG_GET_EC2_HOSTNAME+set}" ]; then
  echo 'here1'
  INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
else
  echo 'here2'
  INSTANCE_ID=no-hostname
fi

# when no arguments are passed set options from environment
# otherwise append all arguments to the remote_syslog command
if [[ -z ${1} ]]; then
  echo 'here3'
  echo $SYSLOG_FILES
  echo $SYSLOG_HOSTNAME
  echo $SYSLOG_HOST
  echo $INSTANCE_ID
  echo $SYSLOG_PORT
  
  exec /remote_syslog/remote_syslog -D --dest-host=${SYSLOG_HOST} --dest-port=${SYSLOG_PORT:-514} \
  	--tcp=${SYSLOG_TCP:-false} --tls=${SYSLOG_TLS:-false} --facility=${SYSLOG_FACILITY:-user} \
  	--severity=${SYSLOG_SEVERITY:-notice} --hostname=${SYSLOG_HOSTNAME}-${INSTANCE_ID} ${SYSLOG_FILES}
else
  echo 'here4'
  exec /remote_syslog/remote_syslog -D $@
fi
