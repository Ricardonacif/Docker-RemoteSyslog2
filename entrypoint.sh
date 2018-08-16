#!/bin/ash
set -e

if [[ -z "${SYSLOG_GET_EC2_HOSTNAME}" ]]; then
  INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
else
  INSTANCE_ID=no-hostname
fi

# when no arguments are passed set options from environment
# otherwise append all arguments to the remote_syslog command
if [[ -z ${1} ]]; then
  exec /remote_syslog/remote_syslog -D --dest-host=${SYSLOG_HOST} --dest-port=${SYSLOG_PORT:-514} \
  	--tcp=${SYSLOG_TCP:-false} --tls=${SYSLOG_TLS:-false} --facility=${SYSLOG_FACILITY:-user} \
  	--severity=${SYSLOG_SEVERITY:-notice} --hostname=${SYSLOG_HOSTNAME}-${INSTANCE_ID} ${SYSLOG_FILES}
else
  exec /remote_syslog/remote_syslog -D $@
fi
