df <-read.csv("stops_selected.csv")

stops <- df$name
to.url <- df$shortName

stops <- gsub(" ","",stops)
old1 <- "ąęćłńóśżż"
new1 <- "aeclnoszz"
stops <- chartr(old1, new1, stops)

df <-read.csv("stops_loops.csv")

loops <- df$name
loops <- gsub(" ","",loops)
loops <- chartr(old1, new1, loops)
