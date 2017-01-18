FROM    ubuntu

MAINTAINER Jeltje van Baren, jeltje.van.baren@gmail.com
# original source: https://github.com/ucscCancer/mc3

#Install Essentials
RUN 	apt-get update && apt-get install -y \
	python \
	wget \
	python-pip \
	python-dev \
	zlib1g-dev \
	libncurses-dev
RUN     pip install bx-python

WORKDIR /opt

RUN     wget https://github.com/samtools/samtools/releases/download/1.2/samtools-1.2.tar.bz2 &&\
	tar -xvjf samtools-1.2.tar.bz2 &&\
	rm -f samtools-1.2.tar.bz2
RUN     cd /opt/samtools-1.2 && make -j && make install

ADD     ./sam_pileup.py /usr/local/bin/

RUN mkdir /data
WORKDIR /data

ENTRYPOINT ["/usr/bin/python", "/usr/local/bin/sam_pileup.py"]
CMD ["--help"]

# And clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*  /opt/samtools*
