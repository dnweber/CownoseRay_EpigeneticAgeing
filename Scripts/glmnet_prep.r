#!/bin/R
args <- commandArgs(trailingOnly=TRUE)

#Load Data
dat <- read.csv(args[1], head=TRUE)
age <- dat[,ncol(dat)]
meth <- as.matrix(dat[,2:(ncol(dat)-1)])

#Removing columns with no variation
tmp.len <- apply(meth, 2, function(x) length(table(x)))
meth <- meth[,which(tmp.len > 1)]

#Save datafiles
save(age, file="age_R.gz", compress=T)
save(meth, file="meth_R.gz", compress=T)
