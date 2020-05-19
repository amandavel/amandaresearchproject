#' ---
#' title: "organize_data.R"
#' author: "Amanda Ricketts"
#' ---

# This script will read in raw data from the input directory, clean it up to produce 
# the analytical dataset, and then write the analytical data to the output directory. 

#source in any useful functions
source("check_packages.R")
source("useful_functions.R")
load("input/usa_00007.dat.gz")

#read in the IPUMS fixed-width data from gzip file and ensure all variables are read in as integers
ipumsdata <- read_fwf("input/usa_00007.dat.gz", 
                      col_positions = fwf_positions(start=c(1,5, 11,19,32,42,55,67,68,72,82,83,86,87,90,91,92,93),
                                                    end  =c(4,10,18,31,41,54,66,67,71,81,82,85,86,89,90,91,92,94),
                                                    col_names=c("year","sample","serial","cbserial","hhwt",
                                                                "cluster","strata","gq", "pernum", "perwt",
                                                                "race","raced","hispan","hispand","hcovany","hcovpriv","hinsihs","sei")))
               
#drop cases that are missing on  SEI 
ipumsdata <- subset(ipumsdata, sei>0)

#drop the cbserial and cluster variables
ipumsdata <- subset(ipumsdata,
                 select=c("cluster","cbserial"))


head(ipumsdata)
