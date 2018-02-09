#rm(list = ls())

 giant_data_frame<-function(path)
 {
  path<-"rewrite/saves_rewrite_lines_unique/"
filelist<-Sys.glob(paste0(path,"*"))
ALL<-NULL
for( filename in filelist)
{
  if(file.size(filename)<103)
  {
    next
  }

  single_line_single_stop<- read.csv(filename)

  if(length(single_line_single_stop)==0)
  {
    print(paste0("===================== empty file ",filename))
    next
  }
  if (length(ALL)==0)
  {
    ALL <- single_line_single_stop
  }
  else
  {
    ALL <- rbind(ALL,single_line_single_stop)
  }
}
ALL<-ALL[complete.cases(ALL$Late),]
ALL<-ALL[ALL$Late>=0,]
return(ALL)
}