rm(list = ls())

#this function returns file of unique arrivals at given stop

lines_unique_2_stops_uniqe <- function(stop_name)
{
#getting all files with given stop name from folder with unique arrivals
  stop_file_lst<-Sys.glob(paste0("rewrite/saves_rewrite_lines_unique/*",stop_name,"*"))
result_for_stop <- NULL
 print(stop_name)
 for( filename in stop_file_lst)
 {
   #not taking into consideration empty files
 if(file.size(filename)<103)
 {
   next
 }
   
 line_direction_stop <- read.csv(filename)
#inform about empty file
 if(length(line_direction_stop)==0)
 {
   print(paste0("===================== empty file ",filename))
   next
 }
 if (length(result_for_stop)==0)
 { #if it is first file...
   result_for_stop <- line_direction_stop 
 }
 else
 { #and bind them with another
 result_for_stop <- rbind(result_for_stop,line_direction_stop)
 }
 # print(result_for_stop)
 }
 #save files
 savepath <- "rewrite/saves_rewrite_stops_unique/"
 savepath <- paste0(savepath,stop_name,".csv")
 write.csv(result_for_stop, savepath)
}


#getting all stops and directions to the format which are written in data
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
#exectuting for all
for(s in stops)
lines_unique_2_stops_uniqe(s)