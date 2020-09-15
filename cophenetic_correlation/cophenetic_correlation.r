list.of.packages <- c("xtable", "vegan","ape","ggtree","phangorn", "plyr", "dendextend", "psych")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only = TRUE)

rm(list=ls())

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))   # setting working directory to source file location in Rstudio

ls <- c("Lig2D_pKi.csv","Lig3D-Lig2D-Lig-BS-FPI_pKi.csv")

dendls <- dendlist() 
coph_dist_cor <- vector(length=length(ls)) 
names(coph_dist_cor) <- ls

for(desc in ls){
  datFile <- read.csv(desc, row.names = 1)
  mat <- data.matrix(datFile)
  
  # make sure you normalize columns!
  matTrans <- scale(mat)
  d <- dist(matTrans)
  
  # make sure you don't use Wards method
  tupgma <- upgma(d, method="average")
  
  dendls <- dendlist(dendls, as.dendrogram(hclust(d, method = "average")))
  i <- which(desc == ls)
  coph_dist_cor[i] <- cor(d, cophenetic(hclust(d, method = "average")))
  
}

# cophenetic correlation coefficients

print(coph_dist_cor)

coph_mat <- cor.dendlist(dendls)
coph_mat <- coph_mat[1:2,1:2]

x_tab = xtable(coph_mat)
print(x_tab)

colnames(coph_mat) <- c("2D","3D")
rownames(coph_mat) <- c("2D","3D")
cor.plot(coph_mat)

coph_mat
