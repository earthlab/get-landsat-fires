FROM rocker/r-ver:latest

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ssh \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    man \
    less \
    vim \
    python \
    python-pip \
  && pip install awscli \
  && apt-get clean

RUN echo "install.packages(c('RCurl', 'aws.s3'))" | R --slave 

WORKDIR /home/

COPY . /home/

RUN ["chmod", "+x", "/home/files-to-s3.sh"]

ENTRYPOINT ["/home/files-to-s3.sh"]

