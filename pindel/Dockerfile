FROM ubuntu

MAINTAINER Jeltje van Baren, jeltje.van.baren@gmail.com
# original source: https://github.com/ucscCancer/mc3

#Install Essentials
RUN 	apt-get update && apt-get install -y \
	git \
	wget \
	make \
	gcc \
	zlib1g-dev \
	ncurses-dev \
	g++ \
	python \
	python-pip
RUN     pip install PyVCF subprocess32

# get pindel and samtools
WORKDIR /opt
RUN	wget https://github.com/samtools/samtools/releases/download/1.2/samtools-1.2.tar.bz2 &&\
	tar xvjf samtools-1.2.tar.bz2
RUN     git clone https://github.com/genome/pindel.git

# install samtools
WORKDIR /opt/samtools-1.2
RUN     make && make install

# install pindel
WORKDIR /opt/pindel
RUN     git checkout v0.2.5b8 &&\
	./INSTALL /opt/samtools-1.2/htslib-1.2.1 &&\
	mv pindel* /usr/local/bin/

# add wrapper script
ADD     ./pindel_wrapper /usr/local/bin/

RUN mkdir /data
WORKDIR /data

ENTRYPOINT ["/usr/bin/python", "/usr/local/bin/pindel_wrapper"]
CMD ["--help"]

# And clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /opt/*


