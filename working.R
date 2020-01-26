
library(EPGMr)

casedat[11,]

Max.Yrs=200
Max.Dist=15
Time.increment.yr=5
Start.Discharge=1962
path.width.km=10.5
Dist.increment.km=0.1


time.dat=EPGMTime(case.no=11,raw.time.output=T)
head(time.dat)

dev.off()


##
Time.increment.yr=5
Start.Discharge=1962
path.width.km=10.5
Dist.increment.km=0.1

###
Time.increment.yr=diff(unique(time.dat$time.step))[1]
Max.Dist=max(time.dat$dist)
Dist.increment.km=diff(unique(time.dat$dist))[1]
path.width.km=max(time.dat$area)/max(time.dat$dist)
start.year=min(time.dat$Year)+1
Max.Yrs=max(time.dat$time.step)

cell.area=path.width.km*Dist.increment.km
total.area=Max.Dist*path.width.km
wghts<-ifelse(time.dat$dist==0|time.dat$dist==Max.Dist,0.5,1)

WaterColumn.Thresholds=c(10,15,20)
WCthres.1<-WaterColumn.Thresholds[1]
WCthres.2<-WaterColumn.Thresholds[2]
WCthres.3<-WaterColumn.Thresholds[3]

WCthres.1.exceed<-aggregate(ifelse(time.dat$TP.Time.ugL>WCthres.1,1,0)*wghts,by=list(time.dat$time.step),"sum")*Dist.increment.km
WCthres.1.exceed.km<-(WCthres.1.exceed[,2]*path.width.km)
WCthres.2.exceed<-aggregate(ifelse(time.dat$TP.Time.ugL>WCthres.2,1,0)*wghts,by=list(time.dat$time.step),"sum")*Dist.increment.km
WCthres.2.exceed.km<-(WCthres.2.exceed[,2]*path.width.km)
WCthres.3.exceed<-aggregate(ifelse(time.dat$TP.Time.ugL>WCthres.3,1,0)*wghts,by=list(time.dat$time.step),"sum")*Dist.increment.km
WCthres.3.exceed.km<-(WCthres.3.exceed[,2]*path.width.km)

Soil.Thresholds=c(500,600,1000)
Soilthres.1<-Soil.Thresholds[1]
Soilthres.2<-Soil.Thresholds[2]
Soilthres.3<-Soil.Thresholds[3]

soilthres.1.exceed<-aggregate(ifelse(time.dat$Avg.SoilP.mgkg>Soilthres.1,1,0)*wghts,by=list(time.dat$time.step),"sum")
soilthres.1.exceed.km<-(soilthres.1.exceed[,2]*Dist.increment.km)*path.width.km
soilthres.2.exceed<-aggregate(ifelse(time.dat$Avg.SoilP.mgkg>Soilthres.2,1,0)*wghts,by=list(time.dat$time.step),"sum")
soilthres.2.exceed.km<-(soilthres.2.exceed[,2]*Dist.increment.km)*path.width.km
soilthres.3.exceed<-aggregate(ifelse(time.dat$Avg.SoilP.mgkg>Soilthres.3,1,0)*wghts,by=list(time.dat$time.step),"sum")
soilthres.3.exceed.km<-(soilthres.3.exceed[,2]*Dist.increment.km)*path.width.km

cattail.Thresholds=c(5,20,90)
cattailthres.1<-cattail.Thresholds[1]
cattailthres.2<-cattail.Thresholds[2]
cattailthres.3<-cattail.Thresholds[3]

cattailthres.1.exceed<-aggregate(ifelse(time.dat$cattail.time.per>cattailthres.1,1,0)*wghts,by=list(time.dat$time.step),"sum")[,2]*cell.area
cattailthres.2.exceed<-aggregate(ifelse(time.dat$cattail.time.per>cattailthres.2,1,0)*wghts,by=list(time.dat$time.step),"sum")[,2]*cell.area
cattailthres.3.exceed<-aggregate(ifelse(time.dat$cattail.time.per>cattailthres.3,1,0)*wghts,by=list(time.dat$time.step),"sum")[,2]*cell.area

#output table
tmp<-cbind(WCthres.1.exceed.km,WCthres.2.exceed.km,WCthres.3.exceed.km,
           soilthres.1.exceed.km,soilthres.2.exceed.km,soilthres.3.exceed.km,
           cattailthres.1.exceed,cattailthres.2.exceed,cattailthres.3.exceed)
