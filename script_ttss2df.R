library("rvest")

rm(list = ls())

######
# script ready to use 
# ToDo:
#   - busStop as an arg
#   - wrap into a function
#   - convert into numbers ?
#   - save to file (csv) ? 
#   - remove polish signs ? - may be complicated but necessary
####

ttss_2_df <- function(bus_stop_id){

  # change Phantom.js scrape file
  lines <- readLines("ttss-krakow-pl_plainText.js") 
  lines[2] <- gsub(pattern = "stop=.*&mode", 
                   replacement = paste0("stop=", bus_stop_id, "&mode"), 
                   x = lines[2], 
                   fixed = F)
  writeLines(lines, "scrape_final.js")
  
  
  ## Download website
  system("phantomjs ttss-krakow-pl_plainText.js > _tmp_.txt")
  
  input_file <- file("_tmp_.txt", open = "r")
  lines <- readLines(con = input_file)
  ### print(lines) # uncomment to see form of the input
  
  # drop description
  first_idx <- match(x = "Linia\tKierunek\tOdjazd", table = lines) # head line from table
  last_idx <- tail(which(endsWith(lines,"Min")), n = 1) + 1 # last cell of the table (each cell = new line)
  lines <- lines[-last_idx : -length(lines)][0 : -first_idx]
  print(lines)
  
  # convert to df
  mat <- matrix(lines, ncol = 3, byrow = T)
  df <- data.frame(mat, stringsAsFactors = F)
  names(df) <- c("linia", "kierunek", "czas [min]")
  print("df before clearing: ")
  print(df)
  
  
  # clear the data
  # 1) rm "\t" from lines numbers
  df[ ,1] <- gsub("\t", "", df[ ,1])  
  
  # 2) unify departure time {"mniej niz min", "09:54", "15 Min"} --> "15" 
  for (i in 1:NROW(df)) {
    if( grepl(":",df[i, 3]) ){
      delta_time <- strptime("06:06", format="%H:%M") - Sys.time()
      fdelta_time <- format(delta_time)
      df[i, 3] <- strsplit(fdelta_time, ".", fixed = T)[[1]][[1]]
    }
    else if (df[i, 3] == "mniej niż minuta") df[i, 3] <- "0"
    else df[i, 3] <- gsub(" Min", "", df[i, 3])
  }
  
  print("df after clearing: ")
  print(df)
}


ttss_2_df("77")