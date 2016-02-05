FROM logstash:1.5

ENV PATH=${PATH}:/opt/logstash/bin

RUN /opt/logstash/bin/plugin install logstash-filter-kubernetes
RUN /opt/logstash/bin/plugin install logstash-input-journald
RUN /opt/logstash/bin/plugin install logstash-output-syslog


COPY conf.d/ /etc/logstash/conf.d/
COPY outputs.d/ /root/outputs/

COPY run.sh /run.sh

CMD ["/run.sh"]
