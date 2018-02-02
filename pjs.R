library('rvest')
library("XML")
library('stringr')

przystankiWZ <- c('BronwiceMale', 'Biprostal', 'TeatrBagatela',
                  'DworzecGlowny','RondoCzyzynskie')
przystankiPP = c('KrowodrzaGorka', 'StaryKleparz','PocztaGlowna','Korona',
                 'RondoMatecznego','BorekFalecki')
adresy.WZ <- c('https://mpk.jacekk.net/#!pl135', 'https://mpk.jacekk.net/#!pl84',
               'https://mpk.jacekk.net/#!pl77', 'https://mpk.jacekk.net/#!pl131',
               'https://mpk.jacekk.net/#!pl408')
adresy.PP <- c('https://mpk.jacekk.net/#!pl63', 'https://mpk.jacekk.net/#!pl3032',
               'https://mpk.jacekk.net/#!pl357', 'https://mpk.jacekk.net/#!pl571',
               'https://mpk.jacekk.net/#!pl610', 'https://mpk.jacekk.net/#!pl747')


przystanki <- c(przystankiWZ, przystankiPP)
adresy <- c(adresy.WZ, adresy.PP)

for( i in 1:11)
{
przystanek <- przystanki[i]
url <- paste0(adresy[i])
lines <- readLines("scrape_final.js")
lines[1] <- paste0("var url ='", url ,"';")
writeLines(lines, "scrape_final.js")

## Download website
system("phantomjs scrape_final.js")

pg <- read_html("1.html")
node<-html_node(pg,'#times-table')

node.xml <- xmlParse(node)
data <- xmlToDataFrame(node.xml)
names(data) <- c('Line','Direction','Vehicle','ETA','Late')
time <- toString(Sys.time())
title <- paste(time, przystanek, sep = "_")
title <- gsub(" ", "_", title, fixed = TRUE)
title <- paste(title,".csv", sep = "")
title <- paste("saves/",title, sep = "")
write.csv(data, file = title)
print(title)
}
