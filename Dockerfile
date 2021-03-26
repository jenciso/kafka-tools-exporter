FROM openjdk:8

ARG KAFKA_VERSION=2.3.0
ARG KAFKA_SCALA_VERSION=2.12

RUN curl -fsSL -o /tmp/kafka.tgz https://www-us.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && tar xfz /tmp/kafka.tgz -C /opt && rm -f /tmp/kafka.tgz

RUN curl -fsSL -o /tmp/node_exporter.tar.gz https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz \
    && tar xfz /tmp/node_exporter.tar.gz -C /tmp --wildcards "*/node_exporter"  \
    && mv /tmp/node_exporter-1.0.1.linux-amd64/node_exporter /usr/bin/node_exporter \
    && mkdir -p /opt/node_exporter/textfile_collector \
    && rm -rf /tmp/node_exporter*

RUN apt-get update \
   && apt-get install -y supervisor cron moreutils

COPY script.sh /usr/bin/script.sh
RUN chmod 755 /usr/bin/script.sh
COPY supervisord.conf /etc/supervisord.conf
COPY supervisord.d /etc/supervisord.d
COPY cron.d /etc/cron.d/

ENV KAFKA_SERVERS localhost:9092
ENV PATH="/opt/kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}/bin:${PATH}"

WORKDIR /opt/kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}
EXPOSE 9100

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
