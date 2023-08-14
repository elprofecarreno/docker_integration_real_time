#!/bin/shell

echo "CONFIG BROKERS"
if [ -n "$KAFKA_ZOOKEEPER_CONNECT" ]; then
    echo "KAFKA_ZOOKEEPER_CONNECT=$KAFKA_ZOOKEEPER_CONNECT"
    echo "UPDATE server.properties"
    sed -i "s/zookeeper.connect=localhost:2181/#zookeeper.connect=localhost:2181/" /${APP_FOLDER}/${APP_NAME}_${SCALA_VERSION}-${KAFKA_VERSION}/config/server.properties
    echo "zookeeper.connect=$KAFKA_ZOOKEEPER_CONNECT" >> /${APP_FOLDER}/${APP_NAME}_${SCALA_VERSION}-${KAFKA_VERSION}/config/server.properties
else
    echo "KAFKA_ZOOKEEPER_CONNECT NOT DEFINED. [Using Default Configuration]"
fi

sh ${KAFKA_HOME}/bin/zookeeper-server-start.sh ${KAFKA_HOME}/config/zookeeper.properties &

WAIT_INTERVAL=5
SECONDS_WAITED=0

echo "STARTING ZOOKEEPER"

while ! nc -z $KAFKA_ZOOKEEPER_HOST $KAFKA_ZOOKEPER_PORT; do
    if [ $SECONDS_WAITED -ge $KAFKA_ZOOKEPER_MAX_WAIT ]; then
        echo "ERROR INIT ZOOKEPER IN $KAFKA_ZOOKEPER_MAX_WAIT SECONDS."
        exit 1
    fi

    sleep $WAIT_INTERVAL
    SECONDS_WAITED=$((SECONDS_WAITED + $WAIT_INTERVAL))
done

sh /${APP_FOLDER}/createtopics.sh &

echo "STARTING KAFKA"

sh ${KAFKA_HOME}/bin/kafka-server-start.sh ${KAFKA_HOME}/config/server.properties




