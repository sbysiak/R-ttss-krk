# rm(list = ls())
# library('lattice')
# library('ggplot2')
# library(latticeExtra)
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

source('nice_plots.R')
t22<-delays_and_correlations(ALL = ALL, line = 2, 
                             direction = 'Salwator', color = data_colors[2])
trellis.device(device="png", filename=("correlations.png"))
data_colors <- topo.colors(4, alpha = 1)
nrows<-2
par(mfrow=c(nrows,nrows))

t1 <- delays_and_correlations(ALL = ALL, line = 6, 
                              direction = 'KurdwanowP+R', color = data_colors[1] )
t2 <- delays_and_correlations(ALL = ALL, line = 6, 
                              direction = 'Salwator', color = data_colors[2])
t3 <- delays_and_correlations(ALL = ALL, line = 18, 
                              direction = 'KrowodrzaGorka', color = data_colors[3])
t4 <- delays_and_correlations(ALL = ALL, line = 18, 
                              direction = 'CzerwoneMakiP+R', color = data_colors[4])

dev.off()
# trellis.device(device="png", filename=paste0("time_series_",t1$ylab,".png"))
# print(t1)
# dev.off()
# 
# trellis.device(device="png", filename=paste0("time_series_",t2$ylab,".png"))
# print(t2)
# dev.off()
# 
# trellis.device(device="png", filename=paste0("time_series_",t3$ylab,".png"))
# print(t3)
# dev.off()
# 
# trellis.device(device="png", filename=paste0("time_series_",t4$ylab,".png"))
# print(t4)
# dev.off()
# 
# trellis.device(device="png", filename=paste0("time_series_",t22$ylab,".png"))
# print(t22)
# dev.off()



