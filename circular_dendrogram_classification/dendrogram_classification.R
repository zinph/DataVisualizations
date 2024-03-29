list.of.packages <- c("ape","ggtree","phangorn","ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only = TRUE)
rm(list=ls())

csv_data <- read.csv('sample.csv',header=TRUE,sep=",")
rownames(csv_data) <- csv_data[,1]

myvars <- names(csv_data) %in% c('ID', 'Class') 
desc <- csv_data[!myvars]

class <- csv_data$Class
class_data <- cbind(as.data.frame(row.names(desc)),as.data.frame(class))

matTrans <- scale(desc) 

d <- dist(matTrans)
tupgma <- upgma(d, method="ward.D2")

cols <- c("red", "blue1", "orange", "darkgreen", "navy", "brown1", "darkmagenta","darkorchid", "maroon4", "deeppink1")

# Adjust the parameters accordingly.
t4 <- ggtree(tupgma, layout="circular", size = 1) 
t4 <- t4 %<+% class_data + 
  geom_text(aes(color = class, label = label, angle = angle, 
                hjust = - 0.2, fontface = "bold"), size = 2.6) +
  geom_tippoint(aes(color = class), alpha = 0.5, size = 2) +
  scale_color_manual(values = cols) +
  theme(legend.position="right") +
  theme(plot.margin = unit(c(0,0,0,0), "cm")) +
  theme(plot.background = element_rect(fill = 'white', colour = 'white')) +
  theme(panel.background = element_rect(fill = 'white', colour = 'white')) +
  theme(legend.background = element_rect(fill = 'white'),
        legend.title = element_text(size = 8,face = "bold")) + # LEGEND TITLE
  theme(legend.text = element_text(size = 8, face = "bold")) + # LEGEND TEXT
  theme(text = element_text(color = "black", size = 8)) +
  geom_treescale(x = 0.1,y = 0.1, width = 0.1, offset = NULL,
                 color = "white", linesize = 1E-100, fontsize = 1E-100)

print(t4)
# dev.off()


##################################################################
# t4 <- ggtree(tupgma, layout="circular", size = 0.8, color='black') 
# t4 <- t4 %<+% class_data + 
#   geom_text(aes(color = class, label = label, angle = angle, 
#                 hjust = - 0.2, fontface = "bold"), size = 2) +
#   geom_tippoint(aes(color = class), alpha = 0.5, size = 1.7) +
#   scale_color_manual(values = cols) +
#   theme(legend.position="right") +
#   theme(plot.margin = unit(c(0,0,0,0), "cm")) +
#   theme(plot.background = element_rect(fill = 'black', colour = 'black')) +
#   theme(panel.background = element_rect(fill = 'black', colour = 'black')) +
#   theme(legend.background = element_rect(fill = 'black'),
#         legend.title = element_text(size = 11,face = "bold")) + # LEGEND TITLE
#   theme(legend.text = element_text(size = 11, face = "bold")) + # LEGEND TEXT
#   theme(text = element_text(color="white", size=15)) +
#   # dev.off()
#   geom_treescale(x = 40,y = 40, width = 15, offset = NULL,
#                  color = "black", linesize = 1E-100, fontsize = 1E-100)
# 
# print(t4)
