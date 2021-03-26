# KAFKA Tools Exporter

## Intro

Simple kafka tools prometheus exporter 

## Build

```
docker build -t unicred/kafka-tools-exporter .
```

## Run

```
docker run -it --rm -p 9100:9100 \
   --dns 10.64.0.8 \
   -e KAFKA_SERVERS=10.64.14.84:9092,10.64.14.85:9092,10.64.14.86:9092 \
   unicred/kafka-tools-exporter
```

## Maintenance

Arquitetura
- Juan Enciso
