#!/bin/R
args <- commandArgs(trailingOnly=TRUE)

#Load Libraries
suppressPackageStartupMessages({
library(glmnet)
library(glmnetUtils)
})

#Load Data
load("age_R.gz")
load("meth_R.gz")

#Prepare final results data.frame
glmnet.results <- data.frame(matrix(ncol=4))
colnames(glmnet.results) <- c("alpha", "MAE", "#loci", "loci")

#Randomly sample the loci
tmp.meth <- meth[,sample(colnames(meth),args[1])]
#Setup for initial alpha run
pre.results <- data.frame(matrix(ncol=2, nrow=11))
colnames(pre.results) <- c("alpha", "MAE")
pre.results[,1] <- c(0.000, 0.001, 0.008, 0.027, 0.064, 0.125, 0.216, 0.343, 0.512, 0.729, 1.000)

#Loop over set alpha values
for(alpha in pre.results[,1]){
tmp.glm <- cv.glmnet(x = tmp.meth, y = age, nfolds = nrow(tmp.meth), alpha = alpha, type.measure = "mae", family = "gaussian", grouped = FALSE)
pre.results[pre.results$alpha == alpha,2] <- min(tmp.glm$cvm)
}

#Pull best alpha values
MINS <- pre.results[order(pre.results$MAE),1][1:2]
#MINS <- sort(MINS)
DIFF <- abs(MINS[2] - MINS[1])
#Setup for second alpha run
pre.results <- data.frame(matrix(ncol=2, nrow=11))
colnames(pre.results) <- c("alpha", "MAE")
#Getting the optimal range of alpha values
if(MINS[1] == 0){pre.results[,1] <- seq(MINS[1], MINS[2], DIFF/10)
} else if(MINS[1]-(DIFF/2) < 0){pre.results[,1] <- seq(MINS[1]*0.5, MINS[1]*1.5, MINS[1]/10)
} else {pre.results[,1] <- seq(MINS[1]-(DIFF/2), MINS[1]+(DIFF/2), DIFF/10)}

#Loop over set alpha values
for(alpha in pre.results[,1]){
tmp.glm <- cv.glmnet(x = tmp.meth, y = age, nfolds = nrow(tmp.meth), alpha = alpha, type.measure = "mae", family = "gaussian", grouped = FALSE)
pre.results[pre.results$alpha == alpha,2] <- min(tmp.glm$cvm)
}

#Get the data from the optimal alpha
tmp.alpha <- pre.results[order(pre.results$MAE),1][1]
tmp.glm <- cv.glmnet(x = tmp.meth, y = age, nfolds = nrow(tmp.meth), alpha = tmp.alpha, type.measure = "mae", family = "gaussian", grouped = FALSE)
tmp.MAE <- min(tmp.glm$cvm)
tmp.slope <- coef(tmp.glm)[-1,1]
glmnet.results <- rbind(glmnet.results, c(tmp.alpha, tmp.MAE, length(tmp.slope[which(tmp.slope != 0)]), paste(names(tmp.slope[which(tmp.slope != 0)]),collapse=' ')))

glmnet.results <- glmnet.results[-1,]
write.table(glmnet.results, file=args[2], col.names=F, row.names=F, quote=F, sep="\t")
