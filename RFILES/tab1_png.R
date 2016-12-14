load("./RData/ExpRemGDP.RData")
source("functions.R")
library(dplyr)

tab1 <- exp_rem_gdp2 %>% 
  select(
    'Remittance(% of GDP)'=remit_gdp,
    'Remittance(% of Exports)'=remit_exp)
#xtable(caption='Remittance as percentage of Export and GDP')


dvipng.dvi(dvi.latex(
  latex(tab1, 
        #file="test.png",
        col.just = strsplit("cc", "")[[1]],
        rowlabel.just="c",
        rowlabel="FY",
        booktabs = T
        #caption='Remittance as percentage of Export and GDP'
        #insert.bottom='Source: Bangaldesh Bank'
  )),file='./Figures/tab1.png')

#pcchange <- function(x,lag=1) {
#c(diff(x,lag),rep(NA,lag))/x
#}
