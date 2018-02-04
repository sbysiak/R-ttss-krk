rm(list = ls())

time_stop2line_stop <- function(line_number, direction, stop_name){
  line <- paste(line_number,direction, sep = "-")
  stop_file_lst<-Sys.glob(file.path(getwd(), "saves", paste0("*", stop_name, "*")) )
  
  all_rows = NA
  for (f in stop_file_lst){ 
    csvf<-read.csv(f)
    rows_by_line <- csvf[which(csvf[,2] == line_number & csvf[,3] == direction), ]
    #rows_by_line <- 
    measurement_time <- paste(as.numeric(strsplit(f,"_")[[1]][2:4]), collapse = ":")
    stop_name <- strsplit(strsplit(f,"_")[[1]][5], ".cs")[[1]][[1]]
    nrows <- length(rows_by_line[,1])
    rows_by_line["StopName"] <- rep(stop_name, nrows)
    rows_by_line["Time"] <- rep(measurement_time, nrows)
    #print(rows_by_line)
    if (f == stop_file_lst[1]) all_rows <- rows_by_line
    else all_rows <- merge(all_rows, rows_by_line, all=T)
    #print(all_rows)
  }
  #print(paste0(line_number,"-",direction,"_", stop_name, ".csv"))
  write.csv(all_rows, paste0(line_number,"-",gsub("\n","",direction),"_", stop_name, ".csv"))
  #return(all_rows)
  #return(rows_by_line)
}




#time_stop2line_stop("3", "Krowodrza_Grka\n", "")
