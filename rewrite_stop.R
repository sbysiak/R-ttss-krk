rm(list = ls())


rewrite_stop <- function(stop_name){
  stop_file_lst<-Sys.glob(file.path(getwd(), "DATA/", paste0("*", stop_name, ".csv")) )
  #print(stop_file_lst)
  
  all_rows = NA
  for (f in stop_file_lst){ 
    next_rows<-read.csv(f)

    if (f == stop_file_lst[1]) all_rows <- next_rows
    else all_rows <- merge(all_rows, next_rows, all=T)
    
    
    idx <- match(f, stop_file_lst)
    if (! (idx %% 50)) print(idx)
    #print(strrep(" =", 20))
    #print(all_rows)
  }
  #print(paste0(line_number,"-",direction,"_", stop_name, ".csv"))
  #print(paste0("saves_rewrite/",stop_name, ".csv"))
  write.csv(all_rows, paste0("saves_rewrite/",stop_name, ".csv"))
  
}


all_stops <-read.csv("stops/stops_selected.csv", stringsAsFactors = F)
all_stops <- all_stops[ , "name"]

all_stops <- gsub(" ","",all_stops)
all_stops <- gsub(".","",all_stops,fixed = T)
old1 <- "ąęćłńóśżżŁŚ"
new1 <- "aeclnoszzLS"
all_stops <- chartr(old1, new1, all_stops)
print(all_stops)

for (stop in all_stops){
  print(stop)
  print("================")
  #print(class(stop))
  rewrite_stop(stop)
}