colnames(tmp)<-c(paste0("WC.",WaterColumn.Thresholds),paste0("Soil.",Soil.Thresholds),paste0("Cattail.",cattail.Thresholds))

areas.table<-cbind(data.frame(Time.Yrs=unique(time.dat$time.step),Year=unique(time.dat$Year)),tmp)

#report table
rpt.time.step<-if(Time.increment.yr==1){c(0,1,2,3,10,15,20,25,200)}else{c(seq(0,Max.Yrs,Time.increment.yr)[1:8],Max.Yrs)}


threshold.summary=data.frame(Thresholds=c("Water Column (ug/L)","Soil (mg/kg)","Cattail Density (%)"),
           Value1=c(WaterColumn.Thresholds[1],Soil.Thresholds[1],cattail.Thresholds[1]),
           Value2=c(WaterColumn.Thresholds[2],Soil.Thresholds[2],cattail.Thresholds[2]),
           Value3=c(WaterColumn.Thresholds[3],Soil.Thresholds[3],cattail.Thresholds[3]))



#watercolumn
wc.area.summary=cbind(data.frame(Time.Step=rpt.time.step,Year=(start.year+rpt.time.step)-1),
                      areas.table[areas.table$Time.Yrs%in%rpt.time.step,c(paste0("WC.",WaterColumn.Thresholds))])
#Soil
soil.area.summary=cbind(data.frame(Time.Step=rpt.time.step,Year=(start.year+rpt.time.step)-1),
                      areas.table[areas.table$Time.Yrs%in%rpt.time.step,c(paste0("Soil.",Soil.Thresholds))])
#Cattail
cattail.area.summary=cbind(data.frame(Time.Step=rpt.time.step,Year=(start.year+rpt.time.step)-1),
                        areas.table[areas.table$Time.Yrs%in%rpt.time.step,c(paste0("Cattail.",cattail.Thresholds))])

out.sum<-list("Thresholds" = threshold.summary,
              "WaterColumn"=wc.area.summary,
              "Soil"= soil.area.summary,
              "Cattail"=cattail.area.summary)


##plot
#if(plot.profile==TRUE){
  #Graphs_Profile plots
cols<-colorRampPalette(c("#3B9AB2", "#78B7C5", "#EBCC2A", "#E1AF00", "#F21A00"))(3)
  par(family="serif",mar=c(1.75,4,2,2),oma=c(2,1,1,1),mgp=c(2.25,0.5,0));
  layout(matrix(1:6,3,2,byrow=T),widths=c(1,0.5))

  plot(areas.table[,c(paste0("WC.",WaterColumn.Thresholds[1]))]~Time.Yrs,areas.table,type="n",las=1,xlab=NA,ylab=NA,yaxs="i",xaxs="i",xlim=c(0,Max.Yrs),ylim=c(0,ceiling(total.area+total.area*0.1)))
  lines(areas.table$Time.Yrs,areas.table[,c(paste0("WC.",WaterColumn.Thresholds[1]))],col=cols[1],lwd=2)
  lines(areas.table$Time.Yrs,areas.table[,c(paste0("WC.",WaterColumn.Thresholds[2]))],col=cols[2],lwd=2)
  lines(areas.table$Time.Yrs,areas.table[,c(paste0("WC.",WaterColumn.Thresholds[3]))],col=cols[3],lwd=2)
  mtext(side=3,"Water Column")
  plot(0:1,0:1,type="n",axes=F,ylab=NA,xlab=NA)
  legend(0.5,0.5,legend=c(paste(WaterColumn.Thresholds,"\u03BCg/L")),
         pch=NA,lwd=c(2),lty=c(1),
         col=cols,cex=1,
         pt.cex=1.25,ncol=1,bty="n",y.intersp=1,x.intersp=0.75,xpd=NA,xjust=0.5,yjust=0.5,title="Water Column TP Thresholds",title.adj = 0)
  plot(areas.table[,c(paste0("Soil.",Soil.Thresholds[1]))]~Time.Yrs,areas.table,type="n",las=1,xlab=NA,ylab=NA,yaxs="i",xaxs="i",xlim=c(0,Max.Yrs),ylim=c(0,ceiling(total.area+total.area*0.1)))
  lines(areas.table$Time.Yrs,areas.table[,c(paste0("Soil.",Soil.Thresholds[1]))],col=cols[1],lwd=2)
  lines(areas.table$Time.Yrs,areas.table[,c(paste0("Soil.",Soil.Thresholds[2]))],col=cols[2],lwd=2)
  lines(areas.table$Time.Yrs,areas.table[,c(paste0("Soil.",Soil.Thresholds[3]))],col=cols[3],lwd=2)
  mtext(side=3,"Soil")
  mtext(side=2,line=2.5,"Area Exceeded (km\u00B2)")
  plot(0:1,0:1,type="n",axes=F,ylab=NA,xlab=NA)
  legend(0.5,0.5,legend=c(paste(Soil.Thresholds,"mg/kg")),
         pch=NA,lwd=c(2),lty=c(1),
         col=cols,cex=1,
         pt.cex=1.25,ncol=1,bty="n",y.intersp=1,x.intersp=0.75,xpd=NA,xjust=0.5,yjust=0.5,title="Soil TP Thresholds",title.adj = 0)

  plot(areas.table[,c(paste0("Cattail.",cattail.Thresholds[1]))]~Time.Yrs,areas.table,type="n",las=1,xlab=NA,ylab=NA,yaxs="i",xaxs="i",xlim=c(0,Max.Yrs),ylim=c(0,ceiling(total.area+total.area*0.1)))
  lines(areas.table$Time.Yrs,areas.table[,c(paste0("Cattail.",cattail.Thresholds[1]))],col=cols[1],lwd=2)
  lines(areas.table$Time.Yrs,areas.table[,c(paste0("Cattail.",cattail.Thresholds[2]))],col=cols[2],lwd=2)
  lines(areas.table$Time.Yrs,areas.table[,c(paste0("Cattail.",cattail.Thresholds[3]))],col=cols[3],lwd=2)
  mtext(side=3,"Cattail Density")
  mtext(side=1,line=2,"Time (Years)")
  plot(0:1,0:1,type="n",axes=F,ylab=NA,xlab=NA)
  legend(0.5,0.5,legend=c(paste(cattail.Thresholds,"%")),
         pch=NA,lwd=c(2),lty=c(1),
         col=cols,cex=1,
         pt.cex=1.25,ncol=1,bty="n",y.intersp=1,x.intersp=0.75,xpd=NA,xjust=0.5,yjust=0.5,title="Cattail Density Thresholds",title.adj = 0)

