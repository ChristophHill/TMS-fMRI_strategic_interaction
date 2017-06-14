clear variables;
%Code for Figure1 C
%----------------------------------------------------------
%Model fits (D.I.C.) outputs from rJAGS added over sessions
%because rJAGS uses MCMC, a probabilistic method, these number may vary
%slightly over estimations
%Christopher Hill, June 2017

%Influence learning
DIC_cTBSvertex_inf = 5691; 
DIC_cTBSrTPJ_inf = 5389; 
%Fictitious play
DIC_cTBSvertex_fict = 5830;
DIC_cTBSrTPJ_fict = 5622;
%Reinforcement learning
DIC_cTBSvertex_rf = 5984;
DIC_cTBSrTPJ_rf = 5694;
%Mixed-equilibrium (random responding)
DIC_cTBSvertex_me = 5996;
DIC_cTBSrTPJ_me = 5633;


%Create figure1_C : Difference in model fits between the winning model and
%the rest of the model space.
%-------------------------------------------------------------------------
Figure1_C = figure('color',[1 1 1]); 
set(Figure1_C, 'Position', [100 100 800 1000])
FN = 'Helvetica';
size = 24;
color_inf_C = [0.2,0.2,0.9];
color_fict_C = [0.1,0.1,0.5];
color_me_C = [0.1,0.1,0.2];
color_rf_C = [0.1,0.1,0.4];
color_inf_T = [0.9,0.2,0.2];
color_fict_T = [0.6,0.1,0.1];
color_me_T = [0.2,0.1,0.1];
color_rf_T = [0.4,0.1,0.1];

%Draw new model fit figure
subplot(2,1,2, 'Parent',Figure1_C,'XTickLabel',{'ME','RF','FICT', 'INF'},'XTick',[1 2 3 4],'FontSize',size,...
    'FontName',FN)
hold on

A(1) = bar(1, DIC_cTBSvertex_me-DIC_cTBSvertex_inf, 'FaceColor',color_me_T,'EdgeColor',color_me_T);
A(2) = bar(2, DIC_cTBSvertex_rf-DIC_cTBSvertex_inf, 'FaceColor',color_rf_T,'EdgeColor',color_rf_T);
A(3) = bar(3, DIC_cTBSvertex_fict-DIC_cTBSvertex_inf, 'FaceColor',color_fict_T,'EdgeColor',color_fict_T);
A(4) = bar(4, 0, 'FaceColor',color_rf_T,'EdgeColor',color_rf_T);

ylabel('D.I.C. difference','FontSize',size,'FontName',FN);
title('D.I.C. difference with INF in cTBS-Vertex')

subplot(2,1,1, 'Parent',Figure1_C,'XTickLabel',{'ME','RF','FICT', 'INF'},'XTick',[1 2 3 4],'FontSize',size,...
    'FontName',FN)
hold on

A(1) = bar(1, DIC_cTBSrTPJ_me-DIC_cTBSrTPJ_inf, 'FaceColor',color_me_C,'EdgeColor',color_me_C);
A(2) = bar(2, DIC_cTBSrTPJ_rf-DIC_cTBSrTPJ_inf, 'FaceColor',color_rf_C,'EdgeColor',color_rf_C);
A(3) = bar(3, DIC_cTBSrTPJ_fict-DIC_cTBSrTPJ_inf, 'FaceColor',color_fict_C,'EdgeColor',color_fict_C);
A(4) = bar(4, 0, 'FaceColor',color_rf_C,'EdgeColor',color_inf_C);

ylabel('D.I.C. difference','FontSize',size,'FontName',FN);
title('D.I.C. difference with INF in cTBS-rTPJ')



