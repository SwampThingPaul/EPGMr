#' Time Profile
#'
#' This function runs the EPGM model over a simulated period. The model is based primarily upon data collected in the early 1990's along the phosphorus gradient in WCA-2A. Substantial additional data collected since then in WCA-2A and other locations indicate a need to recalibrate the model and potentially revise its structure. Recent data suggest, for example, that the relationship between cattail density and soil P needs recalibration and that actual soil P thresholds for biological impacts are probably lower than reflected in the original calibrations.  There are also issues relating to interpretation of and potential anomalies in the historical soil P calibration data attributed to variations in soil core collection method and definition of the soil/water interface (inclusion vs. exclusion of floc layer). There are also indications in the recent data of biologically-mediated vertical transport and/or mixing that are not reflected in the current model structure.
#'
#' As described in the original documentation, the model is designed to simulate marsh enrichment (responses to increasing P load), not recovery (responses to decreasing in load).
#'
#'
#' @param case.no Case number from the pre-loaded example data (values ranges from 1 to 12)
#' @param Start.Discharge The year of discharge started
#' @param Start.Discharge The year which this particular STA began discharge operations.
#' @param STA.outflow.TPconc Outflow total phosphorus concentration (in ug L\^{-1}) for this STA.
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
#' @param Dist.slice A list of distances to disply parameters in a time series plot if \code{plot.profile} is \code{TRUE}.
#' @param Max.Yrs Maximum number of years simulated
#' @param Max.Dist Maximum ditance plotted, default is 50 km
#' @param Time.increment.yr Year increment to be modeled
#' @param Dist.increment.km Distance increment modeled
#' @param plot.profile If \code{TRUE} base plot will be generate with water column distance, soil distance and cattail distance profiles.
#' @param raw.output If \code{TRUE} a \code{data.frame} will be printed with all calculations used to estimate various parameters.Default is set to \code{FALSE}.
#' @keywords "water quality"
#' @export
#' @return This function computes and plots the distance profile along the gradient based on input values
#' @examples
#' EPGMTime(case.no=11)

