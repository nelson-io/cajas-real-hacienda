library(tidyverse)
library(rio)
library(xlsx)
library(janitor)
library(lubridate)
library(zoo)

# elegimos columnas no nulas en su totalidad
select_not_null <- function(df){
  df_rows <- nrow(df)
  df_nas <- df %>% summarise_all(~sum(is.na(.x)))
  df_filt <- if_else(df_nas == df_rows, F, T)
  clean_df <- df[,df_filt] %>% clean_names()
  
  if('ocho_2' %in% names(clean_df)){
    clean_df <- clean_df %>% rename(ocho_1 = ocho_2)
  }
  
  else if('na' %in% names(clean_df) & 'na_2' %in% names(clean_df)){
    clean_df <- clean_df %>% rename(ocho = na, ocho_1 = na_2)
  }
  
  return(clean_df)
}

#parseamos fechas
add_cajas_date <- function(df){
  
  pattern <- regex('\\d{1}(/|-|//)\\d{4}')
  
  filt <- case_when(is.na(str_detect(df[,1] , pattern))~ F,
                    T ~ str_detect(df[,1], pattern))
  
  if(sum(filt) %in% c(0, 1, 4, 12)){
    pattern <- regex('(?<=ANO DE )\\d{4}')
    
    filt <- case_when(is.na(str_detect(df[,1] , pattern))~ F,
                      T ~ str_detect(df[,1], pattern)) 
    
    df$date_binary <- filt
    df$start_date <- na.locf(case_when(df$date_binary == T ~ 
                                         dmy(paste0('1/1/',str_extract(df[,1], pattern)))), na.rm = F)
    df$end_date <- na.locf(case_when(df$date_binary == T ~ 
                                       dmy(paste0('31/12/',str_extract(df[,1], pattern)))), na.rm = F)
    return(df %>% select(start_date, end_date, debe = cargo, ocho = na, haber = data, ocho_1 = na_1))
  }
  
  df$date_binary <- filt
  df$start_date <- na.locf(case_when(df$date_binary == T ~ 
                                       dmy(paste0('1/',str_extract(df[,1], regex('\\d{1,2}(/|-|//)\\d{4}'))))))
  df$end_date <- na.locf(case_when(df$date_binary == T ~ 
                                     dmy(paste0('1/',str_extract(df[,1], regex('(?<=-)\\d{1,2}(/|-|//)\\d{4}'))))))
  
  df$date_binary <- NULL
  
  if('ocho' %in% names(df)){
    return(df %>% select(start_date, end_date, debe = cargo, ocho , haber = data, ocho_1 ))
  }
  else{
  return(df %>% select(start_date, end_date, debe = cargo, ocho = na, haber = data, ocho_1 = na_1))
  }
  
}

#pivoteamos datos
pivot_bind <- function(df){
  df1 <- df %>% 
    select(start_date, end_date, concepto = debe, valor = ocho) %>% 
    mutate(clase = 'debe')
  
  df2 <- df %>% 
    select(start_date, end_date, concepto = haber, valor = ocho_1) %>% 
    mutate(clase = 'haber')
  
  bind_df <- rbind(df1,df2) %>% 
    filter(!is.na(valor))
  
  return(bind_df)
}

#removemos totales
remove_totals <- function(df){
  pattern <- regex('TOTAL|TOTAL COMPUTADO')
  return(df %>% filter(!str_detect(concepto ,pattern)))
}

#importamos los datos
import_rh <- function(path, st_row = 2){
  
  print(path)
  
  folder <- str_extract(path, regex('(?<=/)\\w{1,20}'))
  name <- str_extract(path, regex('(?<=/\\w{1,20}/)\\w{1,20}'))
  
  df <- read.xlsx(path,1,startRow = st_row) %>% 
    select_not_null() %>%
    filter(rowSums(is.na(.)) < ncol(.)) %>% 
    add_cajas_date() %>% 
    pivot_bind() %>%  
    remove_totals() %>% 
    mutate(valor = as.numeric(valor),
           u_mon = 'ocho',
           region_1 = folder,
           region_2 = name)
  
  
  return(df)
}

dfs <- list()
nuevesp_df <- map_df(list.files('data/nueva_espana', full.names = T), import_rh)


#bindeamos

cajas_df <- rbind(cajas_df, nuevesp_df)
write_csv(cajas_df,'out/cajas_df.csv')



