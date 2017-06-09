#!/bin/bash

# download files locally
Rscript download-rasters.R

# push them to s3
aws s3 cp . s3://earthlab-ls-fire --exclude '*' --include 'BAECV*.tar.gz' --recursive

