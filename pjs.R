library('rvest')
library("XML")
library('stringr')

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

repeat
{
for(i in 1:length(stops))
{
stop <- stops[i]
url <- paste0('https://mpk.jacekk.net/#!pl',to.url[i])
lines <- readLines("scrape_final.js")
lines[1] <- paste0("var url ='", url ,"';")
writeLines(lines, "scrape_final.js")

## Download website
system("phantomjs scrape_final.js")

pg <- read_html("1.html", encoding = "UTF-8")
node<-html_node(pg,'#times-table')

node.xml <- xmlParse(node)
df <- xmlToDataFrame(node.xml)
if(length(df)==0) 
{ print('next: length(data)=0')
  next}
# print(df)
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
df <- df[complete.cases(df$Late),] #removes trams which have just departed

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
title <- paste("saves/",title, sep = "")
df$Direction <- iconv(df$Direction, "UTF-8", "UTF-8", sub="") #removes Polish signs
df$Direction <- gsub(" ", "", df$Direction)
df$Direction <- gsub("\n", "", df$Direction)
df$Direction <- gsub("*", "", df$Direction, fixed = TRUE)
df$Direction <- gsub("♿", "", df$Direction, fixed = TRUE)
df$Direction <- chartr(old1, new1, df$Direction)

df$StopName <- stopnames
df$Time <- times
write.csv(df, file = title)
print(title)
}

}