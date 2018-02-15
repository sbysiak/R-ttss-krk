rm(list = ls())
library('lattice')
 library('latticeExtra')
  df<-load("ALL")
#clearing all from unnessesary columns
 ALL$X.2<-NULL
 ALL$X.1<-NULL
 ALL$X<-NULL

#print all arrivals mean delay
print(mean(ALL$Late))
ALL$Time <- as.POSIXct(ALL$Time, format("%Y-%m-%d %h:%m:%s"))
ALL_n<-ALL[order(ALL$Time),]
ALL_n<-ALL_n[ALL_n$Late>0,]
xyplot(Late ~ Time, ALL_n, xlab = "Time", ylab = "Late [min]")

#print summary about data without max and min value
v <- ALL_n[ALL_n$Late>1 & ALL_n$Late<88,]
summary(v$Late)

#prepare to make time sequence throughout all data
results <- 0
times <- 0
TMAX <- ALL_n$Time[length(ALL_n$Time)]
TMIN <- ALL_n$Time[1]
#time window
dt <- 3*60
t <-TMIN
t2 <- t + dt
df<-NULL
while(t2<(TMAX-dt))
{
  ALL_n[ALL_n$Time>t && ALL_n$Time<t2 ,]
  results <- append(results, mean(ALL_n[ALL_n$Time>=t & ALL_n$Time<t2 ,"Late"]))
  times <- append(times, t)
  t<-t2
  t2 <- t2 + dt
}

#dealing with time in order to make nice plot
times <- as.POSIXct(times,  format("%Y-%m-%d %h:%m:%s"), origin="1969-12-31 23:00:00")
TMIN <- as.POSIXct(TMIN, tz = "CET")
time_and_late <- data.frame(times[2:length(times)], results[2:length(results)])
names(time_and_late) <- c("times","results")

#since it is processed some NAs may occur
time_and_late[is.na(time_and_late)] <- 0

#plot & save
 my.theme <- theEconomist.theme()
 myplot <- xyplot(results ~times, time_and_late, type = "l", par.settings = my.theme, 
       xlab = "Time", 
       scales=list( x=list(cex = 1, rot = 45, tick.number = 20)),
       ylab = "Average delay in 3 minutes interval [min]",
       panel =function(x,y,...){ 
         panel.xyplot(x,y,...);
         panel.lines(x=TMIN:TMAX, y=rep(1,100), col="red") }
       )

trellis.device(device="png", filename="time_series_delayed.png")
print(myplot)
dev.off()