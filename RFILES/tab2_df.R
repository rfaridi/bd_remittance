library(tidyr)
library(dplyr)
library(stringr)

load("./RData/listDF.RData")
load(listDF$RemitCC)

#load("./RData/remitCC.RData")
remit.ty <- remit.cc %>%
  mutate(Period=str_trim(Period),
         Period=sub('(\\d{2})\\d+-(\\d{2}$)','\\1\\2',Period),
         Period=paste0('FY',Period)) %>%
  gather(Country,Remittance,-Period,-Total) %>%
  select(-Total) %>%
  mutate(Country=sub('\\.',' ',Country),
         Remittance=round(as.numeric(Remittance),1)) %>%
  spread(Period,Remittance)


middle_east <- c('Bahrain','Libya','Iran','Kuwait','Oman','Qatar' ,'Saudi Arabia','U A.E.')

euro <- c('Germany','Italy','U K.')
north_america <- 'U S.A.'

east_asia_pacific <- c('Hong Kong','Japan','Australia','Malaysia','Singapore','South Korea')

other_countries <- 'Other Countries'


countries <- list('Middle East'=middle_east,
                  'Europe'=euro,
                  'North America'=north_america,
                  'East Asia \\& Pacific'=east_asia_pacific,
                  ' '=other_countries)


remit.full <- remit.ty %>%
  mutate(Region=NA)

for(i in names(countries)){
  remit.full$Region[remit.full$Country %in% countries[[i]]]=i
}

remit.fin <- remit.full %>% 
  mutate(Region=factor(Region,levels=names(countries))) %>%
  arrange(Region)

cc.g <- as.numeric(table(remit.fin$Region))
cc.rg <- levels(remit.fin$Region)
rownames(remit.fin) <- remit.fin$Country
save(remit.fin,cc.g,cc.rg,file="./RData/remitFin.RData")
