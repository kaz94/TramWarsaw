rm(list=ls())

library(jsonlite)

json_data <- fromJSON("https://api.um.warszawa.pl/api/action/wsstore_get/?id=c7238cfe-8b1f-4c38-bb4a-de386db7e776&apikey=fbc52758-6b2f-429d-bc0e-0c2743d72c62", flatten=TRUE)

trams <- json_data$result
i <- 0

while (i < 100)
{
  json_data.old <- json_data
  Sys.sleep(30)
  json_data <- fromJSON("https://api.um.warszawa.pl/api/action/wsstore_get/?id=c7238cfe-8b1f-4c38-bb4a-de386db7e776&apikey=fbc52758-6b2f-429d-bc0e-0c2743d72c62", flatten=TRUE)
  
  #tutaj sie czasem tworza jakies puste listy, wiec warto sprawdzic czy sa dwa wymiary
  if((length(dim(json_data.old$result)) == 2) & (length(dim(json_data$result)) == 2))
  {
    #imo wystarczy porownac tylko pierwszy wiersz, bo przeciez sie nie moze powtorzyc
    if(!(all(json_data.old$result[1,] == json_data$result[1,])))
    {
      trams <- rbind(trams, json_data$result)
      i <- i + 1
      cat(i, '%\n')
    }
  }
}

write.csv(trams, "trams.csv")

cat("Finito!")