##















soil.ss.time<-aggregate(time.dat$SoilP.SS.mgkg*wghts*(cell.area/total.area),by=list(time.dat$time.step),"sum")
BD<-aggregate(time.dat$BulkDensity.gcc*wghts*(cell.area/total.area),by=list(time.dat$time.step),"sum")
avg.vol.soilP<-aggregate((time.dat$Avg.SoilP.mgkg*time.dat$BulkDensity.gcc/1000)*wghts*(cell.area/total.area),by=list(time.dat$time.step),"sum")
avg.soilP<-data.frame(Group.1=avg.vol.soilP[,1],x=avg.vol.soilP[,2]/BD[,2]*1000)
cattail.ha<-aggregate(time.dat$cattail.time.per*wghts*cell.area,by=list(time.dat$time.step),"sum")
time.val<-time.dat$time.step

rpt.time.step<-if(Time.increment.yr==1){c(0,1,2,3,10,15,20,25,200)}else{c(seq(0,Max.Yrs,Time.increment.yr)[1:8],Max.Yrs)}

Start.Discharge+time[i]




# Simulation information
sim.zone<-data.frame(Parameter=c("Distance.km","Width.km","Area.km2","STA.outflow.volume.kAcftyr","Hydroperiod.pct","Soil.Depth.cm","P.Settle.Rate.myr","STA.outflow.Conc.ugL","STA.outflow.Load.mtyr"),
                     Value=c(Max.Dist,
                             path.width.km,
                             total.area,
                             outflow.q.kacft,
                             hydroperiod.per*100,
                             soil.z.cm,
                             Psettle.myr,
                             outflow.c.ugL,
                             round((outflow.q.kacft*43560*0.001/3.28^3)*outflow.c.ugL/1000,1)))

#Time series summary
TimeProfile.summary=data.frame(Time.Step=rpt.time.step,
                               Year=(Start.Discharge+rpt.time.step)-1,
                               SoilP.mgkg=round(avg.soilP[avg.soilP$Group.1%in%rpt.time.step,2],0),
                               CattailDensity.ha=round(cattail.ha[cattail.ha$Group.1%in%rpt.time.step,2],0))



out.time.sum<-list("Time.yrs" = Max.Yrs, "Time.increment.yrs"=Time.increment.yr,
              "Simulated.Zone"= TimeProfile.summary,
              "TimeProfile"=DistanceProfile)
