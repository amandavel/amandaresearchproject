#' ---
#' title: "organize_data.R"
#' author: "Amanda Ricketts"
#' ---

# This script will read in raw data from the input directory, clean it up to produce 
# the analytical dataset, and then write the analytical data to the output directory. 

##Source in any useful functions
source("check_packages.R")
source("useful_functions.R")

##Read in the IPUMS fixed-width data from gzip file and ensure all variables are read in as integers
ipumsdata <- read_fwf("input/usa_00010.dat.gz", 
                      col_positions = fwf_positions(start=c(1,11,24,25,37,47,50,51,52,55,56,59,60,61,62,63),
                                                    end  =c(10,23,24,36,46,49,50,51,54,55,58,59,60,61,62,64),
                                                    col_names=c("hhwt","cluster","metro","strata","perwt","age","marst","race",
                                                                "raced","hispan","hispand","hcovany","hcovpriv","hinsihs","empstat","empstatd")),
                      col_types = cols(.default = "i", cluster = "d"), 
                      progress = TRUE)

##Converting numeric codes for categorical variables into proper factor variables

#Marriage status 
ipumsdata$marriage <- NA
ipumsdata$marriage[ipumsdata$marst==1] <- "MarriedSP"
ipumsdata$marriage[ipumsdata$marst==2] <- "MarriedSA"
ipumsdata$marriage[ipumsdata$marst==3] <- "Separated"
ipumsdata$marriage[ipumsdata$marst==4] <- "Divorced"
ipumsdata$marriage[ipumsdata$marst==5] <- "Widowed"
ipumsdata$marriage[ipumsdata$marst==6] <- "Single"
ipumsdata$marriage <- factor(ipumsdata$marriage,
                     levels=c("MarriedSP","MarriedSA","Seperated","Divorced","Widowed","Single"))
table(ipumsdata$marst, ipumsdata$marriage, exclude=NULL)

#Employment status 
ipumsdata$employment <- NA
ipumsdata$employment[ipumsdata$empstat==0] <- "NA"
ipumsdata$employment[ipumsdata$empstat==1] <- "Employed"
ipumsdata$employment[ipumsdata$empstat==2] <- "Unemployed"
ipumsdata$employment[ipumsdata$empstat==3] <- "NILF"
ipumsdata$employment <- factor(ipumsdata$employment,
                             levels=c("NA","Employed","Unemployed","NILF"))
table(ipumsdata$empstat, ipumsdata$employment, exclude=NULL)

#Health insurance through Indian Health Service
ipumsdata$ihs <- NA
ipumsdata$ihs[ipumsdata$hinsihs==1] <- "IHSCoverage"
ipumsdata$ihs[ipumsdata$hinsihs==2] <- "NoIHSCoverage"
ipumsdata$ihs <- factor(ipumsdata$ihs,
                               levels=c("IHSCoverage","NoIHSCoverage"))
table(ipumsdata$hinsihs, ipumsdata$ihs, exclude=NULL)

#Private Health insurance coverage
ipumsdata$privatehi <- NA
ipumsdata$privatehi[ipumsdata$hcovpriv==1] <- "PrivateHINS"
ipumsdata$privatehi[ipumsdata$hcovpriv==2] <- "NoPrivateHINS"
ipumsdata$privatehi <- factor(ipumsdata$privatehi,
                               levels=c("PrivateHINS","NoPrivateHINS"))
table(ipumsdata$hcovpriv, ipumsdata$privatehi, exclude=NULL)

#Any health health insurance coverage
ipumsdata$privatehi <- NA
ipumsdata$privatehi[ipumsdata$hcovpriv==1] <- "PrivateHINS"
ipumsdata$privatehi[ipumsdata$hcovpriv==2] <- "NoPrivateHINS"
ipumsdata$privatehi <- factor(ipumsdata$privatehi,
                              levels=c("PrivateHINS","NoPrivateHINS"))
table(ipumsdata$hcovpriv, ipumsdata$privatehi, exclude=NULL)

#Metro status 
ipumsdata$metros <- NA
ipumsdata$metros[ipumsdata$metro==0] <- "Mixed"
ipumsdata$metros[ipumsdata$metro==1] <- "NotMetro"
ipumsdata$metros[ipumsdata$metro==2] <- "CentralCity"
ipumsdata$metros[ipumsdata$metro==3] <- "NotCentralCity"
ipumsdata$metros[ipumsdata$metro==4] <- "CSMixed"
ipumsdata$metros <- factor(ipumsdata$metros,
                              levels=c("Mixed","NotMetro","CentralCity","NotCentralCity","CSMixed"))
table(ipumsdata$metro, ipumsdata$metros, exclude=NULL)

#Race

##Replace numeric codes for missing values with NA values

#final code to preserve formatting of final analytical dataset
save(cleaned_dataset, file="output/analytical_data.RData")