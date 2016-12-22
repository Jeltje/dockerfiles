FROM ubuntu:14.04

MAINTAINER Jeltje van Baren, jeltje.van.baren@gmail.com

#Install Essentials
RUN apt-get update && apt-get install -y \
	cmake \
	wget \
	zlib1g-dev \
        libghc-bzlib-dev

WORKDIR /opt

RUN 	wget http://research-pub.gene.com/gmap/src/gmap-gsnap-2016-11-07.tar.gz &&\
	tar zxvf gmap-gsnap-2016-11-07.tar.gz && rm gmap-gsnap-2016-11-07.tar.gz &&\
	cd gmap-2016-11-07 &&\
	./configure && make && make install



RUN mkdir /data
WORKDIR /data

# And clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /opt/*


