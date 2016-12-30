FROM ubuntu

MAINTAINER Jeltje van Baren, jeltje.van.baren@gmail.com

#Install Essentials
RUN apt-get update && apt-get install -y \
	wget \
	build-essential \
	git-core \
	cmake \
	zlib1g-dev \
	libncurses-dev \
	python \
	python-dev \
	python-pip

RUN pip install pysam

WORKDIR /opt

RUN wget https://github.com/genome/somatic-sniper/archive/v1.0.5.0.tar.gz && \
	tar xvzf v1.0.5.0.tar.gz && \
	rm v1.0.5.0.tar.gz
RUN cd /opt/somatic-sniper-1.0.5.0 && \
	mkdir build && \
	cd build && \
	cmake ../ && \
	make deps && \
	make -j && \
	make install
RUN mv /opt/somatic-sniper-1.0.5.0/build/vendor/samtools/samtools /usr/bin/

ENTRYPOINT ["/usr/local/bin/bam-somaticsniper"]

RUN mkdir /data
WORKDIR /data

# And clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /opt/somatic-sniper-1.0.5.0 


