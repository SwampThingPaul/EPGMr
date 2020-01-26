EPGMr
================

[![DOI](https://zenodo.org/badge/234599925.svg)](https://zenodo.org/badge/latestdoi/234599925)

# Task Lists

  - [x] Distance profile function, `EPGMProfile()` with plots.
  - [x] Add summary reults table to distance profile function,
    `EPGMProfile()`.
  - [x] Develop time-series function, `EPGMTime()`.
      - [x] Develope time-series results summary function.
  - [x] Develop threshold evaluation function.
  - [ ] Figure out how to code greek (i.e. mu) and superscript for `.Rd`
    files.
  - [ ] Submit to [rOpenSci](https://ropensci.org/) for community
    peer-review.
  - [ ] Submit to [CRAN](https://cran.r-project.org/submit.html).

-----

**Contact Info:** [Webpage](http://swampthingecology.org) -
[Twitter](https://twitter.com/SwampThingPaul) -
[Email](mailto:pauljulianphd@gmail.com)

-----

This package is an R-version of the original Everglades Phosphorus
Gradient Model developed by Walker and Kadlec and implements the model
described in:

  - Walker WW, Kadlec, R.H. (1996) A Model for Simulating Phosphorus
    Concentrations in Waters and Soils Downstream of Everglades
    Stormwater Treatment Areas. U.S. Department of the Interior. Links
    to: [Report](http://www.wwwalker.net/epgm/epgm_Aug_1996_1_of_2.pdf);
    [Appendix](http://www.wwwalker.net/epgm/epgm_Aug_1996_2_of_2.pdf).

The model is further discussed in:

  - Kadlec RH, Walker WW (1999) Management models to evaluate phosphorus
    impacts on wetlands. In: Reddy KR, O’Conner GA, Schelske CL (eds)
    Phosphorus Biogeochemistry in Subtropical Ecosystems. Lewis
    Publishers, Boca Raton, FL, pp 621–639.

  - Walker WW, Kadlec RH (2011) Modeling Phosphorus Dynamics in
    Everglades Wetlands and Stormwater Treatment Areas. Critical Reviews
    in Environmental Science and Technology 41:430–446.

-----

## From the Original EPGM documentation developed by [Walker and Kadlec (1996)](http://www.wwwalker.net/epgm/).

### Synopsis:

Everglades Phosphorus Gradient Model (EPGM; Figure 1) predicts
variations in water-column phosphorus (P) concentration, peat accretion
rate, and soil P concentration along a horizontal gradient imposed by an
external P load and sheet-flow conditions. Cattail densities and total
areas are predicted based upon correlations with soil P and are
surrogates for impacts on ecosystem components which respond to soil P
variations in similar concentration ranges. The model is calibrated to
soil and vegetation data from WCA-2 (primarily), WCA-1, and WCA-3A. The
model successfully simulates observed [longitudinal gradients in soil P
concentration below the S10 structures in
WCA-2A](http://www.wwwalker.net/epgm/wca2a_gradient.htm) after \~28
years of external P loading (1962 to 1990). Observed expansion of
cattail populations in this region between 1973 and 1991 is also
simulated, though somewhat over-predicted during the first 20 years.
Model results suggest a linear relationship between marsh water-column
and soil P concentrations over long time scales. Estimated soil response
times range from 20 to 40 years, depending on soil depth, and are
inversely related to water-column concentration.

### Conceptual Figure of the Model

![EPGM](http://www.wwwalker.net/epgm/epgmpic.gif)

Everglades Phosphorus Gradient Model structure (*Walker and Kadlec
1996*)

-----

## EPGMr Installation

``` r
install.packages("devtools");# if you do not have it installed on your PC
devtools::install_github("SwampThingPaul/EPGMr")
```

## Functions

For the examples below we are going to use an internal dataset within
this package. This is also the data provided in the orginal
[EPGM](http://www.wwwalker.net/epgm/) as case study examples. To see
these data use the `data()` function.

``` r
data("casedat")
```

Case number 11 is data from the S10 structures that discharge into
northeast Water Conservation area 2A, the historic eutrophication
gradient within the Everglades ecosystem.

``` r
#I transposed the data for easy viewing. 
t(casedat[casedat$case.number==11,])
```

    ##                                11            
    ## case.number                    "11"          
    ## STA.Name                       "S10s"        
    ## Receiving.Area                 "NE 2A"       
    ## Start.Discharge                "1962"        
    ## STA.outflow.TPconc             "122"         
    ## STA.outflow.vol                "281.3"       
    ## FlowPath.width                 "10.5"        
    ## Hydroperiod                    "91.4"        
    ## Soil.Depth                     "10"          
    ## Soil.BulkDensity.inital        "0.102"       
    ## Soil.TPConc.inital             "198"         
    ## Vertical.SoilTPGradient.inital "-0.001836432"
    ## Soil.BulkDensity.final         "0.08"        
    ## PSettlingRate                  "10.2"        
    ## P.AtmoDep                      "42.9"        
    ## Rainfall                       "1.16"        
    ## ET                             "1.38"

*Distance Profile*

This will run the example case number 11, plot the distance profile
depicited below and provide a summary results table. If `raw.output` was
set to `TRUE`, the raw data behind the plots and summary tables would be
printed in the console. If `results.table` was set to `TRUE` then a
summary results table will be printed (default). The results output
table under `$DistanceProfile` provides a summary of the simulation
period at several user input distances, however the default argument in
the function is `summary.distance=c(0,0.5,1,2,4,8,10)`. Other
information in the summary result tab include, simulation inputs, water
budget, phosphorus mass balance and information on regarding soils for
the simulation period (default is 30 years).

``` r
EPGMProfile(case.no=11,plot.profile=TRUE,summary.distance=c(0,1,2,4,10))
```

<img src="README_files/figure-gfm/distance profile plot-1.png" style="display: block; margin: auto;" />

    ## $Time.yrs
    ## [1] 30
    ## 
    ## $Simulated.Zone
    ##                    Parameter Value
    ## 1                Distance.km  15.0
    ## 2                   Width.km  10.5
    ## 3                   Area.km2 157.5
    ## 4 STA.outflow.volume.kAcftyr 281.3
    ## 5            Hydroperiod.pct  91.4
    ## 6              Soil.Depth.cm  10.0
    ## 7          P.Settle.Rate.myr  10.2
    ## 8       STA.outflow.Conc.ugL 122.0
    ## 9      STA.outflow.Load.mtyr  42.4
    ## 
    ## $DistanceProfile
    ##                                       0       1       2       4     10
    ## WaterCol.Pconc.ugL               122.00   93.70   72.10   43.10  11.50
    ## SteadyState.WC.Conc.ugL          122.00   93.70   72.10   43.10  11.50
    ## SteadyState.Soil.Conc.mgkg      2131.00 1744.00 1449.00 1053.00 620.00
    ## Time.to.Steady.State.yrs          15.00   16.00   17.20   20.90  46.30
    ## NewSoil.Depth.cm                  10.00   10.00   10.00   10.00   6.50
    ## Soil.Mass.Accret.kgm2yr            0.67    0.63    0.58    0.48   0.22
    ## Cattail.Density.pct              100.00   99.00   95.00   53.00   2.00
    ## SteadyState.Cattail.Density.pct  100.00   99.00   95.00   53.00   5.00
    ## 
    ## $Water.Budget
    ##          Total.Flow.m Total.Flow.hm3 Sim.Avg.Flow.myr
    ## Inflow          66.14          10417             2.20
    ## Rainfall        34.80           5481             1.16
    ## ET              41.40           6520             1.38
    ## Outflow         59.54           9378             1.98
    ## 
    ## $P.MassBalance
    ##          PMass.mgm2 PMass.mtons Sim.Avg.Load.mgm2yr
    ## Inflow         8069      1270.9               269.0
    ## Rainfall       1493       235.1                49.8
    ## Removal        8986      1415.3               299.5
    ## Outflow         576        90.7                19.2
    ## 
    ## $Soils
    ##                 SoilMass.kgm2 PMass.mgm2 PConc.mgkg BulkDensity.gcm3
    ## Initial Storage         10.20       2020        198            0.102
    ## Current Storage          8.46       6763        800            0.085
    ## Accretion                8.22       8986       1093            0.080
    ## Burial                   9.97       4243        426            0.097
    ##                 PVol.mgcm3
    ## Initial Storage      0.020
    ## Current Storage      0.068
    ## Accretion            0.087
    ## Burial               0.041

*Time Profile*

This function will run the EPGM model over a determined period of time
(with specificied time increment). If `raw.time.output` is set to
`TRUE`, the raw data behind the plots and summary tables will be printed
in the console and/or saved as an object. This will results in a
`data.frame` with data specific to space (i.e. distance) and time
(i.e. year).

``` r
EPGMTime(case.no=11)
```

![](README_files/figure-gfm/time%20profile%20plot-1.png)<!-- -->

    ## $Time.yrs
    ## [1] 200
    ## 
    ## $Time.increment.yrs
    ## [1] 5
    ## 
    ## $Simulated.Zone
    ##                    Parameter Value
    ## 1                Distance.km  15.0
    ## 2                   Width.km  10.5
    ## 3                   Area.km2 157.5
    ## 4 STA.outflow.volume.kAcftyr 281.3
    ## 5            Hydroperiod.pct  91.4
    ## 6              Soil.Depth.cm  10.0
    ## 7          P.Settle.Rate.myr  10.2
    ## 8       STA.outflow.Conc.ugL 122.0
    ## 9      STA.outflow.Load.mtyr  42.4
    ## 
    ## $TimeProfile
    ##   Time.Step Year SoilP.mgkg CattailDensity.ha
    ## 1         0 1961        198                47
    ## 2         5 1966        335               227
    ## 3        10 1971        477              1605
    ## 4        15 1976        622              3203
    ## 5        20 1981        715              4239
    ## 6        25 1986        765              4615
    ## 7        30 1991        800              4755
    ## 8        35 1996        826              4830
    ## 9       200 2161        902              5005

*Threshold Evaluation*

This function will calculate, summarise and plot area exceedance for
results from `EPGMTime()`. Currently the function is configured to
evaluate three threshold for water column, soil and cattail density
within the modelled flow-path. Much like the other functions, If
`raw.area.output` is set to `TRUE`, then the raw results summarized in
the summary table and plots will be provided as a `data.frame`.

``` r
example<-EPGMTime(case.no=11,raw.time.output=TRUE,plot.profile=FALSE)

EPGMThreshold(example)
```

![](README_files/figure-gfm/threshold%20plot-1.png)<!-- -->

    ## $TotalArea.km2
    ## [1] 157.5
    ## 
    ## $Thresholds
    ##            Thresholds Value1 Value2 Value3
    ## 1 Water Column (ug/L)     10     15     20
    ## 2        Soil (mg/kg)    500    600   1000
    ## 3 Cattail Density (%)      5     20     90
    ## 
    ## $WaterColumn
    ##    Time.Step Year   WC.10  WC.15  WC.20
    ## 1          0 1961   0.000  0.000  0.000
    ## 2          5 1966 113.925 89.775 76.125
    ## 3         10 1971 113.925 89.775 76.125
    ## 4         15 1976 113.925 89.775 76.125
    ## 5         20 1981 113.925 89.775 76.125
    ## 6         25 1986 113.925 89.775 76.125
    ## 7         30 1991 113.925 89.775 76.125
    ## 8         35 1996 113.925 89.775 76.125
    ## 41       200 2161 113.925 89.775 76.125
    ## 
    ## $Soil
    ##    Time.Step Year Soil.500 Soil.600 Soil.1000
    ## 1          0 1961    0.000    0.000     0.000
    ## 2          5 1966   23.625   13.125     0.000
    ## 3         10 1971   50.925   40.425    15.225
    ## 4         15 1976   67.725   56.175    30.975
    ## 5         20 1981   80.325   67.725    42.525
    ## 6         25 1986   90.825   78.225    45.675
    ## 7         30 1991   99.225   85.575    45.675
    ## 8         35 1996  107.625   92.925    45.675
    ## 41       200 2161  157.500  113.925    45.675
    ## 
    ## $Cattail
    ##    Time.Step Year Cattail.5 Cattail.20 Cattail.90
    ## 1          0 1961     0.000      0.000      0.000
    ## 2          5 1966    12.075      0.000      0.000
    ## 3         10 1971    39.375     23.625      1.575
    ## 4         15 1976    55.125     39.375     18.375
    ## 5         20 1981    66.675     50.925     25.725
    ## 6         25 1986    77.175     59.325     25.725
    ## 7         30 1991    84.525     61.425     25.725
    ## 8         35 1996    91.875     61.425     25.725
    ## 41       200 2161   108.675     61.425     25.725
