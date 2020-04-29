FROM ubuntu:latest
COPY plyxchg.tar.gz /plyxchg.tar.gz
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openssl libssl1.1 libtinfo5
RUN tar -zxvf /plyxchg.tar.gz
ENTRYPOINT ["/plyxchg/bin/plyxchg", "start"]