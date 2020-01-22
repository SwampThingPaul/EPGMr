EPGMr
================

[![DOI](https://zenodo.org/badge/234599925.svg)](https://zenodo.org/badge/latestdoi/234599925)

[![](https://img.shields.io/github/last-commit/SwampThingPaul/EPGMr.svg)](https://github.com/SwampThingPaul/EPGMr/commits/master)

-----

# This Package is still *in Development*

# Task Lists

  - [x] Distance profile function, `EPGMProfile()` with plots.
  - [x] Add summary reults table to distance profile function,
    `EPGMProfile()`.
  - [ ] Develop time-series function (**In Progress**).
      - [ ] Develope time-series results summary function.
  - [ ] Develop threshold evaluation function.
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

EPGM structure

![EPGM](http://www.wwwalker.net/epgm/epgmpic.gif)

-----

## EPGMr Installation

``` r
install.packages("devtools");# if you do not have it installed on your PC
devtools::install_github("SwampThingPaul/EPGMr")
```

## Functions

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
EPGMProfile(case.no=11,plot.profile=T,summary.distance=c(0,1,2,4,10))
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
(with specificied time increment). If `raw.output` was set to `TRUE`,
the raw data behind the plots and summary tables would be printed in the
console. This will results in a `data.frame` with data specific to space
(i.e. distance) and time (i.e. year).

``` r
EPGMTime(case.no=11)
```

![](README_files/figure-gfm/time%20profile%20plot-1.png)<!-- -->
