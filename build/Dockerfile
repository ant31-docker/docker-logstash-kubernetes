FROM logstash:5

ENV PATH=${PATH}:/opt/logstash/bin


RUN apt-get update && apt-get install apt-transport-https -y
RUN echo "deb https://packages.elastic.co/beats/apt stable main" | tee -a /etc/apt/sources.list.d/beats.list
RUN apt-get update && apt-get install filebeat -y

RUN /usr/share/logstash/bin/logstash-plugin install ant31-logstash-filter-kubernetes
# RUN /opt/logstash/bin/logstash-plugin install logstash-output-syslog
# RUN /opt/logstash/bin/plugin install logstash-input-beats

COPY conf.d/ /etc/logstash/conf.d/
