load(file="./RData/remitFin.RData")
source('functions.R',echo=F)
library(dplyr)
tab2 <- remit.fin %>%
  select(FY2013:FY2015) 
dvipng.dvi(dvi.latex(
  latex(tab2,col.just = strsplit("ccc", "")[[1]],
        rowlabel='Countries',
        rowlabel.just="c",
        rgroup=cc.rg,
        n.rgroup=cc.g,
        booktabs = T)
),file="./Figures/tab2.png")
