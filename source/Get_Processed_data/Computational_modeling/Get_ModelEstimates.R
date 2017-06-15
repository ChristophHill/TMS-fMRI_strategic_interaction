library(runjags)
library(R.matlab)

#You will need to install JAGS and then rJAGS on your computer. 
#https://cran.r-project.org/web/packages/rjags/rjags.pdf
#Christopher Hill, June 2017. For questions: Christoph.hill0@gmail.com
#---------------------------------------------------------------------



#-----------------------------------------------------------------------------------------
#-----------------------------DEFINE VARIABLES--------------------------------------------
#-----------------------------------------------------------------------------------------

#Select the model you wish to estimate 
#--------------------------------------
Model = 'rJAGS_InfluenceLearning'
#--------------------------------------

#Select the parameters you want to monitor 
#-------------------------------------------------------------------------------------------------------------------------
#This depends on the model you are using. Check the models.txt files to see what's possible. This is for InfluenceLearning
#You will need to select what to monitor based on the variables defined in the model .txt files. 
Monitor = c("eta_yee.mu", "eta_yee.kappa", "kappa_yee.mu", "kappa_yee.kappa", "beta_yee.mu", "beta_yee.kappa","deviance")
#-------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------
#Select how many burnin. The greater the number, the more precise the estimates but slower. 
#Results presented in the paper use 200000 burnin. This may take a couple of hours hours depending on computer. 
#It's important to verify that the chains converge, this may be looking at the PrFs in the 'results' summary. 
#PrFs should be < 1.05.  
#----------------------------------------------------------------------------------------------------------------
nburnin = 200000

#-----------------------------------------------------------------------------------------
#-------------------------RUN ESTIMATION AND SAVE-----------------------------------------
#-----------------------------------------------------------------------------------------

#Condition sub-paths
CondPath = list('cTBS-vertex','cTBS-rTPJ')

#Get full data path
WD <- getwd()
WD = unlist(strsplit(WD, split='/source', fixed=TRUE))

ModelPath <- file.path('rJAGS_models',Model)
SavePath <- file.path(WD[1],'data/Processed_data/Influence_model_params')

for (COND in 1:2){ #Loop over conditions
  DataPath <- file.path(WD[1],'data/Raw_data',unlist(CondPath[COND]),'rJAGS/rJAGSmat.mat')
  print(DataPath)
  for (Sess in 1:2){ #Loop over sessions
    
    #Select the data matrices
    #------------------------------------------------------
    aux = readMat(DataPath)
    listNames = names(aux)
    choices_yee_r1 = aux[[listNames]][[Sess]][1][[1]]
    choices_yer_r1 = aux[[listNames]][[Sess]][2][[1]]
    choices_yee = choices_yee_r1[,2:dim(choices_yee_r1)[2]]
    choices_yer = choices_yer_r1[,2:dim(choices_yer_r1)[2]]
    #------------------------------------------------------
    
    #Insert the matrices in an rJAGS-compatible data structure
    dat <- dump.format(list(
      choices_yee = choices_yee
      , choices_yer = choices_yer
      , T = dim(choices_yee)[1]
      , S = dim(choices_yee)[2]
    ))
    
    #We use three chains to ensure to make sure we converge with the chains
    #If the PrFs (Gelman-Rubin criterion) are below 1.05, this confirms chain convergence. We use three different rnd generators as an extra layer of caution
    inits1 <- dump.format(list(eta_yee.mu=0.1, eta_yee.kappa=10, kappa_yee.mu=0.1, kappa_yee.kappa=10, beta_yee.mu=0.1, beta_yee.kappa=10, .RNG.name="base::Super-Duper", .RNG.seed=999 ))
    inits2 <- dump.format(list(eta_yee.mu=0.1, eta_yee.kappa=10, kappa_yee.mu=0.1, kappa_yee.kappa=10, beta_yee.mu=0.1, beta_yee.kappa=10, .RNG.name="base::Wichmann-Hill", .RNG.seed=666 ))
    inits3 <- dump.format(list(eta_yee.mu=0.1, eta_yee.kappa=10, kappa_yee.mu=0.1, kappa_yee.kappa=10, beta_yee.mu=0.1, beta_yee.kappa=10, .RNG.name="base::Mersenne-Twister", .RNG.seed=6666 ))
    #Run the model with the chains
    results <- run.jags(model=ModelPath, monitor=Monitor,data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", module=c("dic"), burnin=nburnin, sample=1000, thin=nburnin/1000)
    
    #Save the outputs of the monitor into the Processed_data sub-folder
    #-------------------------------------------------------------------
    SaveName = paste('results_',Model,'_',CondPath[COND],'_R',as.character(Sess),'.Rdata',sep="")[1]
    save(results, file=file.path(SavePath,SaveName))
    print(SaveName)
    print(results)
    
  }
}










