library(XLConnect)
library(stringr)
library(dplyr)
file <- "../Data/statisticaltable.xls"
wb <- loadWorkbook(file)

# ======= Reading GDP Information ============
gdp.mkt <- readWorksheet(wb,sheet = 'TableIXA',startRow = 4,endRow=55,startCol = 19,endCol=19)
gdp.mkt.yr <- readWorksheet(wb,sheet = 'TableIXA',startRow = 4,endRow=55,startCol = 22,endCol=22)
gdp.mkt <- cbind(gdp.mkt,gdp.mkt.yr)
names(gdp.mkt) <- c("gdp","year")
year.row1 <-which(gdp.mkt$year=='2005-06') 
year.row2 <-which(gdp.mkt$year=='2011-12') 
gdp.mkt1 <- gdp.mkt[-c(year.row1:year.row2),]
gdp.100 <- which(gdp.mkt1$gdp=='(100.00)')
gdp.mkt2 <- gdp.mkt1[-gdp.100,] %>% tbl_df()
save(gdp.mkt2,file="./RData/gdpMkt.RData")
load("./RData/gdpMkt.RData")
#========== Remittances ==============

remit <- readWorksheet(wb,sheet = 'Table XVIII',startRow = 3,startCol = 1)
yr <- remit$Col1
yr.14 <- grep('2013-14',yr)
yr14 <- yr[1:yr.14]
yr.15 <- grep('2014-15',yr)
yrs <- c(1:yr.14,yr.15)
yr15 <- str_trim(yr[yrs])
yr15 <- sub('(\\d+-)(\\d{2}$)','\\2',yr15)
yr15 <- paste0('FY',yr15)
yr.16 <- grep('2015-16',yr)
rem.usd <- as.numeric(str_trim(remit$Million.US...[yrs]))
rem.tk <- as.numeric(str_trim(remit$Tk..in.Crore.[yrs]))
rem.wk <- as.numeric(str_trim(remit$Col3[yrs]))
remit.df <- data.frame(year=factor(yr15,levels=yr15),
                    remusd=rem.usd,remtk=rem.tk,remwk=rem.wk) %>%
                        tbl_df()

save(remit.df,file="./RData/remit.RData")
#cmach.df$cap_mach[cmach.df$year=='2004-05']=6876
#p <- ggplot(data=remit.df,aes(x=year,y=remit,group=""))+
  #geom_line(size=1)
load("./RData/remit.RData")




#====================================
#  Import Country wise remittances
#====================================

remit.raw <- readWorksheet(wb,sheet = 'TableXIX',startRow = 3,endRow=54,startCol = 1)
# yr <- remit.cc$Period
# yr.14 <- grep('2013-14',yr)
# yr14 <- yr[1:yr.14]
# yr.15 <- grep('2014-15',yr)
# yrs <- c(1:yr.14,yr.15)
# yr15 <- str_trim(yr[yrs])
# yr15 <- sub('(\\d{2})\\d+-(\\d{2}$)','\\1\\2',yr15)
# yr15 <- paste('FY',yr15)

remit.cc <- tbl_df(remit.raw[yrs,])

save(remit.cc,file="./RData/remitCC.RData")
load("./RData/remitCC.RData")

listDF <- list(GDP="./RData/gdpMkt.RData",
               Remit="./RData/remit.RData",
               RemitCC="./RData/remitCC.RData")
 
save(listDF,file="./RData/listDF.RData")

