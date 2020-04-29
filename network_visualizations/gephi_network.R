list.of.packages <- c("phangorn")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only = TRUE)
rm(list=ls())


csv_data <- read.csv('2Drdkit_chembl364.csv',header=TRUE,sep=",")

### We will subset the data so that we are clustering them based on 2D RDKit descriptors only
### We don't want to include "ID" and "Aff" column, which is the biological endpoint that we are interested in predicting
myvars <- names(csv_data) %in% c("ID","Aff")  
desc <- csv_data[!myvars]
rownames(desc) <- csv_data[,1] # set first column as rownames

#make sure you normalize columns! (for continuous data, not binary)
matTrans <- scale(desc)

# Compute the distance matrix using default Euclidean distance. 
d <- dist(desc)

# Apply unsupervised hierarchical clustering with ward linkage.
tupgma <- upgma(d, method="ward.D2")

write.csv2(tupgma$edge, file = "edges.csv")
