#' Distance Profile
#'
#' The model is based primarily upon data collected in the early 1990's along the phosphorus gradient in WCA-2A. Substantial additional data collected since then in WCA-2A and other locations indicate a need to recalibrate the model and potentially revise its structure. Recent data suggest, for example, that the relationship between cattail density and soil P needs recalibration and that actual soil P thresholds for biological impacts are probably lower than reflected in the original calibrations.  There are also issues relating to interpretation of and potential anomalies in the historical soil P calibration data attributed to variations in soil core collection method and definition of the soil/water interface (inclusion vs. exclusion of floc layer). There are also indications in the recent data of biologically-mediated vertical transport and/or mixing that are not reflected in the current model structure.
#'
#' As described in the original documentation, the model is designed to simulate marsh enrichment (responses to increasing P load), not recovery (responses to decreasing in load).
#'
#'
#' @param case.no Case number from the pre-loaded example data (values ranges from 1 to 12)
#' @param Start.Discharge The year of discharge started
#' @param Start.Discharge The year which this particular STA began discharge operations.
#' @param STA.outflow.TPconc Outflow total phosphorus concentration (in ug L^{-1}) for this STA.
#' @param STA.outflow.vol Annual outflow discharge volume (in x10^{3} Acre-Feet Year^{-1}) for this STA.
#' @param FlowPath.width The width of the downstream flow path (in kilometers).
#' @param Hydroperiod Average hydroperiod (time above ground surface) of the downstream system (in percent).
#' @param Soil.Depth Depth of soil (in centimeters).
#' @param Soil.BulkDensity.intial The initial bulk density prior to dicharge of the soil downstream of the system (in g cm^{3}).
#' @param Soil.TPConc.intial The initial total phosphorus concentration of soil prior to discharge downstream of the system (in mg kg^{-1}).
#' @param Vertical.soilTPGradient.intial The soil total phosphorus concentration gradient prior to dischage downstream of the system (in mg cm\^{-3} cm^{-1}).
#' @param Soil.BulkDensity.final The final bulk density after dischage of the soil downstream of the system (in g cm^{-3}).
#' @param PSettlingRate The phosphorus settling rate estimated from steady-state conditions (m Year^{-1}).
#' @param P.AtmoDep Phosphorus atmospheric depostition loading rate (in mg m^{-2} Year^{-1}).
#' @param Rainfall Annual accumulated rainfall estimate (m Year^{-1}).
#' @param ET Annual evapotranspiration estimate (m Year^{-1}).
#' @param Dist.Display Output display result for this distance
#' @param Yr.Display Output displays results for this time (years)
#' @param Max.Yrs Maximum number of years simulated
#' @param Max.Dist Maximum ditance plotted, default is 50 km
#' @param Dist.increment.km Distance increment modeled
#' @param plot.profile If \code{TRUE} base plot will be generate with water column distance, soil distance and cattail distance profiles.
#' @keywords "water quality"
#' @export
#' @return This function comuptes and plots the distance profile based on input values
#' @examples
#' EPGMProfile(case.no=11)
#'
#' EPGMProfile(NA,1991,38,526,15.3,50,10,0.05,257,-0.004,0.04,15.2,45,1.3,1.4)


