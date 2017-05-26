rm(list=ls())

library(jsonlite)
library(stringr)

warsaw_buses_trams_data <- function(days = 0, hours = 0, minutes = 0)
{
  #czas zbierania danych w minutach:
  acquisition.time <- days * 24 * 60 + hours * 60 + minutes
  
  html_bus <- "https://api.um.warszawa.pl/api/action/busestrams_get/?resource_id=%20f2e5503e-%20927d-4ad3-9500-4ab9e55deb59&apikey=fbc52758-6b2f-429d-bc0e-0c2743d72c62&type=1"
  html_tram <- "https://api.um.warszawa.pl/api/action/wsstore_get/?id=c7238cfe-8b1f-4c38-bb4a-de386db7e776&apikey=fbc52758-6b2f-429d-bc0e-0c2743d72c62"
  
  start.time <- Sys.time()
  
  data_bus <- fromJSON(html_bus, flatten=TRUE)
  data_tram <- fromJSON(html_tram, flatten=TRUE)
  
  buses <- data_bus$result
  trams <- data_tram$result
  
  while (abs((unclass(start.time) - unclass(as.POSIXct(max(buses[,5])))) / 60) < acquisition.time)
  {
    data_bus.old <- data_bus
    data_tram.old <- data_tram
    Sys.sleep(30)
    data_bus <- fromJSON(html_bus, flatten=TRUE)
    data_tram <- fromJSON(html_tram, flatten=TRUE)
    
    #tutaj sie czasem tworza jakies puste listy, wiec warto sprawdzic czy sa dwa wymiary
    if((length(dim(data_bus.old$result)) == 2) & (length(dim(data_bus$result)) == 2))
      #imo wystarczy porownac tylko pierwszy wiersz, bo przeciez sie nie moze powtorzyc
      if(!(all(data_bus.old$result[1,] == data_bus$result[1,])))
        buses <- rbind(buses, data_bus$result)
    
    if((length(dim(data_tram.old$result)) == 2) & (length(dim(data_tram$result)) == 2))
      if(!(all(data_tram.old$result[1,] == data_tram$result[1,])))
        trams <- rbind(trams, data_tram$result)
    
    cat((abs((unclass(start.time) - unclass(as.POSIXct(max(buses[,5])))) / 60) / acquisition.time * 100), "%\n")
  }
  
  finito.time <- Sys.time()
  
  time.period <- paste(substr(as.character(start.time), 6, 10), "_", str_replace_all(substr(as.character(start.time), 12, 16), ":", "-"), "_", substr(as.character(finito.time), 6, 10), "_", str_replace_all(substr(as.character(finito.time), 12, 16), ":", "-"), sep="")
  file_name.buses <- paste("buses_", time.period, ".csv", sep="")
  file_name.trams <- paste("trams_", time.period, ".csv", sep="")
  
  write.csv(buses, file_name.buses, row.names = FALSE)
  write.csv(trams, file_name.trams, row.names = FALSE)

  cat("Finito!")
}

warsaw_buses_trams_data(minutes = 10)