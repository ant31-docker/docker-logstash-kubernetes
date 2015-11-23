#!/usr/bin/bash

: ${LS_HOME:=/var/lib/logstash}
: ${HOME:=${LS_HOME}}
: ${LS_HEAP_SIZE:=500m}
: ${LS_JAVA_OPTS:=-Djava.io.tmpdir=${LS_HOME}}
: ${LS_LOG_DIR:=/var/log/logstash}
: ${LOG_GROUP_NAME:=logstash}
: ${LOG_STREAM_NAME:=$(hostname)}

ulimit -n ${LS_OPEN_FILES} > /dev/null
cd ${LS_HOME}

/opt/logstash/bin/logstash -f /etc/logstash/conf.d ${LOG_OPTS}
