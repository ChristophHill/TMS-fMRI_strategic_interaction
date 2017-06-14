library(ggplot2)

#-----------------------------------------------------------------------------------------------
#Note : because MCMC is a probabilistic methods, methods will (slightly) vary over estimations
#-----------------------------------------------------------------------------------------------
#Christopher Hill, June 2017
#These results have been estimated with the script "Get_ModelEstimates.R" in source/Get_processed_data/Computational_modeling 
#Change the file names to load if you re-estimate the model. 
#This script may be adapted to make inference on the parameters of different models (e.g. Reinforcement Learning, Fictitious play...)

WD <- getwd()
WD = unlist(strsplit(WD, split='/source', fixed=TRUE))


#Load the Datasets containing the chains
load(file.path(WD,"data/Processed_data/Influence_model_params/source_rJAGS_InfluenceLearning_cTBS-vertex_R1.RData"))
chainsVertex1 = rbind(results$mcmc[[1]], results$mcmc[[2]], results$mcmc[[3]])
load(file.path(WD,"data/Processed_data/Influence_model_params/source_rJAGS_InfluenceLearning_cTBS-vertex_R2.RData"))
chainsVertex2 = rbind(results$mcmc[[1]], results$mcmc[[2]], results$mcmc[[3]])
load(file.path(WD,"data/Processed_data/Influence_model_params/source_rJAGS_InfluenceLearning_cTBS-rTPJ_R1.RData"))
chainsrTPJ1 = rbind(results$mcmc[[1]], results$mcmc[[2]], results$mcmc[[3]])
load(file.path(WD,"data/Processed_data/Influence_model_params/source_rJAGS_InfluenceLearning_cTBS-rTPJ_R2.RData"))
chainsrTPJ2 = rbind(results$mcmc[[1]], results$mcmc[[2]], results$mcmc[[3]])

#Combine both runs and bind data
kappa_yee_vertex = (chainsVertex1[,"kappa_yee.mu"] + chainsVertex2[,"kappa_yee.mu"])/2
kappa_yee_rTPJ = (chainsrTPJ1 [,"kappa_yee.mu"] + chainsrTPJ2[,"kappa_yee.mu"])/2

#Get histogram
hs1 = data.frame(hists = c(kappa_yee_vertex), Condition = factor(c(rep("cond1",1000*3))))
hs2 = data.frame(hists = c(kappa_yee_rTPJ), Condition = factor(c(rep("cond2",1000*3))))

v = c(kappa_yee_vertex, kappa_yee_rTPJ)
c = factor(c(rep("cond1",1000*3),rep("cond2",1000*3)))

hsall = data.frame(v,c)

Figure2_C = ggplot(hsall, aes(x=v, fill=c))+geom_density(alpha=.7, size=1) + xlim(0,0.15) +
  scale_fill_manual(values=c("#0078dc", "Red")) +
  theme_classic() +
  theme(axis.title=element_text(size=10)) + theme(axis.text=element_text(size=10,face = "bold")) +
  ylab("Posterior density") + xlab(expression(kappa~'parameter')) + 
  theme(legend.position="none")+theme(axis.text=element_text(size = 43,face = "bold"))+theme(axis.title=element_text(size = 47,face = "bold"))

#Perform inference on the difference for the population-level distribution of Kappa for cTBS-rTPJ and cTBS-vertex
#----------------------------------------------------------------------------------------------------------------
#Get the approximated mcmc p-value, multiply by 2 for two-tail. 
p_value = mean((kappa_yee_rTPJ-kappa_yee_vertex)>0)*2
print(p_value)
Figure2_C
  