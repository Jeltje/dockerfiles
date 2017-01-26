FROM    java

MAINTAINER Jeltje van Baren, jeltje.van.baren@gmail.com
# original source: https://github.com/ucscCancer/mc3


#Install Essentials
RUN 	apt-get update && apt-get install -y \
	python \
	python-pip \
	python-dev \
	zlib1g-dev \
	unzip \
	libncurses-dev
RUN   pip install pysam
RUN   pip install PyVCF

WORKDIR /opt
# samtools
RUN   wget -O samtools-0.1.18.tar.gz https://github.com/samtools/samtools/archive/0.1.18.tar.gz && \
	tar -xvzf samtools-0.1.18.tar.gz && rm -f samtools-0.1.18.tar.gz
RUN   cd /opt/samtools-0.1.18 && make && cp /opt/samtools-0.1.18/samtools /usr/local/bin/

# blat
RUN   wget -O /usr/local/bin/blat http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64.v287/blat/blat && chmod +x /usr/local/bin/blat

# Download and unpack snpEff
RUN   wget http://downloads.sourceforge.net/project/snpeff/snpEff_latest_core.zip && unzip snpEff_latest_core.zip

#Download and unpack radia
RUN   wget https://github.com/ucscCancer/radia/archive/v1.1.5.tar.gz && tar xvzf v1.1.5.tar.gz 
RUN   chmod -R 777 radia-1.1.5/scripts && mv radia-1.1.5/scripts/* /usr/local/bin

ADD     ./radia_wrapper /usr/local/bin/
ADD     ./radia_filter_wrapper /usr/local/bin/

RUN mkdir /data
WORKDIR /data

# And clean up
RUN	apt-get clean && rm -rf /var/lib/apt/lists/* radia-1.1.5  samtools-0.1.18  snpEff_latest_core.zip  v1.1.5.tar.gz
