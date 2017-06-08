library(ggplot2)

#--------------------------------------------------------------------------------------------
#Note : because MCMC is a probabilistic methods, methods may (slightly) vary over estimations
#--------------------------------------------------------------------------------------------
#Christopher Hill, June 2017

#Load the Datasets containing the chains
load("Processed_data/Influence_model_params/results_Vertex_run1.RData")
chainsVertex1 = rbind(results$mcmc[[1]], results$mcmc[[2]], results$mcmc[[3]])
load("Processed_data/Influence_model_params/results_Vertex_run2.RData")
chainsVertex2 = rbind(results$mcmc[[1]], results$mcmc[[2]], results$mcmc[[3]])
load("Processed_data/Influence_model_params/results_rTPJ_run1.RData")
chainsrTPJ1 = rbind(results$mcmc[[1]], results$mcmc[[2]], results$mcmc[[3]])
load("Processed_data/Influence_model_params/results_rTPJ_run2.RData")
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
  