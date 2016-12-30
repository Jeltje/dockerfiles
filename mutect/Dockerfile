
FROM java:7

MAINTAINER Jeltje van Baren, jeltje.van.baren@gmail.com

#Install Essentials
RUN apt-get update && apt-get install -y \
	zip \
	wget \
	samtools \
	python-pip 

RUN pip install PyVCF
WORKDIR /opt

# get the jar files
RUN wget https://github.com/broadinstitute/mutect/releases/download/1.1.5/muTect-1.1.5-bin.zip &&\
	unzip muTect-1.1.5-bin.zip &&\
        rm muTect-1.1.5-bin.zip
RUN wget https://github.com/broadinstitute/picard/releases/download/1.122/picard-tools-1.122.zip &&\
	unzip picard-tools-1.122.zip &&\
	ln -s picard-tools-1.122 picard &&\
        rm picard-tools-1.122.zip

# This script originally came from https://github.com/ucscCancer/mc3/
ADD mutect.py /usr/local/bin/

RUN mkdir /data
WORKDIR /data

ENTRYPOINT ["/usr/bin/python", "/usr/local/bin/mutect.py"]
CMD ["--help"]


# And clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* 


