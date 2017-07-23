clear variables;

%Code for Figure1 D and statistical test
%---------------------------------------
%Effect of Kappa and Eta on Payoff. 
%Christopher Hill, June 2017
% fullPath = pwd; 
% data_path = [fullPath(1:end-6),'data/Processed_data']; 

%Load data for parameter Eta and Kappa
filePath = '../data/Processed_data/Influence_model_params/rJags_Influence_params.mat';
filePath = strrep(filePath, '/', filesep);
load(filePath);

%Process HBM params. 
%We average parameters estimated over the two fMRI sessions 
%-------------------------------------------------------------------------%
kappa_cTBSVertex_m = (JAGS_HBM.kappa_vertex(2, :)+JAGS_HBM.kappa_vertex(1, :))/2;
kappa_cTBSrTPJ_m = (JAGS_HBM.kappa_rTPJ(2, :)+JAGS_HBM.kappa_rTPJ(1, :))/2;
eta_cTBSVertex_m = (JAGS_HBM.eta_vertex(2, :)+JAGS_HBM.eta_vertex(1, :))/2;
eta_cTBSrTPJ_m = (JAGS_HBM.eta_rTPJ(2, :)+JAGS_HBM.eta_rTPJ(1, :))/2;

%Load Payoff data
%-------------------------------------------------------------------------%
dataPath = '../data/Processed_data/';
dataPath = strrep(dataPath, '/', filesep);
load([dataPath, '/Payoffs/Mean_Subject_Payoffs.mat'])

%Build the GLM table
%We z-score Kappa and Eta for visual comparability in the Figure
%-------------------------------------------------------------------------%
GLM_data(:,1) = [zeros(29,1); ones(29,1)]; %Dummy code stim condition
GLM_data(:,2) = zscore([kappa_cTBSVertex_m kappa_cTBSrTPJ_m]);
GLM_data(:,3) = zscore([eta_cTBSVertex_m eta_cTBSrTPJ_m]);
GLM_data(:,4) = [Payoff.vertex_yee Payoff.rTPJ_yee]; 
GLM_table = dataset({GLM_data, 'Condition', 'Kappa','Eta','Payoff'}); 

%Estimate the model and perform inference
%-------------------------------------------------------------------------%
mdl_Figure1_D = fitlm(GLM_table,'Payoff~Condition+Kappa+Eta'); 
disp(mdl_Figure1_D)

%Create the Figure with regression coefficients
%-------------------------------------------------------------------------%
FN = 'Helvetica';
size = 16;
Mface_Gr1 = [0.6 0.6 0.6]; 
Figure1_D = figure('color',[1 1 1]); 
EB_values = [table2array(mdl_Figure1_D .Coefficients(2:end,1)), table2array(mdl_Figure1_D .Coefficients(2:end,2))]; 

subplot(1,1,1, 'Parent',Figure1_D,'XTickLabel',{'Eta','Kappa'},'XTick',[1 2],'FontSize',size,'FontName',FN)
hold on

h(2) = bar(2, EB_values(2,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 
h(3) = bar(1, EB_values(3,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 
plot([2 2], [EB_values(2,1)-EB_values(2,2); EB_values(2,1)+EB_values(2,2)],'k','linewidth',2)
plot([1 1], [EB_values(3,1)-EB_values(3,2); EB_values(3,1)+EB_values(3,2)],'k','linewidth',2)

ylabel('Estimates (a.u)','FontSize',size,'FontName',FN);
title('Effects of model parameters on Payoffs')





