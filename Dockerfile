FROM rocker/r-ver:latest

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ssh \
    libcurl4-openssl-dev \
    man \
    less \
    vim \
    python \
    python-pip \
  && pip install awscli \
  && apt-get clean

RUN echo "install.packages('RCurl')" | R --slave 

WORKDIR /home/

COPY . /home/

RUN ["chmod", "+x", "/home/files-to-s3.sh"]

ENTRYPOINT ["/home/files-to-s3.sh"]

