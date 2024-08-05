#!/bin/bash

#Usage glmnet_loop.sh
#glmnet_loop.sh input.csv output.txt iterations loci threads

#Define variables
CSV=$1
OUT=$2
ITER=$3
LOCI=$4
THREADS=${5:-10}

#Checking to make sure output does not end in .tmp
if [[ $(echo $OUT | grep -o "...$") == ".tmp" ]]; then echo "Please change output so that it does not end in .tmp"; exit 1; fi

#Make output file
echo -e "alpha\tMAE\tnumber_of_loci\tloci" > $OUT

#Prep R run
echo "Preparing the data"
Rscript ~/bin/glmnet_prep.r $CSV

#Run loop
echo "Running iterations"
time seq 1 $ITER | xargs -I{} -P $THREADS Rscript ~/bin/glmnet_loop.r $LOCI {}.tmp

cat *.tmp >> $OUT
rm *.tmp
