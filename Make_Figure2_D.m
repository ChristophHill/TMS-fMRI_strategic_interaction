clear variables;
%Code for Figure2 D and statistical test
%------------------------------------------------
%GLM linking model-free to model-based parameters
%Christopher Hill, June 2017

%Load the Logit estimates, the Switch rates, and the Influence parameters
%-------------------------------------------------------------------------%
load([pwd,'/Processed_data/Logistic_model_params/LogitBeta.mat'])
load([pwd, '/Processed_data/Switch_rates/Mean_Subjects_SwitchRates.mat'])
load([pwd, '/Processed_data/Influence_model_params/rJags_Influence_params.mat'])

%Prepare the variables
cTBSvertex_switch = Switch_rate.control;
cTBSrTPJ_switch = Switch_rate.active;
kappa_cTBSVertex_m = (JAGS_HBM.kappa_vertex(2, :)+JAGS_HBM.kappa_vertex(1, :))/2;
kappa_cTBSrTPJ_m = (JAGS_HBM.kappa_rTPJ(2, :)+JAGS_HBM.kappa_rTPJ(1, :))/2;
eta_cTBSVertex_m = (JAGS_HBM.eta_vertex(2, :)+JAGS_HBM.eta_vertex(1, :))/2;
eta_cTBSrTPJ_m = (JAGS_HBM.eta_rTPJ(2, :)+JAGS_HBM.eta_rTPJ(1, :))/2;

%Make data table.
%We z-score predictors for visual purpose for the figure
%--------------------------------------------------------
GLM_data(:,1) = [zeros(29,1); ones(29,1)]; 
GLM_data(:,2) = zscore([LogitBeta.Control_yee_self LogitBeta.Active_yee_self]);
GLM_data(:,3) = zscore([LogitBeta.Control_yee_other LogitBeta.Active_yee_other]);
GLM_data(:,4) = zscore([cTBSvertex_switch;cTBSrTPJ_switch]);
GLM_data(:,5) = zscore([kappa_cTBSVertex_m kappa_cTBSrTPJ_m]);
GLM_data(:,6) = zscore([eta_cTBSVertex_m eta_cTBSrTPJ_m]);
GLM_table = dataset({GLM_data, 'Condition', 'Effect_of_OwnAction', 'Effect_of_OppAction','Switch_rate','Kappa','Eta'}); 


%Estimate the model and perform inference
%-------------------------------------------------------------------------%
%Switch rates are positively associated with Kappa
mdl_Figure2_D_panel1 = fitlm(GLM_table,'Switch_rate~Condition+Kappa+Eta');
%Effect of Own action is positively associated with Kappa and negatively with Eta
mdl_Figure2_D_panel2 = fitlm(GLM_table,'Effect_of_OwnAction~Condition+Kappa+Eta'); 
%Additional analysis (not presented in the paper) showing that first-order learning rate ETA is
%positively associated with the effect of the opponent's action
mdl_additional = fitlm(GLM_table,'Effect_of_OppAction~Condition+Kappa+Eta'); 

%display model outputs
disp(mdl_Figure2_D_panel1)
disp(mdl_Figure2_D_panel2)



%Create the Figure with regression coefficients
%-------------------------------------------------------------------------%
FN = 'Helvetica';
size = 20;
Mface_Gr1 = [0.6 0.6 0.6]; 
Figure2_D = figure('color',[1 1 1]); 
set(Figure2_D, 'Position', [100 100 800 400])
EB_values = [table2array(mdl_Figure2_D_panel1.Coefficients(2:end,1)), table2array(mdl_Figure2_D_panel1.Coefficients(2:end,2))]; 

subplot(1,2,1, 'Parent',Figure2_D,'XTickLabel',{'Eta','Kappa'},'XTick',[1 2],'FontSize',size,'FontName',FN)
hold on

h(2) = bar(2, EB_values(2,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 
h(3) = bar(1, EB_values(3,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 
plot([2 2], [EB_values(2,1)-EB_values(2,2); EB_values(2,1)+EB_values(2,2)],'k','linewidth',2)
plot([1 1], [EB_values(3,1)-EB_values(3,2); EB_values(3,1)+EB_values(3,2)],'k','linewidth',2)
ylim([-1 1])
ylabel('Estimates (a.u)','FontSize',size,'FontName',FN);
title('Switch rates')

EB_values = [table2array(mdl_Figure2_D_panel2.Coefficients(2:end,1)), table2array(mdl_Figure2_D_panel2.Coefficients(2:end,2))]; 

subplot(1,2,2, 'Parent',Figure2_D,'XTickLabel',{'Eta','Kappa'},'XTick',[1 2],'FontSize',size,'FontName',FN)
hold on

h(2) = bar(2, EB_values(2,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 
h(3) = bar(1, EB_values(3,1), 'FaceColor',Mface_Gr1,'EdgeColor', Mface_Gr1); 
plot([2 2], [EB_values(2,1)-EB_values(2,2); EB_values(2,1)+EB_values(2,2)],'k','linewidth',2)
plot([1 1], [EB_values(3,1)-EB_values(3,2); EB_values(3,1)+EB_values(3,2)],'k','linewidth',2)
ylim([-1 1])
ylabel('Estimates (a.u)','FontSize',size,'FontName',FN);
title('Effect of own action')




