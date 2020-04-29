FROM ubuntu:18.04
COPY plyxchg.tar.gz /plyxchg.tar.gz
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openssl libssl1.0.0 libtinfo5
RUN tar -zxvf /plyxchg.tar.gz
ENTRYPOINT ["/plyxchg/bin/plyxchg", "start"]