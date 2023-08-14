#!/bin/shell

WAIT_INTERVAL=5
SECONDS_WAITED=0

while ! nc -z $KAKFA_SERVER $KAFKA_PORT; do
    if [ $SECONDS_WAITED -ge $KAFKA_MAX_WAIT ]; then
        echo "ERROR INIT KAFKA SERVER IN $KAFKA_MAX_WAIT SECONDS."
        exit 1
    fi

    sleep $WAIT_INTERVAL
    SECONDS_WAITED=$((SECONDS_WAITED + $WAIT_INTERVAL))
done

echo "CREATE TOPICS"
if [ -n "$KAFKA_TEXT_TOPICS" ]; then
    echo "topics: $KAFKA_TEXT_TOPICS"
    OIFS=$IFS
    IFS=','
    list=$KAFKA_TEXT_TOPICS
    for topic in $list
    do
        echo "CREATE TOPIC -> $topic"
        COMMAND="${KAFKA_HOME}/bin/kafka-topics.sh --create --topic $topic --bootstrap-server 0.0.0.0:9092 --replication-factor 1 --partitions 1"
        echo "$COMMAND"
        OUTPUT=$(eval "$COMMAND")
        echo "EXEC: $COMMAND"
    done
    IFS=$OIFS
else
    echo "EMPTY TOPICS."
fi