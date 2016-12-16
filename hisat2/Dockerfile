FROM ubuntu

MAINTAINER Jeltje van Baren, jeltje.van.baren@gmail.com

#Install Essentials
RUN apt-get update && apt-get install -y \
	wget \
        unzip

WORKDIR /opt

RUN wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.0.5-Linux_x86_64.zip &&\
    unzip hisat2-2.0.5-Linux_x86_64.zip &&\
    rm hisat2-2.0.5-Linux_x86_64.zip


ENV PATH /opt/hisat2-2.0.5:$PATH

RUN mkdir /data
WORKDIR /data

# And clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* 


