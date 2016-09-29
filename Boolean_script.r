#first, open this script
#source("Script.r")

#start by setting the working directory and openning libraries
#library(BoolNet)
#library(igraph)

#setwd("/home/valeria/Documents/peiper Biophysical module for PIN polarisation/modelo Booleano")

#get the attractors of the network

atPIN <- loadNetwork("BDMPINpol_Boolean.txt")
attrcs <- getAttractors(atPIN)

#par(mfrow=c(2,length (attrcs$attractors)))
#plotAttractors(attrcs)

#WT attractors
write("\\documentclass[10pt,a4paper,notitlepage]{report}\n\\usepackage{tabularx}\n\\usepackage{colortbl}\n\\begin{document}\n\\section*{Wild-Type}", file="atractors.tex")
atCC <- loadNetwork("BDMPINpol_Boolean.txt")
plotNetworkWiring(atPIN)
attrcs <- getAttractors(atPIN)
par(mfrow=c(1,length (table(sapply(attrcs$attractors, function(attractor){length(attractor$involvedStates)})))))
plotAttractors(attrcs)
attractorsToLaTeX(attrcs, onColor="[gray]{1}", offColor="[gray]{0.3}", file="atractors.tex")
atrcWT <- readLines("atractors.tex",encoding="UTF-8")
write(atrcWT, file="atractors.tex",append=TRUE)

#Over expression (OE) and knock out (KO) atractors in latex
for(g in atPIN$genes){
	for(x in 0:1){
		if(x==0){
			write(paste("\\newpage\n\\section*{",g," KO}\n",sep=''), file="atractors.tex",append=TRUE)
			}
		else{
			write(paste("\\newpage\n\\section*{",g," OE}\n",sep=''), file="atractors.tex",append=TRUE)
			}
		mut <- fixGenes(atPIN, g, x)
		attrcs <- getAttractors(mut)
		attractorsToLaTeX(attrcs, onColor="[gray]{1}", offColor="[gray]{0.3}", file="atractors.tex")
		atrcWT <- readLines("atractors.tex",encoding="UTF-8")
		write(atrcWT, file="atractors.tex",append=TRUE)
		}
	}

#Finishing the .tex
write("\n\\end{document}", file="atractors.tex",append=TRUE)
atrcOK <- readLines("atractors.tex",encoding="UTF-8")
atrcOK <- gsub(pattern="\\\\begin\\{table\\}\\[ht\\]", replacement="", x=atrcOK, perl=TRUE)
atrcOK <- gsub(pattern="\\\\end\\{table\\}", replacement="",x=atrcOK, perl = TRUE)
write(atrcOK, file="atractors.tex")
