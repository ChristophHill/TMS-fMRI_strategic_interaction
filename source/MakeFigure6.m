clear variables
%Code for Figure6 and statistical test
%---------------------------------------------------------------------
%Robust regression on the neural effects of cTBS with model parameters
%Christopher Hill, June 2017
fullPath = pwd; 
data_path = [fullPath(1:end-6),'data/Processed_data']; 


%Index the Neural data
%----------------------------------------------------------
load([data_path, '/Neural_betas/PPI_vmPFC_betas'])
betas_PPI_vmPFC_cTBSvertex = PPI.PPI_control; 
betas_PPI_vmPFC_cTBSrTPJ = PPI.PPI_active(1:28);
load([data_path, '/Neural_betas/PPI_dmPFC_betas'])
betas_PPI_dmPFC_cTBSvertex = PPI.PPI_control_dMPFC;
betas_PPI_dmPFC_cTBSrTPJ = PPI.PPI_active_dMPFC(1:28);
load([data_path, '/Neural_betas/TPJ_betas'])
betas_rTPJ_cTBSvertex = TPJ.betas_value_TPJ_vertex;
betas_rTPJ_cTBSrTPJ = TPJ.betas_value_TPJ_rTPJ(1:28);

%Load Influence model parameters 
%We average parameters estimated over the two fMRI sessions 
%----------------------------------------------------------
load([data_path, '/Influence_model_params/rJags_Influence_params.mat'])
kappa_cTBSVertex_m = (JAGS_HBM.kappa_vertex(2, :)+JAGS_HBM.kappa_vertex(1, :))/2;
kappa_cTBSrTPJ_m = (JAGS_HBM.kappa_rTPJ(2, :)+JAGS_HBM.kappa_rTPJ(1, :))/2;
eta_cTBSVertex_m = (JAGS_HBM.eta_vertex(2, :)+JAGS_HBM.eta_vertex(1, :))/2;
eta_cTBSrTPJ_m = (JAGS_HBM.eta_rTPJ(2, :)+JAGS_HBM.eta_rTPJ(1, :))/2;

%Build the GLM table
%We z-score Kappa and Eta for visual comparability in the Figure
%---------------------------------------------------------------
GLM_data(:,1) = [zeros(29,1); ones(28,1)]; %Dummy code stim condition
GLM_data(:,2) = zscore([kappa_cTBSVertex_m kappa_cTBSrTPJ_m(1:28)]);
GLM_data(:,3) = zscore([eta_cTBSVertex_m eta_cTBSrTPJ_m(1:28)]);
GLM_data(:,4) = zscore([betas_PPI_vmPFC_cTBSvertex ; betas_PPI_vmPFC_cTBSrTPJ]); 
GLM_data(:,5) = zscore([betas_PPI_dmPFC_cTBSvertex ; betas_PPI_dmPFC_cTBSrTPJ]); 
GLM_data(:,6) = zscore([betas_rTPJ_cTBSvertex ; betas_rTPJ_cTBSrTPJ]); 
GLM_table = dataset({GLM_data, 'Condition', 'Kappa','Eta','Beta_PPI_vmPFC','Beta_PPI_dmPFC','Beta_rTPJ'});

%Data exploration and Validating modeling assumptions
%--------------------------------------------------------------------------------
%Here we investigate relationships between Neural effects and model parameters in
%the cTBS-rTPJ condition. The hypothesis is that the more inhibited the vmPFC-rTPJ 
%connectivity as a result of cTBS-rTPJ, the lower the Kappa. 
%--------------------------------------------------------------------------------
%Simple visual inspection
data_inspection = figure('color',[1 1 1]);
set(data_inspection, 'Position', [100 100 1100 400])
subplot(1,3,1)
scatter(betas_PPI_vmPFC_cTBSrTPJ, kappa_cTBSrTPJ_m(1:28))
title('Kappa to rTPJ-vmPFC betas in cTBS-rTPJ')

