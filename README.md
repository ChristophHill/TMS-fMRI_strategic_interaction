[![DOI](https://zenodo.org/badge/93639776.svg)](https://zenodo.org/badge/latestdoi/93639776)

# Correction
* There is a mistake in supplementary figure 2 (and the legend) which wrongfully shows that the ME for the worker is p(work)=.5. It should be p(work)=0.2 and the ME for the boss is p(inspect)=0.5. The line of the plot should be redrawn to the correct level and the sentence should be corrected. This does not affect the models or the analysis, but it does turn over the interpretation - workers work too often! 

# TMS-fMRI_strategic_interaction 

Code release 1.0.0

Welcome. This repository contains Matlab and R code to replicate all figures and pipelines to estimate the computational models, as well as compressed fMRI t-maps. I hope it will serve future researcher interested in the topic of dyadic competitive interactions. If you plan to use the data for a project or come up with a new model to capture these complex behaviours, I would be interested to learn about it. Drop me an email at Christoph.hill0ATgmail.com. Special thanks to Shinsuke Suzuki and Rafael Polania who have contributed to code for this project. 

What you will need to run the code for the figures: 
* Up to date version of Matlab with statistical toolbox 
* R, with ggplot package (http://ggplot2.org) 

In addition: 

For estimating computational models in the hierarchical bayesian method. 
* JAGS (http://mcmc-jags.sourceforge.net)
* rJAGS cran package (https://cran.r-project.org/web/packages/rjags/index.html) 
* R.Matlab to read the .mat files (https://cran.r-project.org/web/packages/R.matlab/R.matlab.pdf) 

To read the fMRI results. 
* SPM8 or SPM12 (http://www.fil.ion.ucl.ac.uk/spm/software/) 
* SnPM (http://www2.warwick.ac.uk/fac/sci/statistics/staff/academic-research/nichols/software/snpm)

# Generate Figures

The figure-generating code is organized by figure panels, with naming conventions are as follows: 
For Figure panel 1 D, the script is called MakeFigure1_D. 
Running the figure scripts will generate all statistical tests associated with the current figure panel. 

The figure-generating scripts are named as follow:

* ```MakeFigure1_C.m```
* ```MakeFigure1_D.m```
* ```MakeFigure2_A.m```
* ```MakeFigure2_B.m```
* ```MakeFigure2_C.R (This is an R script)``` 
* ```MakeFigure2_D.m```
* ```MakeFigure3_B.m```
* ```MakeFigure4_A.m```
* ```MakeFigure4_B.m```
* ```MakeFigure5_B.m```
* ```MakeFigure6.m```

# Process choice data and estimate hierarchical models

You may also extract the processed data from the raw choice data directly, which will then be used by the figure-generating code. 
For this, use the following Matlab script located under source/Get_Processed_data/Behavioral_modeling

* ```Get_PayoffAndSwitchRates.m``` 
* ```Get_LogitEstimates.m```

To estimate the computational models, go to source/Get_Processed_data/Computational_modeling, and use:

* ```Get_ModelEstimates.R```

In the rJAGS_models folder, you will find .txt files containing the hierarchical models for: 

* Influence Learning
* Fictitious play
* Mixed Equilibrium
* Reinforcement Learning
* Influence Mixture (Mixture model between Influence Learning and Mixed-Equilibrium)

You will need to specify in Get_ModelEstimates.R which of these models you wish to estimate and what parameters to monitor. The file is set by default to estimate Influence Learning. 

I have tried to simplify and annote the code in the clearest way possible, and it should all run out of the box provided you have the prerequisit packages up and running. For Windows users, you will need to replace / by \ in the path directories. If you discover bugs or errors, please let me know. I may still update this repo as time goes by. 


