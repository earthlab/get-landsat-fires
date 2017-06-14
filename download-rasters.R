library(RCurl)
library(aws.s3)


# Fetching burn rasters ---------------------------------------------------
# get and read the file listing from the usgs server
prefix  <- 'https://rmgsc.cr.usgs.gov/outgoing/baecv/BAECV_CONUS_v1_2017/'
download.file(prefix, destfile = 'listing.txt')
out <- readLines('listing.txt')

# now create paths to each tar.gz file by processing the html

# find lines with '.tar.gz'
out <- out[grep('.tar.gz', x = out)]

# split these out by spaces
sep_lines <- unlist(strsplit(out, split = " "))

# subset to lines with links in them
file_lines <- sep_lines[grep("HREF", sep_lines)]

# remove the line pointing to the parent directory
file_lines <- file_lines[!grepl("To", file_lines)]

# strip unneeded prefix & suffix from the links
file_lines <- gsub(".*BAECV_CONUS_v1_2016/", replacement = "", file_lines)
file_lines <- gsub(".tar.gz.*", ".tar.gz", file_lines)
file_lines <- gsub("HREF=\"/outgoing/baecv/BAECV_CONUS_v1_2017/", "", 
                   file_lines)

# paste the file names together with the https prefix to make complete links
to_download <- paste0(prefix, file_lines)
local_dest <- gsub(prefix, "", to_download)

files_in_bucket <- get_bucket_df("earthlab-ls-fire")$Key

needs_downloading <- !local_dest %in% files_in_bucket

to_download <- to_download[needs_downloading]
local_dest <- local_dest[needs_downloading]

# iterate over the links to download each file
for (i in seq_along(to_download)) {
  download.file(to_download[i], destfile = local_dest[i])
}
