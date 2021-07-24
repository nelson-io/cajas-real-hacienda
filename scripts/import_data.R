library(tidyverse)


#set links
links <- list(nueva_espana = 'https://realhacienda.colmex.mx/images/excel/NE.zip',
           peru = 'https://realhacienda.colmex.mx/images/excel/P.zip',
           alto_peru = 'https://realhacienda.colmex.mx/images/excel/AP.zip',
           chile = 'https://realhacienda.colmex.mx/images/excel/C.zip',
           rio_de_la_plata = 'https://realhacienda.colmex.mx/images/excel/RdP.zip',
           ecuador = 'https://realhacienda.colmex.mx/images/excel/E.zip')

# def import func

import_zips <- function(link, name){
  temp <- tempfile()
  download.file(link, temp)
  dir.create(paste0('data/', name))
  unzip(temp,exdir = paste0('data/', name))
}

#download data


walk2(links, names(links), ~import_zips(link = .x, name = .y))



