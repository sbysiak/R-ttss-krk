rm(list = ls())


rewrite_stop_2_line_stop <- function(stop_name){
  #stop_file_lst<-Sys.glob(file.path(getwd(), "DATA/", paste0("*", stop_name, ".csv")) )
  #print(stop_file_lst)

  fname <- paste0("saves_rewrite/",stop_name, ".csv")
  df<-read.csv(fname, stringsAsFactors = F)
  lines <- df[ , "Line"]
  #print(lines)
  
  for (line in unique(lines)){
    #print(line)
    #if(line != "13") next
    line_df <- df[ which(df[ , "Line"] == line), ]
    for (direc in unique(line_df[, "Direction"])){
      #if (direc != "NowyBiezanowP+R") next
      direc <- iconv(direc, "ASCII", "ASCII", sub="")
      direc <- gsub(".","",direc, fixed = T)
      line_direc_df <- line_df[ which(line_df[ , "Direction"] == direc) , ]
      line_direc_df <- line_direc_df[complete.cases(line_direc_df[,"plannedTime"]),] # remove 'NA's

      dates <- format(as.POSIXct(line_direc_df[ , "Time"]), format = "%Y-%m-%d")
      hours <- line_direc_df[ , "plannedTime"]
      
      all_latest_rows <- NULL  
      # if more than 1 measurement of specific tram (by plannedTime) on specific stop were taken
      # then take only latest measurement (probably the most accurate)
      for (u_hour in unique(hours)){
        for (u_date in unique(dates)){

          u_h <- grepl(u_hour, line_direc_df[ , "plannedTime"])
          u_d <- grepl(u_date, format(as.POSIXct(line_direc_df[ , "Time"]), format="%Y-%m-%d"))
          selected_rows <- u_h & u_d
          #line_direc_df[selected_rows, ]
          idx <- order(line_direc_df[selected_rows,"Time"])
          latest_row <- line_direc_df[selected_rows, ][idx,][length(idx), ]
          
          #print(selected_rows)
          #print(latest_row)
          if (length(all_latest_rows[,1]) == 0) all_latest_rows <- latest_row
          else all_latest_rows <- merge(all_latest_rows, latest_row, all=T)
          #print(latest_row)
          #print(all_latest_rows)
        }
      }
      #line_direc_df <- 
      write.csv(all_latest_rows, paste0("saves_rewrite_lines_unique/", line,"-", direc, "_", stop_name, ".csv"))
    }
  }
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
  rewrite_stop_2_line_stop(stop)
}
