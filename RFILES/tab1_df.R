library(dplyr)
# This is the table used for showing Remittance as % of GDP  and % of Exports

load("../econStag/RData/master.RData")
load("./RData/listDF.RData")
load(listDF$Remit)
load(listDF$GDP)

exp_rem <- inner_join(master,remit.df,by='year')

exp_rem_gdp <- slice(exp_rem,-c(1:3)) %>%
  select(-cap_mach) %>%
  cbind(gdp=gdp.mkt2$gdp) %>%
  mutate(
    gdp=as.numeric(gdp),
    remit_gdp=round(remtk/gdp*100,1),
    remit_exp=round(remtk/Exports*100,1),
    exp_gdp=round(Exports/gdp*100,1)) 

exp_rem_gdp2 <- exp_rem_gdp %>%
  slice((n()-5):n())

rownames(exp_rem_gdp2) <- exp_rem_gdp2$year
exp_rem_gdp2 <- select(exp_rem_gdp2,-year)

save(exp_rem_gdp,exp_rem_gdp2,file="./RData/ExpRemGDP.RData")
