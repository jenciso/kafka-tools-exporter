#!/bin/bash

# Print prometheus headers
echo "# HELP kafka_tools_topic_log_dir_size_bytes Disk space used by kafka topic"
echo "# TYPE kafka_tools_topic_log_dir_size_bytes gauge"

# Print metrics
for TOPIC in $(kafka-topics.sh --bootstrap-server $KAFKA_SERVERS --list)
do
   SIZE=$(kafka-log-dirs.sh --bootstrap-server $KAFKA_SERVERS --describe --topic-list $TOPIC |\
    grep -oP '(?<=size":)\d+' |\
    awk '{ sum += $1 } END { print sum }')
   echo "kafka_tools_topic_log_dir_size_bytes{topic=\"$TOPIC\"} $SIZE"
done
