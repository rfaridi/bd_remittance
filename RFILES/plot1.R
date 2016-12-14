load("./RData/ExpRemGDP.RData")
library(ggplot2)
library(dplyr)
source("functions.R")
exp_rem_gdp <- exp_rem_gdp %>%
  mutate(pc_rem=(remtk-lag(remtk))/lag(remtk)*100,
         pc_rem=round(pc_rem,1),
         pc_wk=(remwk-lag(remwk))/lag(remwk)*100,
         pc_wk=round(pc_wk,1)) %>%
  filter(!is.na(pc_wk))

len <- dim(exp_rem_gdp)[1]
#var <- 'remit_exp'
nums <- c(seq(1,len,by=2),len)
my_breaks <- exp_rem_gdp[['year']][nums]


plot1 <- ggplot(exp_rem_gdp)+ 
  geom_bar(aes(x=year,y=pc_wk), 
           stat='identity',
           fill='Grey') +
  geom_line(aes(x=year,y=pc_rem,group=""),
            size=1)+
  scale_x_discrete(breaks=my_breaks)+
  annotate('text',x='FY02',y=46,
           label='% Change in Remittance',fontface='bold') +
  annotate('text',x='FY08',y=90,
           label='% Change in Migrant Workers',
           color='Black',fontface='bold',hjust=0)+
  labs(x='Fiscal Year',y='Percentage')+
  themeLine2

ggsave('./Figures/rem1.png',plot1,width=8.88,height=6,dpi=72)
#viewer('rem1.png')