%There is a pronounced bivariate outlier. We opt for robust regression
%---------------------------------------------------------------------
%We test both robust and standard OLS model to plot residuals
vmPFC_PPI_cTBSrTPJ_robust = fitlm(GLM_table,'Beta_PPI_vmPFC~Kappa+Eta','RobustOpts','on','Exclude',GLM_table.Condition==0);
vmPFC_PPI_cTBSrTPJ_normal = fitlm(GLM_table,'Beta_PPI_vmPFC~Kappa+Eta','RobustOpts','off','Exclude',GLM_table.Condition==0);
%We inspect residuals to validate our modeling choice
subplot(1,3,2)
plotResiduals(vmPFC_PPI_cTBSrTPJ_robust,'probability')
subplot(1,3,3)
plotResiduals(vmPFC_PPI_cTBSrTPJ_normal,'probability')

%Run the same regression models for rTPJ and dmPFC in cTBS-rTPJ condition
%------------------------------------------------------------------------
rTPJ_PPI_cTBSrTPJ_robust = fitlm(GLM_table,'Beta_rTPJ~Kappa+Eta','RobustOpts','on','Exclude',GLM_table.Condition==0); 
dmPFC_PPI_cTBSrTPJ_robust = fitlm(GLM_table,'Beta_PPI_dmPFC~Kappa+Eta','RobustOpts','on','Exclude',GLM_table.Condition==0); 

%Test the full models for condition-specificity (the interaction)
%----------------------------------------------------------------
rTPJ_betas = fitlm(GLM_table,'Beta_rTPJ~Eta*Condition+Kappa*Condition','RobustOpts','on'); 
dmPFC_PPI_betas = fitlm(GLM_table,'Beta_PPI_dmPFC~Kappa*Condition+Eta*Condition','RobustOpts','on'); 
vmPFC_PPI_betas = fitlm(GLM_table,'Beta_PPI_vmPFC~Eta*Condition+Kappa*Condition','RobustOpts','on');
disp(rTPJ_betas)
disp(dmPFC_PPI_betas)
disp(vmPFC_PPI_betas) 

%Make Figure 6
%-------------
Mface_G = [0.9 0.9 0.9]; 
Mface_Gr1 = [0.6 0.6 0.6]; 
Mface_Gr2 = [0.9,0.2,0.2]; 
EB_vec = [1 2 3]; 
Figure_6 = figure('color',[1 1 1]);
set(Figure_6, 'Position', [500 500 1200 1500])
size = 20;
FN = 'Helvetiva';
EB_values = [table2array(rTPJ_betas .Coefficients(2:end,1)), table2array(rTPJ_betas.Coefficients(2:end,2))]; 

subplot(3,1,1, 'Parent',Figure_6,'XTickLabel',{'Eta','Eta*cTBS','Kappa','Kappa*cTBS'},'XTick',[2 3 4 5],'FontSize',size,...
    'FontName',FN)
hold on

