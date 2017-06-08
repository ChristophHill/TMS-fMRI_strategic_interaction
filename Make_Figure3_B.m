clear variables;
%Code for Figure 3 B
%--------------------------------------------------------------
%Extracted neural betas (via MarsBar) from stimulation site ROI
%All inference performed in SPM. This plot is for visualization only. 
%Christopher Hill, June 2017
%fMRI data for subject 29 in the cTBS-TPJ condition has been lost.
%All fMRI analysis are performed with 57 subjects. 
%------------------------------------------------------------------------
%This data represents the Influence update contrast betas for 
%cTBS-vertex>cTBS-rTPJ extracted at p=0.001 in FWE-error corrected 
%activation in the rTPJ search volume. 
%Christopher Hill, June 2017


load([pwd, '/Processed_data/Neural_betas/TPJ_betas'])
betas_rTPJ_cTBSvertex = TPJ.betas_value_TPJ_vertex;
betas_rTPJ_cTBSrTPJ = TPJ.betas_value_TPJ_rTPJ(1:28);

%Figure 2B "TMS EFFECT BETA" 
%-------------------------------------------
A = betas_rTPJ_cTBSvertex; 
B = betas_rTPJ_cTBSrTPJ; 

%Draw each individual points vertically
%-------------------------------------------

Figure3_B = figure('color',[1 1 1]); 
axes1 = subplot(1, 1, 1, 'Parent',Figure3_B,...
    'XTickLabel',{'cTBS-vertex' 'cTBS-rTPJ'},...
    'XTick',[1 2],...
    'FontSize',25);

hold on
xlim([0 3])
%ylim([0.2 0.7])
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

title('Effect of cTBS on rTPJ','FontSize',25)