EPGMProfile=function(case.no=NA,
Start.Discharge=NA,
STA.outflow.TPconc=NA,
STA.outflow.vol=NA,
FlowPath.width=NA,
Hydroperiod=NA,
Soil.Depth=NA,
Soil.BulkDensity.inital=NA,
Soil.TPConc.inital=NA,
Vertical.SoilTPGradient.inital=NA,
Soil.BulkDensity.final=NA,
PSettlingRate=NA,
P.AtmoDep=NA,
Rainfall=NA,
ET=NA,
Dist.Display=12,
Yr.Display=30,
Max.Yrs=200,
Max.Dist=15,
Dist.increment.km=0.1,
plot.profile=TRUE,
raw.output=FALSE
){

  ## Stop/warning section of the function
  input.val.na<-sum(c(is.na(Start.Discharge),is.na(STA.outflow.TPconc),is.na(STA.outflow.vol),is.na(FlowPath.width),
                     is.na(Hydroperiod),is.na(Soil.Depth),is.na(Soil.BulkDensity.inital),is.na(Soil.TPConc.inital),
                     is.na(Vertical.SoilTPGradient.inital),is.na(Soil.BulkDensity.final),is.na(PSettlingRate),
                     is.na(P.AtmoDep),is.na(ET)))

  if(is.na(case.no)==T & input.val.na>1){
    stop("Missing inputs, either input a 'case.no' or all individual model parameters.")
  }
  if(case.no>12){
    stop("'case.no' range from 1 to 12.")
  }
  if(Dist.increment.km>Max.Dist){
    stop("Distance increment is greater than the maximum gradient distance.")
  }

  ## Data handling
  if(is.na(case.no)==F){
    data(casedat)
    cases.dat=casedat}

  if(is.na(case.no)==T){
    start.year<-Start.Discharge
    outflow.c.ugL<-STA.outflow.TPconc
    outflow.q.kacft<-STA.outflow.vol
    path.width.km<-FlowPath.width
    hydroperiod.per<-Hydroperiod/100
    soil.z.cm<-Soil.Depth
    bd.i.gcc<-Soil.BulkDensity.inital
    soilP.i.mgkg<-Soil.TPConc.inital
    soilPgrad.i.mgcccm<-Vertical.SoilTPGradient.inital
    bd.f.gcc<-Soil.BulkDensity.final
    Psettle.myr<-PSettlingRate
    atmoP.mgm2yr<-P.AtmoDep
    RF.myr<-Rainfall
    ET.myr<-ET
  }else{
    start.year<-cases.dat[cases.dat$case.number==case.no,"Start.Discharge"]
    outflow.c.ugL<-cases.dat[cases.dat$case.number==case.no,"STA.outflow.TPconc"]
    outflow.q.kacft<-cases.dat[cases.dat$case.number==case.no,"STA.outflow.vol"]
    path.width.km<-cases.dat[cases.dat$case.number==case.no,"FlowPath.width"]
    hydroperiod.per<-cases.dat[cases.dat$case.number==case.no,"Hydroperiod"]/100
    soil.z.cm<-cases.dat[cases.dat$case.number==case.no,"Soil.Depth"]
    bd.i.gcc<-cases.dat[cases.dat$case.number==case.no,"Soil.BulkDensity.inital"]
    soilP.i.mgkg<-cases.dat[cases.dat$case.number==case.no,"Soil.TPConc.inital"]
    soilPgrad.i.mgcccm<-cases.dat[cases.dat$case.number==case.no,"Vertical.SoilTPGradient.inital"]
    bd.f.gcc<-cases.dat[cases.dat$case.number==case.no,"Soil.BulkDensity.final"]
    Psettle.myr<-cases.dat[cases.dat$case.number==case.no,"PSettlingRate"]
    atmoP.mgm2yr<-cases.dat[cases.dat$case.number==case.no,"P.AtmoDep"]
    RF.myr<-cases.dat[cases.dat$case.number==case.no,"Rainfall"]
    ET.myr<-cases.dat[cases.dat$case.number==case.no,"ET"]
  }

  ## Default values based on empirical studies
  SoilP_Accret.slope<-1.467
  SoilP_Accret.int<-462.8865
  spread.mgkg<-if(soil.z.cm==10){144.05071892624}else{727.675986572509}
  midpoint.mgkg<-if(soil.z.cm==10){1034.4142631602}else{71.2079211802927}

  maxdist.km<-min(c(50,Max.Dist),na.rm=T)

  ## Intermediate Calcs
  vol.soilP.mgcm3<-(soilP.i.mgkg*bd.i.gcc/1000)
  cattail.i.per<-1/(1+exp(-(soilP.i.mgkg-midpoint.mgkg)/spread.mgkg))*100

  b.myr<-RF.myr-ET.myr;
  Rinflow.myr<-Psettle.myr*hydroperiod.per+b.myr
  CbInflow.ugL<-atmoP.mgm2yr/Rinflow.myr
  Rss.myr<-Psettle.myr*hydroperiod.per+b.myr
  Cbss.ugL<-atmoP.mgm2yr/Rss.myr
  Chalf.ugL<-1
  Me.kgm2<-10*soil.z.cm*bd.f.gcc
  Mi.kgm2<-10*soil.z.cm*bd.i.gcc
  Xi.mgcm3<-soilP.i.mgkg*bd.i.gcc/1000
  TArea.km2<-path.width.km*maxdist.km
  CellArea.ha<-path.width.km*Dist.increment.km*100
  End.Yr<-Yr.Display+start.year-1

  HalfLife.settle.yrs<-0.1
  Ke.relax.perYr<-log(2)/HalfLife.settle.yrs
  Current.Ke<-Psettle.myr+(Psettle.myr-Psettle.myr)*exp(-Yr.Display*Ke.relax.perYr)
  aa<-Psettle.myr
  bb<-Psettle.myr-Psettle.myr
  CumAvg.Ke.myr<-(aa*Yr.Display+bb/Ke.relax.perYr*(1-exp(-Ke.relax.perYr*Yr.Display)))/Yr.Display

  ## Profile Calc
  dist.seq<-seq(0,maxdist.km,Dist.increment.km)
  area.seq<-dist.seq*path.width.km

  #Steady State
  q.seq<-b.myr*area.seq+outflow.q.kacft*43560*0.001/3.28^3
  TP.SS<-outflow.c.ugL

  for(i in 2:length(dist.seq)){
    TP.SS[i]<-Cbss.ugL+(TP.SS[i-1]-Cbss.ugL)*if(b.myr==0){exp(-Psettle.myr*hydroperiod.per*(area.seq[i]-area.seq[i-1])/q.seq[i])}else{(q.seq[i]/q.seq[i-1])^(-Rss.myr/b.myr)}
  }
  SoilP.SS<-SoilP_Accret.int+SoilP_Accret.slope*Psettle.myr*hydroperiod.per*TP.SS
  SSTime.yrs<-10*bd.f.gcc*soil.z.cm*SoilP.SS/(Psettle.myr*hydroperiod.per*TP.SS)
  cattail.per<-(1/(1+exp(-(SoilP.SS-midpoint.mgkg)/spread.mgkg)))*100

  #Current Time
  Ke.myr<-Psettle.myr
  R.myr<-Ke.myr*hydroperiod.per+b.myr
  Cb.ugL<-atmoP.mgm2yr/R.myr
  TP.Time.ugL<-outflow.c.ugL

  for(i in 2:length(dist.seq)){
    Ke.myr[i]<-Psettle.myr+max(c(0,(Ke.myr[i-1]-Psettle.myr)*(TP.Time.ugL[i-1]-Cbss.ugL+Chalf.ugL)))
    R.myr[i]<-Ke.myr[i]*hydroperiod.per+b.myr
    Cb.ugL[i]<-atmoP.mgm2yr/R.myr[i]
    TP.Time.ugL[i]<-Cb.ugL[i]+(TP.Time.ugL[i-1]-Cb.ugL[i])*if(b.myr==0){exp(-hydroperiod.per*Ke.myr[i]*(area.seq[i]-area.seq[i-1])/q.seq[i])}else{(q.seq[i]/q.seq[i-1])^(-R.myr[i]/b.myr)}
  }

  #Integration
  Ke.int.myr<-CumAvg.Ke.myr
  R.int.myr<-Ke.int.myr*hydroperiod.per+b.myr
  Cb.int.ugL<-atmoP.mgm2yr/R.int.myr
  TP.int.ugL<-outflow.c.ugL
  for(i in 2:length(dist.seq)){
    Ke.int.myr[i]<-Psettle.myr+max(c(0,(Ke.int.myr[i-1]-Psettle.myr)*(TP.int.ugL[i-1]-Cbss.ugL+Chalf.ugL)))
    R.int.myr[i]<-Ke.int.myr[i]*hydroperiod.per+b.myr
    Cb.int.ugL[i]<-atmoP.mgm2yr/R.int.myr[i]
    TP.int.ugL[i]<-Cb.int.ugL[i]+(TP.int.ugL[i-1]-Cb.int.ugL[i])*if(b.myr==0){exp(-hydroperiod.per*Ke.int.myr[i]*(area.seq[i]-area.seq[i-1])/q.seq[i])}else{(q.seq[i]/q.seq[i-1])^(-R.int.myr[i]/b.myr)}
  }
  P.accret.mgm2yr<-TP.int.ugL*hydroperiod.per*Ke.int.myr
  NewSoilP.mgkg<-SoilP_Accret.int*Ke.int.myr/Psettle.myr+SoilP_Accret.slope*P.accret.mgm2yr
  Soil.accret.kgm2yr<-P.accret.mgm2yr/NewSoilP.mgkg
  Soil.accret.cmyr<-Soil.accret.kgm2yr/(10*bd.f.gcc)
  NewSoil.z.cm<-pmin(soil.z.cm,c(soil.z.cm,Soil.accret.cmyr*Yr.Display))
  EquilTime.yrs<-soil.z.cm/Soil.accret.cmyr
  SoilMass.kgm2<-ifelse(Yr.Display<EquilTime.yrs,10*soil.z.cm*bd.i.gcc+Soil.accret.kgm2yr*(1-bd.i.gcc/bd.f.gcc)*Yr.Display,Me.kgm2)
  BulkDensity.gcc<-SoilMass.kgm2/10/soil.z.cm

  coef1<-P.accret.mgm2yr-10000*Soil.accret.cmyr*(vol.soilP.mgcm3+soilPgrad.i.mgcccm*soil.z.cm/2)
  coef2<-10000*Soil.accret.cmyr^2*soilPgrad.i.mgcccm/2
  Avg.SoilP.mgkg<-ifelse(Yr.Display>EquilTime.yrs,NewSoilP.mgkg,(Me.kgm2*soilP.i.mgkg+coef1*Yr.Display+coef2*Yr.Display^2)/SoilMass.kgm2)
  Avg.SoilP.mgcm3<-Avg.SoilP.mgkg*BulkDensity.gcc/1000
  B.SoilP.mgcm3<-pmax(0,c(ifelse(NewSoil.z.cm>=soil.z.cm,Avg.SoilP.mgcm3,vol.soilP.mgcm3-soilPgrad.i.mgcccm*(NewSoil.z.cm-soil.z.cm/2))))
  cattail.time.per<-1/(1+exp(-(Avg.SoilP.mgkg-midpoint.mgkg)/spread.mgkg))*100

  profile.dat<-data.frame(dist=dist.seq,
                          area=area.seq,
                          q.hm3yr=q.seq,
                          TP.SS.ugL=TP.SS,
                          SoilP.SS.mgkg=SoilP.SS,
                          SSTime.yrs=SSTime.yrs,
                          cattail.density.per=cattail.per,
                          Ke.myr=Ke.myr,
                          R.myr=R.myr,
                          Cb.ugL=Cb.ugL,
                          TP.Time.ugL=TP.Time.ugL,
                          Ke.int.myr=Ke.int.myr,
                          R.int.myr=R.int.myr,
                          Cb.int.ugL=Cb.int.ugL,
                          TP.int.ugL=TP.int.ugL,
                          Soil.accret.cmyr=Soil.accret.cmyr,
                          P.accret.mgm2yr=P.accret.mgm2yr,
                          NewSoilP.mgkg=NewSoilP.mgkg,
                          EquilTime.yrs=EquilTime.yrs,
                          SoilMass.kgm2=SoilMass.kgm2,
                          BulkDensity.gcc=BulkDensity.gcc,
                          Avg.SoilP.mgkg=Avg.SoilP.mgkg,
                          cattail.time.per=cattail.time.per)
  if(plot.profile==TRUE){
    #Graphs_Profile plots
    par(family="serif",mar=c(3.25,4,2,2),oma=c(1,1,1,1),mgp=c(2.25,0.5,0));
    layout(matrix(1:4,2,2))

    plot(TP.SS.ugL~dist,profile.dat,type="n",las=1,xlab="Distance (km)",ylab="Concentration (\u03BC g L\u207B\u00B9)",yaxs="i",xaxs="i",xlim=c(0,Max.Dist),ylim=c(0,ceiling(outflow.c.ugL+outflow.c.ugL*0.1)))
    lines(profile.dat$dist,profile.dat$TP.SS.ugL,col="forestgreen",lty=2,lwd=2)
    lines(profile.dat$dist,profile.dat$TP.Time.ugL,col="red",lty=1,lwd=2)
    lines(profile.dat$dist,profile.dat$Cb.int.ugL,col="black",lty=3)
    mtext(side=3,"Water Column Distance Profile")
    legend("topright",legend=c("Steady State",paste("Time =",Yr.Display,'Yrs'),"Initial"),
           pch=NA,lwd=c(2,2,1),lty=c(2,1,3),
           col=c("forestgreen","red","black"),
           pt.cex=1.25,ncol=1,bty="n",y.intersp=1,x.intersp=0.75,xpd=NA,xjust=0.5,yjust=0.5)

    plot(SoilP.SS.mgkg~dist,profile.dat,type="n",las=1,xlab="Distance (km)",ylab="Concentration (mg kg\u207B\u00B9)",yaxs="i",xaxs="i",xlim=c(0,Max.Dist),ylim=c(0,ceiling(max(SoilP.SS)+max(SoilP.SS)*0.1)))
    lines(profile.dat$dist,profile.dat$SoilP.SS.mgkg,col="red ",lty=2,lwd=2)
    lines(profile.dat$dist,profile.dat$Avg.SoilP.mgkg,col="red",lty=1,lwd=2)
    abline(h=soilP.i.mgkg,col="black",lty=3)
    mtext(side=3,"Soil Distance Profile")
    legend("topright",legend=c("Steady State",paste("Time =",Yr.Display,'Yrs'),"Initial"),
           pch=NA,lwd=c(2,2,1),lty=c(2,1,3),
           col=c("red","red","black"),
           pt.cex=1.25,ncol=1,bty="n",y.intersp=1,x.intersp=0.75,xpd=NA,xjust=0.5,yjust=0.5)

    plot(cattail.density.per~dist,profile.dat,type="n",las=1,xlab="Distance (km)",ylab="Cattail Density (%)",yaxs="i",xaxs="i",xlim=c(0,Max.Dist),ylim=c(0,105))
    lines(profile.dat$dist,profile.dat$cattail.density.per,lty=2,lwd=2)
    lines(profile.dat$dist,profile.dat$cattail.time.per,col="black",lty=1,lwd=2)
    abline(h=cattail.i.per,col="black",lty=3)
    mtext(side=3,"Cattail Density")
    legend("topright",legend=c("Steady State",paste("Time =",Yr.Display,'Yrs'),"Initial"),
           pch=NA,lwd=c(2,2,1),lty=c(2,1,3),
           col=c("black","black","black"),
           pt.cex=1.25,ncol=1,bty="n",y.intersp=1,x.intersp=0.75,xpd=NA,xjust=0.5,yjust=0.5)

    plot(0:1,0:1,axes=F,ylab=NA,xlab=NA,type="n")
    if(is.na(case.no)==F){
      text(0,0.5,paste("Case:",cases.dat[cases.dat$case.number==case.no,"case.number"],"\nSTA:",cases.dat[cases.dat$case.number==case.no,"STA.Name"],"\nRecieving Area:",cases.dat[cases.dat$case.number==case.no,"Receiving.Area"],"\nSoil Depth (cm):",cases.dat[cases.dat$case.number==case.no,"Soil.Depth"],"\nTime (Years):",Yr.Display,"\nStart Year:",cases.dat[cases.dat$case.number==case.no,"Start.Discharge"],"\nEnd Year:",End.Yr),adj=0)
    }

  }

  if(raw.output==TRUE){return(profile.dat)}
}
