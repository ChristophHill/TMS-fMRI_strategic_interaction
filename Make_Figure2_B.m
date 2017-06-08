clear variables;
%Code for Figure2 B and statistical test
%------------------------------------------------
%Estimates from subject-level logistic regression
%Christopher Hill, June 2017

%Load logistic estimates for each subject 
%--------------------------------------------------------------------------------------%
%These are outputs from AR(1) logistic model in Matlab define as that : 
%Subject choice at t+1 = intercept+Beta(Subject choice at t)+Beta(Opponent choice at t)
%With naming conventions: 
%yee_self = Beta(Subject choice at t)
%yee_other = Beta(Opponent choice at t)
%And Prefixes: 
%Active = cTBS-rTPJ condition
%Control = cTBS-rTPJ condition
%--------------------------------------------------------------------------------------%
load([pwd,'/Processed_data/Logistic_model_params/LogitBeta.mat'])

%Make data table
%--------------------------------------------
GLM_data(:,1) = [zeros(29,1); ones(29,1)]; 
GLM_data(:,2) = [LogitBeta.Control_yee_self LogitBeta.Active_yee_self];
GLM_data(:,3) = [LogitBeta.Control_yee_other LogitBeta.Active_yee_other];
GLM_table = dataset({GLM_data, 'Condition', 'Effect_of_OwnAction', 'Effect_of_OppAction'}); 

%Estimate the model and perform inference
%-------------------------------------------------------------------------%
mdl1_Figure2_B = fitlm(GLM_table,'Effect_of_OwnAction~Condition'); 
disp(mdl1_Figure2_B)
%Control for the reactivity to the opponent's action
mdl2_Figure2_B = fitlm(GLM_table,'Effect_of_OwnAction~Condition+Effect_of_OppAction'); 
disp(mdl2_Figure2_B)
%Test for equality of variance 

%Variance test
Condition = [zeros(29,1); ones(29,1)]; 
Logit_self = [LogitBeta.Control_yee_self LogitBeta.Active_yee_self]';
p = vartestn(Logit_self,Condition,'TestType','LeveneAbsolute','display','off');
disp('Difference in variance for Effect of Own Action between condition...');
disp(['Levene test p-value ', num2str(p)]);


%-------------------------------------------
%Figure 2A "Logit regression" 
%-------------------------------------------
A = LogitBeta.Control_yee_other; 
B = LogitBeta.Active_yee_other; 
C = LogitBeta.Control_yee_self; 
D = LogitBeta.Active_yee_self; 

%Draw each individual points vertically
%-------------------------------------------
Figure2_B = figure('color',[1 1 1]); 
set(Figure2_B, 'Position', [100 100 1000 600])
axes1 = subplot(1, 1, 1, 'Parent',Figure2_B,...
    'XTickLabel',{'Opponent Action' 'Own Action'},...
    'XTick',[1.5 3.5],...
    'FontSize',20);

hold on
xlim([0 5])
%ylim([0.2 0.7])
col1 = [0.6 0.6 0.6]; 
col2 = [0.6 0.6 0.6]; 


color_control = [0.3,0.3,0.9];
color_TMS = [0.9,0.2,0.2];
Mface_control = [0.4,0.4,1];
Mface_TMS = [1,0.3,0.3];

%Draw reference line (0)
plot([0.01;5], [0 0],'color',[.9 .9 .9],'linewidth',10)

%1. Add individual datapoints
%----------------------------

for currPoint = 1:length(A)
plot(1,A(currPoint),'-x','MarkerFaceColor',col1,'MarkerEdgeColor',col2,'MarkerSize',10)
end 


for currPoint = 1:length(B)
plot(2,B(currPoint),'-x','MarkerFaceColor',col1,'MarkerEdgeColor',col2,'MarkerSize',10)
end 

for currPoint = 1:length(A)
plot(3,C(currPoint),'-x','MarkerFaceColor',col1,'MarkerEdgeColor',col2,'MarkerSize',10)
end 


for currPoint = 1:length(B)
plot(4,D(currPoint),'-x','MarkerFaceColor',col1,'MarkerEdgeColor',col2,'MarkerSize',10)
end 

%2. Draw 1 S.E whiskers around the mean
%--------------------------------------
seA = std(A)/sqrt(length(A)); 
seB = std(B)/sqrt(length(B));  
meanA = mean(A); 
meanB = mean(B);

%plot the bars
plot([1 1], [meanA-seA; meanA+seA],'k','linewidth',3)
plot([2 2], [meanB-seB; meanB+seB],'k','linewidth',3)
%plot the whiskers
plot([0.8;1.2], [meanA+seA meanA+seA],'k','linewidth',3)
plot([0.8;1.2], [meanA-seA meanA-seA],'k','linewidth',3)
plot([1.8;2.2], [meanB+seB meanB+seB],'k','linewidth',3)
plot([1.8;2.2], [meanB-seB meanB-seB],'k','linewidth',3)

seC = std(C)/sqrt(length(C)); 
seD = std(D)/sqrt(length(D));  
meanC = mean(C); 
meanD = mean(D);

%plot the bars
plot([3 3], [meanC-seC; meanC+seC],'k','linewidth',3)
plot([4 4], [meanD-seD; meanD+seD],'k','linewidth',3)
%plot the whiskers
plot([2.8;3.2], [meanC+seC meanC+seC],'k','linewidth',3)
plot([2.8;3.2], [meanC-seC meanC-seC],'k','linewidth',3)
plot([3.8;4.2], [meanD+seD meanD+seD],'k','linewidth',3)
plot([3.8;4.2], [meanD-seD meanD-seD],'k','linewidth',3)

%3. Add marker point
%--------------------------------------
plot([0.7;1.3], [meanA meanA],'linewidth',5,'color',color_control)
plot([1.7;2.3], [meanB meanB],'linewidth',5,'color',color_TMS)

plot([2.7;3.3], [meanC meanC],'linewidth',5,'color',color_control)
plot([3.7;4.3], [meanD meanD],'linewidth',5,'color',color_TMS)

%4. Add significance indicator
%-----------------------------
plot([3;4], [max(C)+max(C)/7 max(C)+max(C)/7],'k','linewidth',2)
plot([3 3], [max(C)+max(C)/7; max(C)+max(C)/10],'k','linewidth',2)
plot([4 4], [max(C)+max(C)/7; max(C)+max(C)/10],'k','linewidth',2)
plot(3.5,max(C)+max(C)/4,'-*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10)

title('Decomposing the influence of Own and Opponent choices between conditions','FontSize',20)
