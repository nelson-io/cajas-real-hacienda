path <- 'data/alto_peru/CHARCAS.xls'



#homogeneizamos nombres
homog_names <- function(df){
  if(!('ensayados' %in% names(df))){
    df$ensayados <- NA
    df$ensayados_1 <- NA
  }
  
  else  {
    ensayados_vars <- names(df)[str_detect(names(df), 'ensayados')]
    df$ensayados <- df %>% pull(ensayados_vars[1])
    df$ensayados_1 <- df %>% pull(ensayados_vars[2])
    
  } 
  
  return(df %>% select(c("cargo", "ocho", "ensayados", "data", "ocho_1", "ensayados_1")))
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
    return(df %>% select(start_date, end_date, debe = cargo, ocho, ensayados, haber = data, ocho_1, ensayados_1))
  }
  
  df$date_binary <- filt
  df$start_date <- na.locf(case_when(df$date_binary == T ~ 
                                       dmy(paste0('1/',str_extract(df[,1], regex('\\d{1,2}(/|-|//)\\d{4}'))))))
  df$end_date <- na.locf(case_when(df$date_binary == T ~ 
                                     dmy(paste0('1/',str_extract(df[,1], regex('(?<=-)\\d{1,2}(/|-|//)\\d{4}'))))))
  
  df$date_binary <- NULL
  

  

  
  return(df %>% select(start_date, end_date, debe = cargo, ocho, ensayados, haber = data, ocho_1, ensayados_1))
  
  
}




pivot_bind <- function(df){
  df1 <- df %>% 
    select(start_date, end_date, concepto = debe, valor = ocho) %>% 
    mutate(clase = 'debe', u_mon = 'ocho')
  
  df2 <- df %>% 
    select(start_date, end_date, concepto = haber, valor = ocho_1) %>% 
    mutate(clase = 'haber', u_mon = 'ocho')
  
  df3 <- df %>% 
    select(start_date, end_date, concepto = haber, valor = ensayados) %>% 
    mutate(clase = 'haber', u_mon = 'ensayados')
  
  df4 <- df %>% 
    select(start_date, end_date, concepto = haber, valor = ensayados_1) %>% 
    mutate(clase = 'debe', u_mon = 'ensayados')
  
  bind_df <- rbind(df1,df2, df3, df4) %>% 
    filter(!is.na(valor))
  
  return(bind_df)
}





df <- read.xlsx(path,1,startRow = 4) %>% 
  select_not_null() %>%
  filter(rowSums(is.na(.)) < ncol(.)) %>% 
  homog_names() %>% 
  add_cajas_date() %>% 
  pivot_bind() %>%  
  remove_totals() %>% 
  mutate(valor = as.numeric(valor),
         region_1 = 'alto_peru',
         region_2 = 'test_1')




