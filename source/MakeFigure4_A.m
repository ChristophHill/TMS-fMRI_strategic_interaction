clear variables;
%Code for Figure 4 A
%------------------------------------------------------------------------
%Extracted neural betas (via MarsBar) from site ROI (see methods)
%All inference performed in SPM. This plot is for visualization only. 
%Christopher Hill, June 2017
%fMRI data for subject 29 in the cTBS-TPJ condition has been lost.
%All fMRI analysis are performed with 57 subjects. 
%------------------------------------------------------------------------
%This data represents the Influence update in dmPFC as a function of
%model-likelihoods (replication, Hampton (2008)). 
%all betas extracted at p=0.001. 
fullPath = pwd; 
data_path = [fullPath(1:end-6),'data/Processed_data']; 

%Load the betas
load([data_path,'/Neural_betas/dmPFC_x_modelfits.mat'])
%--------------------------------------------------------------------------------
%The structure cov contains Betas values and difference in model fits
%between Influence and Fictitious play model defined as: 
%Fitdiff = Balanced class accuracy Influence - Balanced class accuracy Fictitious
%--------------------------------------------------------------------------------

cTBSvertex_dmPFC_x_fits_betas=cov.betas_control_dMPFC-mean(cov.betas_control_dMPFC);  
cTBSrTPJ_dmPFC_x_fits_betas=cov.betas_active_dMPFC(1:28)-mean(cov.betas_active_dMPFC(1:28)); 
cTBSvertex_FitDiff=cov.LLfp_inf_control-mean(cov.LLfp_inf_control); 
cTBSrTPJ_FitDiff=cov.LLfp_inf_active-mean(cov.LLfp_inf_active); 

% Define general properties of figures.
%--------------------------------------
Medge = [0.2 0.2 0.2];
Mface_control = [0.4,0.4,1];
Mface_TMS = [1,0.3,0.3];


Figure4_A=figure('color',[1 1 1], 'Position', [500 500 1000 800]); 
axes1 = subplot(1, 1, 1, 'Parent',Figure4_A,'FontSize',25);

hold on;
A1 = cTBSvertex_dmPFC_x_fits_betas;
B1 = cTBSvertex_FitDiff;
A2 = cTBSrTPJ_dmPFC_x_fits_betas; 
B2 = cTBSrTPJ_FitDiff; 

%Get slope lines
slope1 = polyfit(B1, A1, 1);
slope2 = polyfit(B2, A2, 1);

%Draw the points
scatter(B1, A1, 100,'Marker', 'o', 'MarkerFaceColor',Mface_control,...
    'MarkerEdgeColor',Medge);
scatter(B2, A2, 100,'Marker', 'o', 'MarkerFaceColor',Mface_TMS,...
    'MarkerEdgeColor',Medge);


%Draw lines and set colors
D1 = refline(slope1);
D2 = refline(slope2);
set(D1, 'color',[0.2,0.2,1],'LineWidth', 2)
set(D2, 'color',[1,0.1,0.1],'LineWidth', 2)
xlim([-0.08 0.12]);
ylim([-2.5 2.5]);
title('dmPFC activity as a function of model fits')
ylabel('influence-related dmPFC betas (a.u)')
xlabel('Influence - Fictitious model fits')
