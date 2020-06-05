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

##Converting numeric codes for categorical variables into proper factor variables AND 
##collapsing categories in categorical variables into smaller sets.

#Marriage status 

ipumsdata$marriage <- NA
ipumsdata$marriage[ipumsdata$marst==1] <- "MarriedSP"
ipumsdata$marriage[ipumsdata$marst==2] <- "MarriedSA"
ipumsdata$marriage[ipumsdata$marst==3] <- "Separated"
ipumsdata$marriage[ipumsdata$marst==4] <- "Divorced"
ipumsdata$marriage[ipumsdata$marst==5] <- "Widowed"
ipumsdata$marriage[ipumsdata$marst==6] <- "Single"
ipumsdata$marriage <- factor(ipumsdata$marriage,
                             levels=c("MarriedSP","MarriedSA","Separated","Divorced","Widowed","Single"))
table(ipumsdata$marst, ipumsdata$marriage, exclude=NULL)

#Employment status 
ipumsdata$employment <- NA
ipumsdata$employment[ipumsdata$empstat==1] <- "Employed"
ipumsdata$employment[ipumsdata$empstat==2] <- "Unemployed"
ipumsdata$employment[ipumsdata$empstat==3] <- "NILF"
ipumsdata$employment <- factor(ipumsdata$employment,
                             levels=c("Employed","Unemployed","NILF"))
table(ipumsdata$empstat, ipumsdata$employment, exclude=NULL)

#Health insurance through Indian Health Service
ipumsdata$ihs <- NA
ipumsdata$ihs[ipumsdata$hinsihs==1] <- "NoIHSCoverage"
ipumsdata$ihs[ipumsdata$hinsihs==2] <- "IHSCoverage"
ipumsdata$ihs <- factor(ipumsdata$ihs,
                               levels=c("IHSCoverage","NoIHSCoverage"))
table(ipumsdata$hinsihs, ipumsdata$ihs, exclude=NULL)

#Private Health insurance coverage
ipumsdata$privatehi <- NA
ipumsdata$privatehi[ipumsdata$hcovpriv==1] <- "NoPrivateHINS"
ipumsdata$privatehi[ipumsdata$hcovpriv==2] <- "PrivateHINS"
ipumsdata$privatehi <- factor(ipumsdata$privatehi,
                               levels=c("PrivateHINS","NoPrivateHINS"))
table(ipumsdata$hcovpriv, ipumsdata$privatehi, exclude=NULL)

#Any health health insurance coverage
ipumsdata$anyhins <- NA
ipumsdata$anyhins[ipumsdata$hcovany==1] <- "NotCovered"
ipumsdata$anyhins[ipumsdata$hcovany==2] <- "Covered"
ipumsdata$anyhins <- factor(ipumsdata$anyhins,
                              levels=c("Covered","NotCovered"))
table(ipumsdata$hcovany, ipumsdata$anyhins, exclude=NULL)

#Metro status 
ipumsdata$metros <- NA
ipumsdata$metros[ipumsdata$metro==0] <- "Mixed"
ipumsdata$metros[ipumsdata$metro==1] <- "NotMetro"
ipumsdata$metros[ipumsdata$metro==2] <- "MetroCC"
ipumsdata$metros[ipumsdata$metro==3] <- "MetroNoCC"
ipumsdata$metros[ipumsdata$metro==4] <- "CSMixed"
ipumsdata$metros <- factor(ipumsdata$metros,
                              levels=c("NotMetro","Mixed","CSMixed","MetroNoCC","MetroCC"))
table(ipumsdata$metro, ipumsdata$metros, exclude=NULL)

##Creating a racecombo variable and making it a factor variable
ipumsdata$racecombo <- factor(ifelse(ipumsdata$hispan!=0,"Hispanic",
                                     ifelse(ipumsdata$race==1, "NH White",
                                            ifelse(ipumsdata$race==2, "NH Black",
                                                   ifelse(ipumsdata$race==3, "NH AIAN",
                                                          ifelse(ipumsdata$race==4 | 
                                                                   ipumsdata$race==5 | 
                                                                   ipumsdata$race==6,"NH API","NH Other/Multi"))))),
                              levels=c("NH White", "NH Black", "Hispanic", "NH API", "NH AIAN", "NH Other/Multi"))

table(ipumsdata$race, ipumsdata$racecombo, exclude=NULL) 
table(ipumsdata$hispan, ipumsdata$racecombo, exclude=NULL) 
summary(ipumsdata$racecombo)

##Replace numeric codes for missing values with NA values

ipumsdata$age[ipumsdata$age==0] <- NA
summary(ipumsdata$age)

#Collapsing Variables 

#Marriage
ipumsdata$marriage <- factor(ifelse(ipumsdata$marst==1 | 
                                      ipumsdata$marst==2, "Married",
                                    ifelse(ipumsdata$marst==3 |
                                             ipumsdata$marst==4 |
                                             ipumsdata$marst==5 | 
                                             ipumsdata$marst==6,"NotMarried", NA)),
                             levels=c("Married","NotMarried"))

table(ipumsdata$marst, ipumsdata$marriage, exclude=NULL) 
summary(ipumsdata$marriage)

#Employment status 

ipumsdata$employment <- factor(ifelse(ipumsdata$empstat==1, "Employed",
                                    ifelse(ipumsdata$empstat==2 |
                                             ipumsdata$empstat==3,"Nonemployed", NA)),
                             levels=c("Employed","Nonemployed"))

table(ipumsdata$empstat, ipumsdata$employment, exclude=NULL) 
summary(ipumsdata$employment)

#Metro status 
ipumsdata$metros <- factor(ifelse(ipumsdata$metro==0, "Mixed",
                                  ifelse(ipumsdata$metro==1, "NotMetro",
                                         ifelse(ipumsdata$metro==2 |
                                                  ipumsdata$metro==3 |
                                                  ipumsdata$metro==4, "Metro", NA))),
                             levels=c("Metro","Mixed","NotMetro"))

table(ipumsdata$metro, ipumsdata$metros, exclude=NULL) 
summary(ipumsdata$metros)

##Creating the One True Health Insurance Variable

ipumsdata$hins <- ifelse(ipumsdata$ihs=="IHSCoverage","IHS", 
                         ifelse(ipumsdata$privatehi=="PrivateHINS","Private",
                                ifelse(ipumsdata$anyhins=="Covered", "Public", 
                                       ifelse(ipumsdata$anyhins=="NotCovered","None",
                                              NA))))


##Removing all unneeded variables

ipumsdata <- subset(ipumsdata, 
              select=c("hhwt","cluster","metro","strata","perwt","age","racecombo","marriage",
                       "employment","anyhins","metros","hins"))
ipumsdata

#final code to preserve formatting of final analytical dataset
save(ipumsdata, file="output/analytical_data.RData")