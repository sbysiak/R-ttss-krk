rm(list = ls())

url <- 'https://mpk.jacekk.net/#!pl77'

ct <- v8()

webpage <- read_html(url)

test9 <-html_node(webpage,'tr')

okurcze <- html_text(test9)
  
print(okurcze)