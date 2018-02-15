library('rvest')
library("XML")
library('stringr')

#make sure you have direction "saves" in folder with script!


#prepare list of stops and loops with filtered "tough" signs

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
loops <- gsub(".","",loops,fixed = T)

loops <- chartr(old1, new1, loops)

#main loop
repeat
{
for(i in 1:length(stops))
{
stop <- stops[i]
#handling JS script
url <- paste0('https://mpk.jacekk.net/#!pl',to.url[i])
lines <- readLines("scrape_final.js")
lines[1] <- paste0("var url ='", url ,"';")
writeLines(lines, "scrape_final.js")

## Download website
system("phantomjs scrape_final.js")

#rvest magic: parsing document to html and picking out a html node
pg <- read_html("1.html", encoding = "UTF-8")
node<-html_node(pg,'#times-table')

#parsing html node to xml and to data frame
node.xml <- xmlParse(node)
df <- xmlToDataFrame(node.xml)


#avoiding empty dataframes
if(length(df)==0) 
{ print('next: length(data)=0')
  next}
# print(df)
#peparing data frame
names(df) <- c('Line','Direction','Vehicle','ETA','Late')
# df_p <- df

df$Vehicle <- NULL #vehicles are not interesting yet

#Lets make ETA numbers again!
df$ETA <- gsub(" min", "", df$ETA)
df$ETA <- gsub(".* s", "0", df$ETA)
df$ETA <- gsub(">>>", "0", df$ETA) 
df$ETA <- as.numeric(df$ETA)
df <- df[df$ETA<6,] #one measurement in five minutes so...


df$Late <- gsub(" min", "", df$Late)
df$Late <- as.numeric(df$Late)
df <- df[complete.cases(df$Late),] #removes trams which have just departed etc.

#avoiding negative late etc.
if(length(df$Late)<1)
{print("next: length(df$Late)<1")
  next}
#StopName
#Time
#filling two columns in data frame with stop names and time of measurement
time <- toString(Sys.time())
stopnames <-sprintf(stop, seq(1:length(df$ETA)))
times <-sprintf(time, seq(1:length(df$ETA)))

#parsing file title
title <- paste(time, stop, sep = "_")
title <- gsub(" ", "_", title, fixed = TRUE)
title <- paste(title,".csv", sep = "")
title <- paste("saves/",title, sep = "")
#celaring Direction column from "tough" signs
df$Direction <- iconv(df$Direction, "UTF-8", "UTF-8", sub="") #removes Polish signs
df$Direction <- gsub(" ", "", df$Direction)
df$Direction <- gsub("\n", "", df$Direction)
df$Direction <- gsub("*", "", df$Direction, fixed = TRUE)
df$Direction <- gsub("♿", "", df$Direction, fixed = TRUE)
df$Direction <- chartr(old1, new1, df$Direction)

#filling columns with stop names and time of measurement
df$StopName <- stopnames
df$Time <- times
#writing to a file, printing file name
write.csv(df, file = title)
print(title)
}

}