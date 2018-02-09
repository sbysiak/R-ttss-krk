 rm(list = ls())
library('lattice')
 df<-load("ALL")
 ALL$X.2<-NULL
 ALL$X.1<-NULL
 ALL$X<-NULL

print(mean(ALL$Late))
ALL$Time <- as.POSIXct(ALL$Time, format("%Y-%m-%d %h:%m:%s"))
ALL_n<-ALL[order(ALL$Time),]
ALL_n<-ALL_n[ALL_n$Late>0,]
xyplot(Late ~ Time, ALL_n, xlab = "Time", ylab = "Late [min]")

v <- ALL_n[ALL_n$Late>1 & ALL_n$Late<88,]
summary(v$Late)

results <- 0
times <- 0
TMAX <- ALL_n$Time[length(ALL_n$Time)]
TMIN <- ALL_n$Time[1]
dt <- 3*60
t <-TMIN
t2 <- t + dt
df<-NULL
while(t2<(TMAX-dt))
{
  ALL_n[ALL_n$Time>t && ALL_n$Time<t2 ,]
  results <- append(results, mean(ALL_n[ALL_n$Time>=t & ALL_n$Time<t2 ,"Late"]))
  times <- append(times, mean(ALL_n[ALL_n$Time>=t & ALL_n$Time<t2 ,"Time"]))
  t<-t2
  t2 <- t2 + dt
}

times <- as.POSIXct(times,  origin="1969-12-31 23:00:00", tz = "CET")
TMIN <- as.POSIXct(TMIN, tz = "CET")
time_and_late <- data.frame(times, results)
time_and_late <- time_and_late[complete.cases(time_and_late$times),]
time_and_late <- time_and_late[time_and_late$times>TMIN,]


my.theme <- theEconomist.theme()
myplot <- xyplot(results ~times, time_and_late, type = "l", par.settings = my.theme, 
       xlab = "Time", 
       ylab = "Average delay in 3 minutes interval [min]",
       panel =function(x,y,...){ 
         panel.xyplot(x,y,...);
         panel.lines(x=TMIN:TMAX, y=rep(1,100), col="red") })

trellis.device(device="png", filename="myplot2.png")
print(myplot)
dev.off()