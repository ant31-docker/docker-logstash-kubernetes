#!/bin/bash

: ${LS_HOME:=/var/lib/logstash}
: ${HOME:=${LS_HOME}}
: ${LS_HEAP_SIZE:=500m}
: ${LS_JAVA_OPTS:=-Djava.io.tmpdir=${LS_HOME}}
: ${LS_LOG_DIR:=/var/log/logstash}
: ${OUTPUT_CLOUDWATCH:=false}
: ${AWS_REGION:=eu-west-1}
: ${LOG_GROUP_NAME:=logstash}
: ${LOG_STREAM_NAME:=$(hostname)}
: ${OUTPUT_GELF:=false}
: ${GELF_HOST:=""}
: ${GELF_PORT:=12201}
: ${OUTPUT_RABBITMQ:=false}
: ${RABBITMQ_HOST:=localhost}
: ${EXCHANGE:=logging}
: ${EXCHANGE_TYPE:=fanout}
: ${RABBITMQ_KEY:=logging}
: ${RABBITMQ_USER:=user}
: ${RABBITMQ_PASSWORD:=password}

if [[ $OUTPUT_RABBITMQ == "true" ]]; then
   echo "<$(date)> - Enabling rabbitmq output"
   mv -f /root/outputs/30_output* /etc/logstash/conf.d/
   sed -e "s/%RABBITMQ_HOST%/${RABBITMQ_HOST}/" \
       -e "s/%EXCHANGE%/${EXCHANGE}/" \
       -e "s/%EXCHANGE_TYPE%/${EXCHANGE_TYPE}/" \
       -e "s/%RABBITMQ_KEY%/${RABBITMQ_KEY}/" \
       -e "s/%RABBITMQ_USER%/${RABBITMQ_USER}/" \
       -e "s/%RABBITMQ_PASSWORD%/${RABBITMQ_PASSWORD}/" \
       -i /etc/logstash/conf.d/30_output_kubernetes_rabbitmq.conf \
       -i /etc/logstash/conf.d/30_output_journald_rabbitmq.conf
fi

if [[ "$OUTPUT_GELF" == "true" ]]; then
   echo "<$(date)> - Enabling gelf output"
   mv -f /root/outputs/31_output* /etc/logstash/conf.d/
    sed -e "s/%GELF_HOST%/${GELF_HOST}/" \
        -e "s/%GELF_PORT%/${GELF_PORT}/" \
        -i /etc/logstash/conf.d/31_output_kubernetes_gelf.conf \
        -i /etc/logstash/conf.d/31_output_journald_gelf.conf
fi

if [[ "$OUTPUT_CLOUDWATCH" == "true" ]]; then
   echo "<$(date)> - Enabling cloudwatch output"
   mv -f /root/outputs/32_output* /etc/logstash/conf.d/
    sed -e "s/%AWS_REGION%/${AWS_REGION}/" \
        -e "s/%LOG_GROUP_NAME%/${LOG_GROUP_NAME}/" \
        -e "s/%LOG_STREAM_NAME%/${LOG_STREAM_NAME}/" \
        -i /etc/logstash/conf.d/32_output_kubernetes_cloudwatch.conf \
        -i /etc/logstash/conf.d/32_output_journald_cloudwatch.conf
fi

ulimit -n ${LS_OPEN_FILES} > /dev/null
cd ${LS_HOME}

/opt/logstash/bin/logstash -f /etc/logstash/conf.d ${LOG_OPTS}
