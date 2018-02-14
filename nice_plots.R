# rm(list = ls())
# library('lattice')
# library('ggplot2')
# library(latticeExtra)
# 
# df<-load("ALL")
# ALL$X.2<-NULL
# ALL$X.1<-NULL
# ALL$X<-NULL
# 
# ALL$Time <- as.POSIXct(ALL$Time, format("%Y-%m-%d %h:%m:%s"))
# ALL<-ALL[order(ALL$Time),]
# 
# # ALL_n<-ALL_n[ALL_n$Late>0,]
# lines <- unique(ALL$Line)
# stops <- unique(ALL$StopName)
# directions <- unique(ALL$Direction)

order_data_set <- function(ALL = NULL)
{
  if(is.null(ALL))
    print('provide dataset!')
  
  ALL$X.2<-NULL
  ALL$X.1<-NULL
  ALL$X<-NULL
  
  ALL$Time <- as.POSIXct(ALL$Time, format("%Y-%m-%d %h:%m:%s"))
  ALL<-ALL[order(ALL$Time),]
}



time_and_late_sequence <- function(ALL_n,TMIN,TMAX,dt = 3*60)
{
  Late <- 0
  Time <- 0
  t <-TMIN
  t2 <- t + dt
  df<-NULL
  while(t2<(TMAX-dt))
  {
    ALL_n[ALL_n$Time>t && ALL_n$Time<t2 ,]
    Late <- append(Late, mean(ALL_n[ALL_n$Time>=t & ALL_n$Time<t2 ,"Late"]))
    Time <- append(Time, t)
    t<-t2
    t2 <- t2 + dt
  }
  
   Time <- as.POSIXct(Time,  format("%Y-%m-%d %h:%m:%s"), origin="1969-12-31 23:00:00" )
  time_and_late <- data.frame(Time, Late)
  time_and_late[is.na(time_and_late)] <- 0
  return(time_and_late)
  
}

delays_and_correlations <- function(ALL = ALL, line = 50, direction = 'KrowodrzaGorka',
                                    date1 = as.POSIXct("2018-02-06 00:00:00", format("%Y-%m-%d %h:%m:%s")),
                                    date2 = as.POSIXct("2018-02-06 23:59:59", format("%Y-%m-%d %h:%m:%s")),
                                    color = "black")
  {

ALL <- order_data_set(ALL)
stop_plot <- ALL[ALL$Direction == direction,]
stop_plot <- stop_plot[stop_plot$Line == line,]
stop_plot <- stop_plot[stop_plot$Time>date1 & stop_plot$Time<date2 ,]
route <- unique(stop_plot$StopName)

stop_plot$StopName<-as.character(stop_plot$StopName)
stop_plot$StopName<-as.factor(stop_plot$StopName)
levels(stop_plot$StopName) <- as.character(route)
route<-as.character(route)
levels(route)<-route

my.theme <- theEconomist.theme()
myplot <- xyplot(Late ~ Time | StopName, stop_plot, type = "p", par.settings = my.theme, 
                 xlab = "Time", 
                 ylab = paste0(line," in direction ",direction),
                 panel =function(x,y,...){ 
                   panel.xyplot(x,y,...);
                   panel.lines(x=date1:date2, y=rep(1,100), col="red") })


Times <- vector(mode = 'numeric')
Late <- vector()
StopName <-vector()
cor_stop<- time_and_late_sequence(ALL_n =  stop_plot[stop_plot$StopName ==  route[1],],
                                  TMIN = date1, TMAX = date2, dt = 10*60)
cor_stop['StopName']<- as.character(rep(route[1],length(cor_stop[,1])))
for(stop in route[2:length(route)])
{
tmp.df <- time_and_late_sequence(ALL_n =  stop_plot[stop_plot$StopName ==  stop,],
                                 TMIN = date1, TMAX = date2, dt = 10*60)
tmp.df['StopName']<- rep(stop,length(tmp.df[,1]))

cor_stop<-rbind(cor_stop,tmp.df)

Times <- append(Times,tmp.df[1])
Late <- append(Late,tmp.df[2])
StopName <- append(StopName,tmp.df[3])
}



cor_mat <- matrix(nrow = length(route), ncol = length(route))
dimnames(cor_mat)<-list(route,route)
for(stop in route)
{
  for(stop2 in route)
  {
    cor_mat[stop,stop2] <- cor(x = cor_stop[cor_stop$StopName ==  stop,'Late'],
                               y = cor_stop[cor_stop$StopName ==  stop2,'Late'])
  }
}

# data_colors <- topo.colors(length(route)+1, alpha = 1)
# nrows<-ceiling(sqrt(length(route)+1))
# par(mfrow=c(nrows,nrows))
cors<-2:length(route)
for (i in 2:length(route))
{
  stop <- route[i-1]
  stop1 <- route[i]
  # print(paste0("Correlation of delays between ",stop," and ", stop1))
   cors[i-1] <- cor_mat[stop,stop1]
  # matplot(x = cor_stop[cor_stop$StopName ==  stop,'Late'],
  #         y = cor_stop[cor_stop$StopName ==  stop2,'Late'], type = "p",
  #         pch = 19, xlab = stop, ylab = stop1 
  #         , col = data_colors[match(stop1,route)]
  # )
  # legend('topleft', 
  #        legend = paste0("Cor = ", cor_mat[stop, stop1]),
  #        col = "black", box.lty=0)
  
}

matplot(x = c(2:length(route)), y = cors,  type = "l",
        lty = "solid",  lwd = 2,
        xlab = paste0(line," in direction ",direction), ylab = 'Correlation en route',
        xaxt = 'n', col = color)
axis(1, c(1:length(route)), route, 
     tck = 0,  padj = 1, cex.axis = 0.75, 
     # las = 2,
     crt = 45)
for(i in 1:(length(route)-1))
{
  xpos <- i+1
  ypos <- cors[i]
  text(label=format(round(ypos, 2), nsmall = 2), x = xpos, y = ypos+0.05, col = "black")
}
print(route)
return(myplot)
}