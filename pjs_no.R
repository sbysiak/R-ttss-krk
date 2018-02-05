library('rvest')
library("XML")
library('stringr')
library("jsonlite")

rm(list = ls())

# - - - params:
ETA_max <- 3
output_dir = "SAVES/"
# - - - end of params
if(!endsWith(output_dir, "/")) output_dir <- paste0(output_dir,"/")


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

repeat
{
  for(i in 1:length(stops))
  {
    stop <- stops[i]
    print(stop)
    url <- paste0('https://mpk.jacekk.net/proxy.php/services/passageInfo/stopPassages/stop?stop=', to.url[i], '&mode=departure')
    
    json_trams<-try(read_json(path=url))
    if(class(json_trams) == "try-error"){
      print("ERROR occured while reading json from url, continuing with next stop ...")
      next
    }
    
    all_trams <- NA

    move_to_next_stop = F
    for (i_tram in 1:length(json_trams["actual"][[1]])){
      next_tram <- try(json_trams["actual"][[1]][[i_tram]])
      if(class(next_tram) == "try-error"){
        print("ERROR occured @ js[\'actual\'][[1]][[i_tram]], moving to next stop ...")
        move_to_next_stop = T
        break
      }
      #next_tram <- json_trams["actual"][[1]][[i_tram]]
      if (i_tram > 0) all_trams <- merge(all_trams, next_tram, all=T)
      else all_trams <- next_tram
      #print(all_trams)
      #print(class(all_trams))
    }
    if(move_to_next_stop){
      next
    }
    #all_trams[["actualRelativeTime"]] <- all_trams[["actualRelativeTime"]]/60
    df <- all_trams
    if(stop == "CichyKacik"){
      print("start")
      print(df)
    }
    
    if(length(df)==0) 
    { print('next: length(data)=0')
      next}
    # print(df)
    #names(df) <- c("actualRelativeTime", "direction", "mixedTime", "passageid",         
    #                "patternText", "plannedTime", "routeId", "status", "tripId", "x")
    # names(df) <- c("actualRelativeTime", "actualTime", "Direction", "mixedTime", "passageid",         
                    # "Line", "plannedTime", "routeId", "status", "tripId", "x")
    names(df)[which(names(df) == "direction")] <- "Direction"
    names(df)[which(names(df) == "patternText")] <- "Line"
    
        
    eta <- try(as.POSIXct(df["actualTime"][[1]], format="%H:%M") - Sys.time())
    if(class(eta) == "try-error"){
      print("ERROR occured @ df[\'actual_time\'], moving to next stop ...")
      next
    } 
    df["ETA"] <- as.numeric(eta, units="mins")
    late <- as.POSIXct(df["actualTime"][[1]],format="%H:%M") - as.POSIXct(df["plannedTime"][[1]],format="%H:%M")
    df["Late"] <- as.numeric(late, units="mins")
    df[c("x","routeId","status","vehicleId","passageid","tripId","actualRelativeTime")] <- NULL
    
    #print(df)
    #print(strrep("= = ",20))
    #names(df) <- c('Line','Direction','Vehicle','ETA','Late')
    # df_p <- df
    
    #df$Vehicle <- NULL #vehicles are not interesting yet
    
    #Lets make ETA numbers again!
    #df$ETA <- gsub(" min", "", df$ETA)
    #df$ETA <- gsub(".* s", "0", df$ETA)
    df$ETA <- gsub(">>>", "0", df$ETA) 
    #df$ETA <- as.numeric(df$ETA)
    df <- df[as.numeric(df$ETA)<ETA_max,] #one measurement in five minutes so...
    
    
    #df$Late <- gsub(" min", "", df$Late)
    #df$Late <- as.numeric(df$Late)
    df <- df[complete.cases(df$Late),] #removes trams which have just departed
    #print("end")
    print(df)    
    if(length(df$Late)<1)
    {print("next: length(df$Late)<1")
      next}
    #StopName
    #Time
    time <- toString(Sys.time())
    stopnames <-sprintf(stop, seq(1:length(df$ETA)))
    times <-sprintf(time, seq(1:length(df$ETA)))
    
    title <- paste(time, stop, sep = "_")
    title <- gsub(" ", "_", title, fixed = TRUE)
    title <- paste(title,".csv", sep = "")
    title <- paste(output_dir,title, sep = "")
    #next
    df$Direction <- iconv(df$Direction, "UTF-8", "UTF-8", sub="") #removes Polish signs
    #next
    df$Direction <- gsub(" ", "", df$Direction)
    df$Direction <- gsub("\n", "", df$Direction)
    df$Direction <- gsub("*", "", df$Direction, fixed = TRUE)
    #df$Direction <- gsub("♿", "", df$Direction, fixed = TRUE)
    df$Direction <- chartr(old1, new1, df$Direction)

    df$StopName <- stopnames
    df$Time <- times
    write.csv(df, file = title)
    print(title)
    print(strrep(" =", 30))
    print("")
  }
  print("")
  print("")
  print(paste("\n\n", strrep(" =", 30), "\n\n", str(Sys.time())))
  print("")
  print("")
  
  Sys.sleep(130)
}

