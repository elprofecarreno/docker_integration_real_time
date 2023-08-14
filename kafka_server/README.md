## KAFKA SERVER

Server Kafka image and configuration.

### Build Image

For builder image execute follow command.

```shell
docker build -t kafka-server .
```

### Create Container

For create container execute follow command.

```shell
$ docker run -d --name kafka-container kafka-server:latest
```