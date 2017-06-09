# Pushing Landsat burn rasters into Amazon S3

This repository contains code and a Dockerfile for pushing Landsat burn rasters from USGS servers into an Amazon S3 bucket so that the data can be more easily accessed in the cloud. 
The S3 bucket is currently designated as `earthlab-ls-fire`, which has restricted access (you must be an approved Earth Lab member to read or write from the bucket). 
Credentials must be supplied to push to the bucket via a text file called creds.txt, formatted like so: 

```
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_DEFAULT_REGION=us-west-2
```

To build the Docker image, and then run it (downloading and then copying the files into S3), use the following commands from the terminal with the credentials file in your current directory:

```
docker build -t get-lsat-fires .
docker run --env-file creds.txt get-lsat-fires
```