%h(1) = bar(1, EB_values(1,1), 'FaceColor',Mface_G,'EdgeColor', Mface_G);
h(2) = bar(4, EB_values(2,1), 'FaceColor',Mface_Gr2,'EdgeColor', Mface_Gr2); 
h(3) = bar(2, EB_values(3,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 
h(4) = bar(5, EB_values(4,1), 'FaceColor',Mface_Gr2,'EdgeColor', Mface_Gr2); 
h(5) = bar(3, EB_values(5,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 

%plot([1 1], [EB_values(1,1)-EB_values(1,2); EB_values(1,1)+EB_values(1,2)],'k','linewidth',2)
plot([4 4], [EB_values(2,1)-EB_values(2,2); EB_values(2,1)+EB_values(2,2)],'k','linewidth',2)
plot([2 2], [EB_values(3,1)-EB_values(3,2); EB_values(3,1)+EB_values(3,2)],'k','linewidth',2)
plot([5 5], [EB_values(4,1)-EB_values(4,2); EB_values(4,1)+EB_values(4,2)],'k','linewidth',2)
plot([3 3], [EB_values(5,1)-EB_values(5,2); EB_values(5,1)+EB_values(5,2)],'k','linewidth',2)

ylabel('Estimates for rTPJ (a.u)','FontSize',size,'FontName',FN);

ylim([-3.5 3.5])
%---
EB_values = [table2array(dmPFC_PPI_betas.Coefficients(2:end,1)), table2array(dmPFC_PPI_betas.Coefficients(2:end,2))]; 


subplot(3,1,2, 'Parent',Figure_6,'XTickLabel',{'Eta','Eta*cTBS','Kappa','Kappa*cTBS'},'XTick',[2 3 4 5],'FontSize',size,...
    'FontName',FN)
hold on

%h(1) = bar(1, EB_values(1,1), 'FaceColor',Mface_G,'EdgeColor', Mface_G);
h(2) = bar(4, EB_values(2,1), 'FaceColor',Mface_Gr2,'EdgeColor', Mface_Gr2); 
h(3) = bar(2, EB_values(3,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 
h(4) = bar(5, EB_values(4,1), 'FaceColor',Mface_Gr2,'EdgeColor', Mface_Gr2); 
h(5) = bar(3, EB_values(5,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 

%plot([1 1], [EB_values(1,1)-EB_values(1,2); EB_values(1,1)+EB_values(1,2)],'k','linewidth',2)
plot([4 4], [EB_values(2,1)-EB_values(2,2); EB_values(2,1)+EB_values(2,2)],'k','linewidth',2)
plot([2 2], [EB_values(3,1)-EB_values(3,2); EB_values(3,1)+EB_values(3,2)],'k','linewidth',2)
plot([5 5], [EB_values(4,1)-EB_values(4,2); EB_values(4,1)+EB_values(4,2)],'k','linewidth',2)
plot([3 3], [EB_values(5,1)-EB_values(5,2); EB_values(5,1)+EB_values(5,2)],'k','linewidth',2)

ylabel('Estimates for rTPJ-dmPFC (a.u)','FontSize',size,'FontName',FN);

ylim([-3.5 3.5])

%---
EB_values = [table2array(vmPFC_PPI_betas .Coefficients(2:end,1)), table2array(vmPFC_PPI_betas .Coefficients(2:end,2))]; 


subplot(3,1,3, 'Parent',Figure_6,'XTickLabel',{'Eta','Eta*cTBS','Kappa','Kappa*cTBS'},'XTick',[2 3 4 5],'FontSize',size,...
    'FontName',FN)
hold on

%h(1) = bar(1, EB_values(1,1), 'FaceColor',Mface_G,'EdgeColor', Mface_G);
h(2) = bar(4, EB_values(2,1), 'FaceColor',Mface_Gr2,'EdgeColor', Mface_Gr2); 
h(3) = bar(2, EB_values(3,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 
h(4) = bar(5, EB_values(4,1), 'FaceColor',Mface_Gr2,'EdgeColor', Mface_Gr2); 
h(5) = bar(3, EB_values(5,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 

%plot([1 1], [EB_values(1,1)-EB_values(1,2); EB_values(1,1)+EB_values(1,2)],'k','linewidth',2)
plot([4 4], [EB_values(2,1)-EB_values(2,2); EB_values(2,1)+EB_values(2,2)],'k','linewidth',2)
plot([2 2], [EB_values(3,1)-EB_values(3,2); EB_values(3,1)+EB_values(3,2)],'k','linewidth',2)
plot([5 5], [EB_values(4,1)-EB_values(4,2); EB_values(4,1)+EB_values(4,2)],'k','linewidth',2)
plot([3 3], [EB_values(5,1)-EB_values(5,2); EB_values(5,1)+EB_values(5,2)],'k','linewidth',2)

ylabel('Estimates for rTPJ-vmPFC (a.u)','FontSize',size,'FontName',FN);
ylim([-3.5 3.5])

