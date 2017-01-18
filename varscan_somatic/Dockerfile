FROM    java

MAINTAINER Jeltje van Baren, jeltje.van.baren@gmail.com
# original source: https://github.com/ucscCancer/mc3


#Install Essentials
RUN 	apt-get update && apt-get install -y \
	wget \
	samtools \
	build-essential \
	git-core \
	cmake \
	zlib1g-dev \
	libncurses-dev

WORKDIR /opt
ENV     JAVA_JAR_PATH   /opt
RUN     wget http://downloads.sourceforge.net/project/varscan/VarScan.v2.3.9.jar &&\
	mv VarScan.v2.3.9.jar VarScan.jar

RUN	wget https://github.com/genome/bam-readcount/archive/v0.7.4.tar.gz && \
	tar xvzf v0.7.4.tar.gz &&\
	rm v0.7.4.tar.gz 

RUN 	mkdir /opt/bam-readcount-0.7.4/build

WORKDIR /opt/bam-readcount-0.7.4/build

RUN	cmake ../ &&\
	make deps &&\
	make -j &&\
	make install

ADD     ./VarScanSomaticVcf.py /usr/local/bin/

RUN mkdir /data
WORKDIR /data

ENTRYPOINT ["/usr/bin/python", "/usr/local/bin/VarScanSomaticVcf.py"]
CMD ["--help"]

# And clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* 


