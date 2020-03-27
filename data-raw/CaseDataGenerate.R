
## Internal data
## Example data provided with the original Everglades Phosphorus Gradient Model
## see http://www.wwwalker.net/epgm/ for more detail.

#dir.create("data/")
#dir.create("data-raw/")

casedat<-data.frame(case.number=1:12,
                      STA.Name=c("STA2","STA34","STA5","STA6","STA2",'STA34',"STA5","STA6","STA2GDR","STA2GDR","S10s","S10s"),
                      Receiving.Area=c("NW 2A","NE 3A","Rotenb","NW 3A","NW 2A","NE 3A","Rotenb","NW 3A","NW 2A","NW 2A","NE 2A","NE 2A"),
                      Start.Discharge=c(1999,2003,1999,1999,1999,2003,1999,1999,1999,1999,1962,1962),
                      STA.outflow.TPconc=c(50,50,100,50,50,50,50,50,40,40,122,122),
                      STA.outflow.vol=c(205.8,422.0,60.0,64.4,205.8,422.0,30.7,64.4,246.7,246.7,281.3,281.3),
                      FlowPath.width=c(12.1,14.2,3,6,12.1,14.2,3,6,12.1,12.1,10.5,10.5),
                      Hydroperiod=c(90,88,69,61,92,88,69,61,92,92,91.4,91.4),
                      Soil.Depth=c(10,10,10,10,20,20,20,20,10,20,10,20),
                      Soil.BulkDensity.initial=c(0.080,0.179,0.197,0.222,0.071,0.176,0.197,0.232,0.080,0.071,0.102,0.102),
                      Soil.TPConc.initial=c(500,463,508,467,366,358,376,330,442,366,198,198),
                      Vertical.SoilTPGradient.initial=c(-0.0018,-0.0039,-0.0052,-0.0054,-0.0018,-0.0039,-0.0052,-0.0054,-0.0018,-0.0018,-0.0018,-0.0018),
                      Soil.BulkDensity.final=c(0.08,0.08,0.08,0.08,0.08,0.08,0.08,0.08,0.08,0.08,0.08,0.08),
                      PSettlingRate=c(10.2,10.2,10.2,10.2,10.2,10.2,10.2,10.2,10.2,10.2,10.2,10.2),
                      P.AtmoDep=c(42.9,42.9,42.9,42.9,42.9,42.9,42.9,42.9,42.9,42.9,42.9,42.9),
                      Rainfall=c(1.23,1.23,1.23,1.23,1.23,1.23,1.23,1.23,1.23,1.23,1.16,1.16),
                      ET=c(1.38,1.38,1.38,1.38,1.38,1.38,1.38,1.38,1.38,1.38,1.38,1.38))

usethis::use_data(casedat,internal=F,overwrite=T)
