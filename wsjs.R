library(rvest)
library(V8)

#URL with js-rendered content to be scraped
link <- 'https://mpk.jacekk.net/#!pl77'
#Read the html page content and extract all javascript codes that are inside a list

webpage <- read_html(link) %>% html_nodes('script')
sources <- 1:4
sources[1] <- 'https://code.jquery.com/jquery-3.1.1.min.js'
sources[2] <- 'https://mpk.jacekk.net/lang_pl.js'
sources[3] <- 'https://mpk.jacekk.net/common.js'
sources[4] <- 'https://mpk.jacekk.net/index.js'

# Create a new v8 context
ct <- v8()
print('ddd')