EPGMTime=function(case.no=NA,
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
                  Dist.slice=c(0,0.5,1,2,5,10),
                  Max.Yrs=200,
                  Max.Dist=15,
                  Time.increment.yr=5,
                  Dist.increment.km=0.1,
                  plot.profile=TRUE,
                  raw.output=FALSE

){

  ## Stop/warning section of the function
  input.val.na<-sum(c(is.na(Start.Discharge),is.na(STA.outflow.TPconc),is.na(STA.outflow.vol),is.na(FlowPath.width),
                      is.na(Hydroperiod),is.na(Soil.Depth),is.na(Soil.BulkDensity.inital),is.na(Soil.TPConc.inital),
                      is.na(Vertical.SoilTPGradient.inital),is.na(Soil.BulkDensity.final),is.na(PSettlingRate),
                      is.na(P.AtmoDep),is.na(ET)))
  if(is.na(case.no)==TRUE & input.val.na>1){
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
    cases.dat<-casedat}

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

  time<-seq(0,Max.Yrs,Time.increment.yr)
  time<-time[time<=Max.Yrs]

  Dist.slice<-c(Dist.slice,Max.Dist)

  time.dat<-data.frame()
  for(i in 1:length(time)){
    if(is.na(case.no)==T){tmp<-EPGMProfile(Start.Discharge=start.year,
                                           STA.outflow.TPconc=outflow.c.ugL,
                                           STA.outflow.vol=outflow.q.kacft,
                                           FlowPath.width=path.width.km,
                                           Hydroperiod=hydroperiod.per,
                                           Soil.Depth=soil.z.cm,
                                           Soil.BulkDensity.inital=bd.i.gcc,
                                           Soil.TPConc.inital=soilP.i.mgkg,
                                           Vertical.SoilTPGradient.inital=soilPgrad.i.mgcccm,
                                           Soil.BulkDensity.final=bd.f.gcc,
                                           PSettlingRate=Psettle.myr,
                                           P.AtmoDep=atmoP.mgm2yr,
                                           Rainfall=RF.myr,
                                           ET=ET.myr,
                                           raw.output=T,results.table=F,plot.profile = F,Yr.Display =time[i])}
    else{tmp<-EPGMProfile(case.no=case.no,raw.output=T,results.table=F,plot.profile = F,Yr.Display =time[i])}
    tmp$time.step<-time[i]
    tmp$Year<-Start.Discharge+time[i]
    time.dat<-rbind(tmp,time.dat)
  }
  time.dat<-time.dat[order(time.dat$time.step,time.dat$dist),]

  #wghts<-ifelse(time.dat$dist==0|time.dat$dist==maxdist.km,0.5,1)
  #cattail.flowpath<-aggregate(time.dat$cattail.time.per*wghts*(path.width.km*Dist.increment.km),by=list(time.dat$time.step),"sum")
  #Commented out may include in future iterations.

  if(plot.profile==TRUE){
    #Graphs_Profile plots
    par(family="serif",mar=c(1.75,4,2,2),oma=c(1,1,1,1),mgp=c(2.5,0.5,0));
    layout(matrix(1:6,2,3,byrow=T),widths=c(1,0.4,1))
    time.dat.plot<-time.dat[time.dat$dist==Dist.Display,]
    plot(Avg.SoilP.mgkg~time.step,time.dat.plot,type="n",las=1,xlab=NA,ylab="Concentration (mg kg\u207B\u00B9)",yaxs="i",xaxs="i",xlim=c(0,Max.Yrs),ylim=c(0,ceiling(max(time.dat.plot$Avg.SoilP.mgkg)+max(time.dat.plot$Avg.SoilP.mgkg)*0.1)))
    lines(time.dat.plot$time.step,time.dat.plot$Avg.SoilP.mgkg,col="black",lty=1,lwd=2)
    lines(time.dat.plot$time.step,time.dat.plot$SoilP.SS.mgkg,col="black",lty=2,lwd=1)
    mtext(side=3,"Soil Phosphorus")
    plot(0:1,0:1,type="n",axes=F,ylab=NA,xlab=NA)
    legend(0.5,0.85,legend=c("Integrated","Steady State"),
           pch=NA,lwd=c(2,1),lty=c(1,2),
           col=c("black"),cex=0.8,
           pt.cex=1.25,ncol=1,bty="n",y.intersp=1,x.intersp=0.75,xpd=NA,xjust=0.5,yjust=0.5,title=paste("Soil Z:",soil.z.cm,"cm\n Distance:",Dist.Display,"km"),title.adj = 0)
    cols<-colorRampPalette(c("#3B9AB2", "#78B7C5", "#EBCC2A", "#E1AF00", "#F21A00"))(length(Dist.slice))
    legend(0.5,0.5,legend=c(paste("Distance:",format(Dist.slice),"km")),
           pch=NA,lwd=c(2),lty=c(1),
           col=cols,cex=0.8,
           ncol=1,bty="n",y.intersp=1,x.intersp=0.75,xpd=NA,xjust=0.5,yjust=0.5,title=paste("Soil Z:",soil.z.cm,"cm"),title.adj = 0)
    time.dat.plot2<-time.dat[time.dat$dist%in%Dist.slice,]
    plot(Avg.SoilP.mgkg~time.step,time.dat.plot,type="n",las=1,xlab=NA,ylab=NA,yaxs="i",xaxs="i",xlim=c(0,Max.Yrs),ylim=c(0,ceiling(max(time.dat.plot2$Avg.SoilP.mgkg)+max(time.dat.plot2$Avg.SoilP.mgkg)*0.1)))
    for(i in 1:length(Dist.slice)){
      with(time.dat.plot2[time.dat.plot2$dist==Dist.slice[i],],lines(time.step,Avg.SoilP.mgkg,lwd=2,col=cols[i]))
    }
    mtext(side=3,"Soil Phosphorus")

    plot(cattail.time.per~time.step,time.dat.plot,type="n",las=1,xlab=NA,ylab="Cattail Density (% Area)",yaxs="i",xaxs="i",xlim=c(0,Max.Yrs),ylim=c(0,105))
    lines(time.dat.plot$time.step,time.dat.plot$cattail.time.per,col="black",lty=1,lwd=2)
    lines(time.dat.plot$time.step,time.dat.plot$cattail.density.SS.per,col="black",lty=2,lwd=1)
    mtext(side=3,"Cattail Density")
    mtext(side=1,line=1.5,"Time (Yrs)")
    plot(0:1,0:1,type="n",axes=F,ylab=NA,xlab=NA)
    legend(0.5,0.85,legend=c("Integrated","Steady State"),
           pch=NA,lwd=c(2,1),lty=c(1,2),
           col=c("black"),cex=0.8,
           pt.cex=1.25,ncol=1,bty="n",y.intersp=1,x.intersp=0.75,xpd=NA,xjust=0.5,yjust=0.5,title=paste("Cattail Density\n Distance:",Dist.Display,"km"),title.adj = 0)
    legend(0.5,0.5,legend=c(paste("Distance:",format(Dist.slice),"km")),
           pch=NA,lwd=c(2),lty=c(1),
           col=cols,cex=0.8,
           ncol=1,bty="n",y.intersp=1,x.intersp=0.75,xpd=NA,xjust=0.5,yjust=0.5,title="Cattail Density",title.adj = 0)
    if(is.na(case.no)==F){
      text(x=-1,y=0,paste("Case:",cases.dat[cases.dat$case.number==case.no,"case.number"],"\nSTA:",cases.dat[cases.dat$case.number==case.no,"STA.Name"],"\nRecieving Area:",cases.dat[cases.dat$case.number==case.no,"Receiving.Area"],"\nSoil Depth (cm):",cases.dat[cases.dat$case.number==case.no,"Soil.Depth"],"\nStart Year:",cases.dat[cases.dat$case.number==case.no,"Start.Discharge"]),adj=0,xpd=NA,cex=0.85)
    }

    time.dat.plot2<-time.dat[time.dat$dist%in%Dist.slice,]
    plot(cattail.time.per~time.step,time.dat.plot,type="n",las=1,xlab=NA,ylab=NA,yaxs="i",xaxs="i",xlim=c(0,Max.Yrs),ylim=c(0,105))
    for(i in 1:length(Dist.slice)){
      with(time.dat.plot2[time.dat.plot2$dist==Dist.slice[i],],lines(time.step,cattail.time.per,lwd=2,col=cols[i]))
    }
    mtext(side=3,"Cattail Density")
    mtext(side=1,line=1.5,"Time (Yrs)")

  }
}
