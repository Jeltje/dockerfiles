FROM    ubuntu

MAINTAINER Jeltje van Baren, jeltje.van.baren@gmail.com
# original source: https://github.com/ucscCancer/mc3

#Install Essentials
RUN 	apt-get update && apt-get install -y \
	wget \
	samtools \
	python-pip \
	python-dev \
	tabix \
	zlib1g-dev

RUN     pip install pysam

RUN     mkdir /opt/bin
RUN     wget -O /usr/local/bin/MuSEv1.0rc http://bioinformatics.mdanderson.org/Software/MuSE/MuSEv1.0rc_submission_c039ffa
RUN     chmod +x /usr/local/bin/MuSE*
ADD     ./muse.py /usr/local/bin/

RUN mkdir /data
WORKDIR /data

ENTRYPOINT ["/usr/bin/python", "/usr/local/bin/muse.py"]
CMD ["--help"]


# And clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* 


