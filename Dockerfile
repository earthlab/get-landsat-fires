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

ENTRYPOINT exec Rscript /home/download-rasters.R \
  && aws s3 cp . s3://earthlab-ls-fire --exclude '*' --include 'BAECV*.tar.gz'

