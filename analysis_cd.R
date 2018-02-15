#this file will return summary of data (means, stdevs, etc)
rm(list = ls())
library('lattice')
df<-load("ALL")
ALL$X.2<-NULL
ALL$X.1<-NULL
ALL$X<-NULL
#mean late of all measured arrivals
print(mean(ALL$Late))
#formatting time
ALL$Time <- as.POSIXct(ALL$Time, format("%Y-%m-%d %h:%m:%s"))
ALL_n<-ALL[order(ALL$Time),]
# ALL_n<-ALL_n[ALL_n$Late>0,]
lines <- unique(ALL_n$Line)
mins <- NULL
maxs <- NULL
medians <-NULL
firstqs <- NULL
thirdqs <- NULL
stdevs <- NULL
means <- NULL
for(i in lines)
{
  #analyzing data for line
  v <- ALL_n$Late[ALL_n$Line==i]
  mins <- append(mins, min(v))
  maxs <- append(maxs, max(v))
  medians <- append(medians, median(v))
  firstqs <- append(firstqs, quantile(v,0.25))
  thirdqs <- append(thirdqs, quantile(v,0.75))
  stdevs <- append(stdevs, sd(v))
  means <- append(means, mean(v))
}

#data frame with mins, maxes, medians, quantiles, means and stdevs for lines 
lines_lates <- data.frame(lines,mins,firstqs,medians,means,thirdqs,maxs,stdevs)

stops <- unique(ALL_n$StopName)
mins <- NULL
maxs <- NULL
medians <-NULL
firstqs <- NULL
thirdqs <- NULL
stdevs <- NULL
means <- NULL
for(i in stops)
{
  #analyzing data for stops
  v <- ALL_n$Late[ALL_n$StopName==i]
  mins <- append(mins, min(v))
  maxs <- append(maxs, max(v))
  medians <- append(medians, median(v))
  firstqs <- append(firstqs, quantile(v,0.25))
  thirdqs <- append(thirdqs, quantile(v,0.75))
  stdevs <- append(stdevs, sd(v))
  means <- append(means, mean(v))
}

#data frame with mins, maxes, medians, quantiles, means and stdevs for lines 
stop_lates <- data.frame(stops,mins,firstqs,medians,means,thirdqs,maxs,stdevs)