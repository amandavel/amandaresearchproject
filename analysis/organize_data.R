#' ---
#' title: "organize_data.R"
#' author: "Amanda Ricketts"
#' ---

# This script will read in raw data from the input directory, clean it up to produce 
# the analytical dataset, and then write the analytical data to the output directory. 

#source in any useful functions
source("check_packages.R")
source("useful_functions.R")

#read in the IPUMS fixed-width data from gzip file and ensure all variables are read in as integers
ipumsdata <- read_fwf("input/usa_00010.dat.gz", 
                      col_positions = fwf_positions(start=c(1,11,24,25,37,47,50,51,52,55,56,59,60,61,62,63),
                                                    end  =c(10,23,24,36,46,49,50,51,54,55,58,59,60,61,62,64),
                                                    col_names=c("hhwt","cluster","metro","strata","perwt","age","marst","race",
                                                                "raced","hispan","hispand","hcovany","hcovpriv","hinsihs","empstat","empstatd")),
                      col_types = cols(.default = "i", cluster = "d"), 
                      progress = TRUE)

#drop cases that are missing on  SEI 
ipumsdata <- subset(ipumsdata, sei>0)

#drop the cbserial and cluster variables
ipumsdata <- subset(ipumsdata,
                 select=c("cluster","cbserial"))

head(ipumsdata)


#final code to preserve formatting of final analytical dataset
save(cleaned_dataset, file="output/analytical_data.RData")