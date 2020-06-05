---
title: "Analysis for Project"
output: 
  html_document: 
    fig_height: 6
    fig_width: 9
    toc: yes
    toc_depth: 4
---



# Introduction
<a href="#top">Back to top</a>

Use this R Markdown to perform the main analysis for the project. I use this basically as a lab notebook. It contains the main analysis and a variety of sensitivity analysis. The code in this documents serves as a baseline for the eventual tables and figures that will go into the paper. At the same time it will serve as a record of all supplementary analyses performed. 

# Data and Methods

##Weighting 


# Analysis

First, I want to see the proportions of health insurance I'm working with. 


    IHS    None Private  Public 
  28195  421393 2896447  586594 

        IHS        None     Private      Public 
0.007169504 0.107153001 0.736516717 0.149160778 

   Covered NotCovered 
   3501893     430736 

   Covered NotCovered 
 0.8904712  0.1095288 

      NH White       NH Black       Hispanic         NH API        NH AIAN 
       2603952         390232         578405         239564          36213 
NH Other/Multi 
         84263 

      NH White       NH Black       Hispanic         NH API        NH AIAN 
   0.662140263    0.099229294    0.147078456    0.060917010    0.009208344 
NH Other/Multi 
   0.021426633 

                        Estimate Std. Error  z value Pr(>|z|)
(Intercept)                2.460      0.002 1068.968        0
racecomboNH Black         -0.755      0.005 -151.050        0
racecomboHispanic         -1.214      0.004 -310.881        0
racecomboNH API            0.099      0.008   12.033        0
racecomboNH AIAN          -1.445      0.012 -119.309        0
racecomboNH Other/Multi   -0.423      0.011  -38.347        0
            (Intercept)       racecomboNH Black       racecomboHispanic 
             11.7067917               0.4699857               0.2968732 
        racecomboNH API        racecomboNH AIAN racecomboNH Other/Multi 
              1.1042590               0.2356978               0.6551688 
The race model, before exponentiating and converting these values to probabilities, I can see that whites (the reference category) have the highest probabilty of having any health insurance. AIANs, on the other hand, have by far the lowest probability of having any health insurance coverage. 



(Intercept)         age 
 1.31468100  0.01909152 
(Intercept)         age 
   3.723563    1.019275 

The age model shows that a one year increase in age is associated with an increase in the predicated probability of healthcare coverage.

<img src="analysis_files/figure-html/Logit Age Graph-1.png" width="864" />(Intercept)         age 
   3.723563    1.019275 
The age model shows an increase in the predicted probability of health care coverage as age increases. The average 18 year old, without taking any other independent variables into account, has a. A one year increase 

**Why are the numbers different between age graph + model? 
<img src="analysis_files/figure-html/Logit Race and Age Graph-1.png" width="864" />            (Intercept)                     age       racecomboNH Black 
              6.0747317               1.0156158               0.4835139 
      racecomboHispanic         racecomboNH API        racecomboNH AIAN 
              0.3173805               1.1558170               0.2409097 
racecomboNH Other/Multi 
              0.7221836 

The combined age and race model still shows an increase in the predicted probability of health care coverage as age increases, but has vastly differenct effects for race. 

<img src="analysis_files/figure-html/Logit Metro Status and Age Graph-1.png" width="864" />   (Intercept)            age    metrosMixed metrosNotMetro 
     3.9783126      1.0197721      0.7115937      0.7284631 

The metro status and age model still shows an increase in the predicted probability of health care coverage as age increases, but mixed metro and non-metro status and non-metro status have far a far lower predicted probability of having health care coverage. 

                                       Estimate Std. Error  z value Pr(>|z|)
(Intercept)                              -2.427      0.003 -709.618    0.000
I(age - 42)                              -0.019      0.000 -145.862    0.000
I((age - 42)^2)                          -0.001      0.000 -103.554    0.000
metrosMixed                               0.507      0.006   88.699    0.000
metrosNotMetro                            0.490      0.007   75.155    0.000
racecomboNH Black                         0.740      0.006  124.349    0.000
racecomboHispanic                         1.246      0.005  276.590    0.000
racecomboNH API                          -0.041      0.009   -4.627    0.000
racecomboNH AIAN                          1.306      0.021   62.269    0.000
racecomboNH Other/Multi                   0.333      0.013   25.350    0.000
metrosMixed:racecomboNH Black             0.193      0.014   14.047    0.000
metrosNotMetro:racecomboNH Black          0.325      0.017   19.103    0.000
metrosMixed:racecomboHispanic             0.024      0.013    1.805    0.071
metrosNotMetro:racecomboHispanic         -0.058      0.016   -3.500    0.000
metrosMixed:racecomboNH API               0.096      0.038    2.498    0.012
metrosNotMetro:racecomboNH API            0.220      0.048    4.612    0.000
metrosMixed:racecomboNH AIAN             -0.038      0.030   -1.251    0.211
metrosNotMetro:racecomboNH AIAN          -0.067      0.030   -2.260    0.024
metrosMixed:racecomboNH Other/Multi       0.242      0.030    8.128    0.000
metrosNotMetro:racecomboNH Other/Multi    0.159      0.036    4.372    0.000
                           (Intercept)                            I(age - 42) 
                             0.0882968                              0.9811529 
                       I((age - 42)^2)                            metrosMixed 
                             0.9989550                              1.6603140 
                        metrosNotMetro                      racecomboNH Black 
                             1.6324872                              2.0968630 
                     racecomboHispanic                        racecomboNH API 
                             3.4753594                              0.9602433 
                      racecomboNH AIAN                racecomboNH Other/Multi 
                             3.6902416                              1.3948855 
         metrosMixed:racecomboNH Black       metrosNotMetro:racecomboNH Black 
                             1.2126951                              1.3842467 
         metrosMixed:racecomboHispanic       metrosNotMetro:racecomboHispanic 
                             1.0246080                              0.9439176 
           metrosMixed:racecomboNH API         metrosNotMetro:racecomboNH API 
                             1.1003454                              1.2464382 
          metrosMixed:racecomboNH AIAN        metrosNotMetro:racecomboNH AIAN 
                             0.9626232                              0.9349788 
   metrosMixed:racecomboNH Other/Multi metrosNotMetro:racecomboNH Other/Multi 
                             1.2735963                              1.1724062 
This a very complex model. 
[1] -29675.59
[1] -124111.9
[1] -153787.5

The BIC comparison shows a preference for the complex healthcare model with a result of -29675.59. Both the race and age and complex healthcare model are preffered to the null BIC' model. 


