# In this file we will try to build a motion chart
library(dplyr)
library(tidyr)
library(countrycode)
library(WDI)
library(googleVis)

load("./RData/remitCC.RData")

# first let's create a long data set

# planning to change the year

remit.cc$Period <- sub("\\d{2}-","",remit.cc$Period)
countries <- names(remit.cc)[2:length(names(remit.cc))]
remit.cc.long <- remit.cc %>%
  select(-Other.Countries,-Total) %>%
  gather(country,remittance,-Period) %>%
  rename(year=Period) %>%
  mutate(country=sub("(.+\\w{2})\\.(.+)","\\1 \\2",country),
         remittance=round(as.numeric(remittance),0),
         year=as.numeric(year))

country.list <- unique(remit.cc.long$country)
country.iso <- countrycode(country.list,'country.name','iso2c')

country.df <- data.frame(country=country.list,code=country.iso)

remit.cc.long <- left_join(remit.cc.long,country.df,by=c("country"))  

save(remit.cc.long,file="./RData/remit_cc_long.RData")


ind <- "NY.GDP.MKTP.PP.KD"
indsname <- "GDP"

#Now lets get the data

gdp_remit <- WDI(country=country.iso, 
              indicator=ind,
              start=1994, 
              end=2015, 
             extra=TRUE)

gdp_remit2 <- select(gdp_remit,
                    code=iso2c,
                    year,
                    GDP=NY.GDP.MKTP.PP.KD) %>%
  mutate(GDP=GDP/1000000000)

remit.cc.gdp <- left_join(remit.cc.long,gdp_remit2,by=c("code","year"))

save(remit.cc.gdp,file="./RData/remit_cc_gdp.RData")

M <- gvisMotionChart(remit.cc.gdp,
                     idvar="country", timevar="year",
                     xvar="GDP", yvar="remittance",
                     colorvar="code", sizevar="GDP",
                     options=list(width=640,
                                  #state=myState,
                                  height=420))
## Display the chart in the browser
plot(M)


##  Top 5 countries in remittance

# 1994
remit.cc.long %>%
  filter(year==1994) %>%
  arrange(desc(remittance)) %>% 
  slice(1:5)

# 2014
remit.cc.long %>%
  filter(year==2014) %>%
  arrange(desc(remittance)) %>% 
  slice(1:5)