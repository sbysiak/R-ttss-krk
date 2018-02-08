rm(list = ls())

lines_unique_2_stops_uniqe <- function(stop_name)
{

  stop_file_lst<-Sys.glob(paste0("rewrite/saves_rewrite_lines_unique/*",stop_name,"*"))
result_for_stop <- NULL
 print(stop_name)
 for( filename in stop_file_lst)
 {
 if(file.size(filename)<103)
 {
   next
 }
   
 line_direction_stop <- read.csv(filename)
 # print(length(line_direction_stop[,1]))
 
 if(length(line_direction_stop)==0)
 {
   print(paste0("===================== empty file ",filename))
   next
 }
 if (length(result_for_stop)==0)
 { 
   result_for_stop <- line_direction_stop 
 }
 else
 {
 result_for_stop <- rbind(result_for_stop,line_direction_stop)
 }
 # print(result_for_stop)
 }
 savepath <- "rewrite/saves_rewrite_stops_unique/"
 savepath <- paste0(savepath,stop_name,".csv")
 write.csv(result_for_stop, savepath)
}

df <-read.csv("stops_selected.csv")

stops <- df$name
to.url <- df$shortName

stops <- gsub(" ","",stops)
stops <- gsub(".","",stops,fixed = T)
old1 <- "ąęćłńóśżżŁŚ"
new1 <- "aeclnoszzLS"
stops <- chartr(old1, new1, stops)

df <-read.csv("stops_loops.csv")

loops <- df$name
loops <- gsub(" ","",loops)
loops <- chartr(old1, new1, loops)
for(s in stops)
lines_unique_2_stops_uniqe(s)