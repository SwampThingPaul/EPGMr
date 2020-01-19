EPGMr
================

[![DOI](https://zenodo.org/badge/234599925.svg)](https://zenodo.org/badge/latestdoi/234599925)

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

``` r
EPGMProfile(case.no=11,plot.profile=T)
# This will run the example case number 11 and plot the distance profile depicited below.
```

<img src="README_files/figure-gfm/distance profile plot-1.png" title="Distance profile for Case 11 (i.e. S10s) at the end of the 30 year simulation period." alt="Distance profile for Case 11 (i.e. S10s) at the end of the 30 year simulation period." style="display: block; margin: auto;" />
