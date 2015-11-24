FROM logstash:1.5

ENV PATH=${PATH}:/opt/logstash/bin

RUN /opt/logstash/bin/plugin install logstash-filter-kubernetes
RUN /opt/logstash/bin/plugin install logstash-input-journald


COPY conf.d/ /etc/logstash/conf.d/

COPY run.sh /run.sh

CMD ["/run.sh"]
