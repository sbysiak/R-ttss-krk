url <- paste0('https://mpk.jacekk.net/#!pl77')
lines <- readLines("scrape_final.js")
lines[1] <- paste0("var url ='", url ,"';")
writeLines(lines, "scrape_final.js")

## Download website
system("phantomjs scrape_final.js")

pg <- read_html("1.html")
test9 <-html_node(pg,'#times-table')

okurcze <- html_text(test9)

print(okurcze)