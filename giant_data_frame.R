#rm(list = ls())
#this function creates data frame fith all useful data harvested
 giant_data_frame<-function(path)
 {
  path<-"rewrite/saves_rewrite_lines_unique/"
filelist<-Sys.glob(paste0(path,"*"))
ALL<-NULL
for( filename in filelist)
{
  #get rid of empty files
  if(file.size(filename)<103)
  {
    next
  }

  single_line_single_stop<- read.csv(filename)

  if(length(single_line_single_stop)==0)
  {
    #be careful of empty files
    print(paste0("===================== empty file ",filename))
    next
  }
  if (length(ALL)==0)
  {
    #first file will start data frame
    ALL <- single_line_single_stop
  }
  else
  {
    #merging all data into one data frame "ALL"
    ALL <- rbind(ALL,single_line_single_stop)
  }
}
#basic clearence from NAs and negative lates, which may occur
ALL<-ALL[complete.cases(ALL$Late),]
ALL<-ALL[ALL$Late>=0,]
return(ALL)
}