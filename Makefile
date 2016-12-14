all: view remittance.html

R_OPTS=--no-save --no-restore --no-init-file --no-site-file

view: remittance.html
	view remittance.html

remittance.html: remittance.Rmd Figures/rem1.png Figures/tab1.png Figures/tab2.png
	Rscript -e 'rmarkdown::render("$<")'

Figures/rem1.png: plot1.R RData/ExpRemGDP.RData
	Rscript ${R_OPTS} $<
	
Figures/tab2.png: tab2_png.R RData/remitFin.RData functions.R
	Rscript ${R_OPTS} $<

#remitFin.Rout: tab2_df.R RData/listDF.RData
	#Rscript ${R_OPTS} $<

RData/remitFin.RData: tab2_df.R RData/listDF.RData
	Rscript ${R_OPTS} $<

Figures/tab1.png: tab1_png.R RData/ExpRemGDP.RData 
	Rscript ${R_OPTS} $<

#
RData/ExpRemGDP.RData: tab1_df.R RData/listDF.RData
	Rscript ${R_OPTS} $<

# Reading the main data files	
RData/listDF.RData: read.R
	Rscript ${R_OPTS} $<



clean: 
	#rm -f *.Rout







