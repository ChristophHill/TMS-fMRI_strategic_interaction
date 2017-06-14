clear variables

%Code to get subject-level logistic regression estimates for Figure 2B
%---------------------------------------------------------------------
%Processes subject raw choice data.
%The output of this script is used by 'Make_Figure2_B'
%Christopher Hill, June 2017

%Define root path
%Enter your path to the analysis folder
%-------------------------------------%
fullPath = pwd; 
dataPath = [fullPath(1:end-46),'/data/Raw_data']; 

%Define array size
SubVec = 29;
RunVec = 2;

%Path to raw choice data
cond_path{1} = '/cTBS-vertex/Matlab';
cond_path{2} = '/cTBS-rTPJ/Matlab';


for cond = 1:2
    for sub = 1:SubVec
        
        choices_yee = [];
        choices_yer = [];
        
        for run = 1:RunVec
            %Load raw data of runs with no missing trials
            load([dataPath,cond_path{cond},'/fMRI_pair_S',num2str(sub),'.mat']);
            tmp_choices_yee = eval(['Run_' num2str(run), '.choices_yee']);
            tmp_choices_yer = eval(['Run_' num2str(run), '.choices_yer']);
            %Append vector to reconstruct choice array
            choices_yee = [choices_yee tmp_choices_yee];
            choices_yer = [choices_yer tmp_choices_yer];
        end
        
        
        %-----------------------------------
        %EXTRACT LOGISTIC ESTIMATES FROM RAW
        %-----------------------------------
        %Extract data previous choice data for AR(1)
        choices_yee1 = choices_yee(1:end-1)';
        choices_yer1 = choices_yer(1:end-1)';
        choices_yee0 = choices_yee(2:end)';
        
        %Run the Logistic regression
        y = choices_yee0;
        x = [choices_yee1 choices_yer1];
        betas_yee = glmfit(x,y,'binomial','link','logit');
        
        
        %IMPORTANT NOTE:
        %because '1' is 'shirk' we need to invert the estimates
        %to obtain log odds ratios of 'work' as presented in Figure 2B.
        %Effect of own choice
        betas_yee_own(cond, sub) = betas_yee(2)*-1;
        %Effect of opponent choice
        betas_yee_other(cond, sub) = betas_yee(3)*-1;
        
        
    end
end


%Save Logistic estimates in "Processed_data" file
%------------------------------------------------
LogitBeta.Control_yee_self = betas_yee_own(1, :); 
LogitBeta.Control_yee_other = betas_yee_other(1, :);
LogitBeta.Active_yee_self = betas_yee_own(2, :); 
LogitBeta.Active_yee_other = betas_yee_other(2, :);  

SavePath = [fullPath(1:end-46),'/data/Processed_data/Logistic_model_params']; 
save([SavePath,'/LogitBeta.mat'],'LogitBeta'); 
