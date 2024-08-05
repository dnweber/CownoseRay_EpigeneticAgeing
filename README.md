# Weber et al. 2024 (Submitted to Scientific Reports)

Data and scripts/code associated with "Noninvasive, epigenetic age estimation in an elasmobranch, the cownose ray (*Rhinoptera bonasus*)" D. Nick Weber, Jennifer T. Wyffels, Chris Buckner, Robert George, F. Ed Latson, Veronique LePage, Kady Lyons, and David S. Portnoy. 2024. Submitted to Scientific Reports.

## Associated data can be found in the "Data" folder, including:
- "BBRF_percent_wide_FC.csv" contains the matrix of percent methylation values (post all filtering steps) for the fin clip samples, necessary to recreate the elastic net regression results.
- "BBRF_percent_wide_MU.csv" contains the matrix of percent methylation values (post all filtering steps) for the muscle tissue samples, necessary to recreate the elastic net regression results.
- "BBRF_percent_wide_BothTissues.csv" contains the matrix of percent methylation values (post all filtering steps) for the fin clip and muscle tissue samples, necessary to recreate the elastic net regression results.
- The final training and testing datasets (R objects) for all elastic net regression models presented in the manuscript.

## Associated code can be found in the "Scripts" folder, including:

- "ref_config.file" contains the code and parameters used to create a *de novo* reference genome for the cownose ray.
- "BAYES_GLM_wTissueSex.r" contains code associated with the Bayesian GLM run with 4,000 warm-up/sampling iterations.
- "BAYES_GLM_wTissueSex_50k.r" contains code associated with the Bayesian GLM run with 50,000 warm-up/sampling iterations.
- "95% CI's.Rmd" contains the code necessary to calculate 95% confidence intervals.
- The custom R script used to run elastic net regression involves the following scripts: "glmnet_loop.sh", "glmnet_prep.r", and "glmnet_loop.r". The script can be executed using the following:
    glmnet_loop.sh input.csv ouput.txt iterations loci cpu_threads
