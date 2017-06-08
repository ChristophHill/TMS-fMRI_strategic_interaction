clear variables;
%Code for Figure2 A and statistical test
%---------------------------------------
%Overall switch rate over the experiment 
%Christopher Hill, June 2017

%load the data
%--------------------------------------
load([pwd, '/Processed_data/Switch_rates/Mean_Subjects_SwitchRates.mat'])
cTBSvertex_switch = switch_rate.control;
cTBSrTPJ_switch = switch_rate.active;

%Build the GLM table
%-------------------------------------------------------------------------%
GLM_data(:,1) = [zeros(29,1); ones(29,1)]; %Dummy code stim condition
GLM_data(:,2) = [cTBSvertex_switch cTBSrTPJ_switch];
GLM_table = dataset({GLM_data, 'Condition', 'Switch_rate'}); 

%Estimate the model and perform inference
%-------------------------------------------------------------------------%
mdl_Figure2_A = fitlm(GLM_table,'Switch_rate~Condition'); 
disp(mdl_Figure2_A)


% PAPER FIGURES
%-------------------------------------------
%Figure 1A "Switch Rates" 
%-------------------------------------------
A = cTBSvertex_switch;
B = cTBSrTPJ_switch;

%Draw each individual points vertically
%-------------------------------------------

fS = 15; 

Figure2_A = figure('color',[1 1 1]); 
axes1 = subplot(1, 1, 1, 'Parent',Figure2_A,...
    'XTickLabel',{'cTBS-Vertex' 'cTBS-rTPJ'},...
    'XTick',[1 2],...
    'FontSize',20);

hold on
xlim([0 3])
ylim([0.2 0.7])
col1 = [0.6 0.6 0.6]; 
col2 = [0.6 0.6 0.6]; 

color_control = [0.3,0.3,0.9];
color_TMS = [0.9,0.2,0.2];
Mface_control = [0.4,0.4,1];
Mface_TMS = [1,0.3,0.3];


%1. Add individual datapoints
%----------------------------

for currPoint = 1:length(A)
plot(1,A(currPoint),'-x','MarkerFaceColor',col1,'MarkerEdgeColor',col2,'MarkerSize',10)
end 


for currPoint = 1:length(B)
plot(2,B(currPoint),'-x','MarkerFaceColor',col1,'MarkerEdgeColor',col2,'MarkerSize',10)
end 

%Draw figure showing individual datapoints, SE, and mean
%------------------------------------------------------


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

%3. Add marker point
%--------------------------------------
plot([0.7;1.3], [meanA meanA],'linewidth',5,'color',color_control)
plot([1.7;2.3], [meanB meanB],'linewidth',5,'color',color_TMS)

%4. Add significance indicator
%-----------------------------
plot([1;2], [max(A)+max(A)/20 max(A)+max(A)/20],'k','linewidth',2)
plot([1 1], [max(A)+max(A)/20; max(A)+max(A)/40],'k','linewidth',2)
plot([2 2], [max(A)+max(A)/20; max(A)+max(A)/40],'k','linewidth',2)
plot(1.5,max(A)+max(A)/15,'-*','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10)

ylim([.2 .8])
title('Switch rates','FontSize',20)
