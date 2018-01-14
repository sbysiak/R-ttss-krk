system("./run_spa.sh")

tab <- readHTMLTable("out.html")
df<-data.frame(tab[[1]], stringsAsFactors = FALSE)
names(df)<-c('Linia', 'Kierunek', 'Pojazd', 'Czas', 'Opoznienie')
df[] <- lapply(df, as.character)

df