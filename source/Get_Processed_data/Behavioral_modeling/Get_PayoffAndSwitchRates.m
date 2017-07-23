clear variables

%Code to get Payoffs and Switch rates (used for Figure 1C and 2A)
%---------------------------------------------------------------------
%Processes subject raw choice data.
%The output of this script is used by 'Make_Figure1_C' and 'Make_Figure2_A'
%Christopher Hill, June 2017

%Define root path
%Enter your path to the analysis folder
%-------------------------------------%
fullPath = pwd;
dataPath = [fullPath(1:end-46),'/data/Raw_data'];

%Define array size
SubVec = 29;
RunVec = 2;

%Define payoff matrix
payoff_mtrx_yee = [0,50;50,0];
payoff_mtrx_yer = [100,0;0,25];

%Path to raw choice data
cond_path{1} = '/cTBS-vertex/Matlab';
cond_path{2} = '/cTBS-rTPJ/Matlab';

for cond = 1:2
    for sub = 1:SubVec
        choices_yee = [];
        choices_yer = [];
        for run = 1:RunVec
            %Load raw data of all runs with no missing trials
            load([dataPath,cond_path{cond},'/fMRI_pair_S',num2str(sub),'.mat']);
            tmp_choices_yee = eval(['Run_' num2str(run), '.choices_yee']);
            tmp_choices_yer = eval(['Run_' num2str(run), '.choices_yer']);
            %Append vector to reconstruct choice array
            choices_yee = [choices_yee tmp_choices_yee];
            choices_yer = [choices_yer tmp_choices_yer];
        end
        
        
        %--------------------------------
        %1. EXTRACT PAYOFF DATA FROM RAW
        %--------------------------------
        rwd_yee = [];
        rwd_yer = []; 
        
        for i = 1:length(choices_yee)
            choices_yee_tmp(i) = choices_yee(i)+1;
            choices_yer_tmp(i) = choices_yer(i)+1;
            rwd_yee(i) = payoff_mtrx_yee(choices_yee_tmp(i),choices_yer_tmp(i));
            rwd_yer(i) = payoff_mtrx_yer(choices_yee_tmp(i),choices_yer_tmp(i));
        end
        
        
        %Sum payoff
        payoff_yee(cond, sub) = sum(rwd_yee);
        payoff_yer(cond, sub) = sum(rwd_yer);
        
        %--------------------------------
        %2. EXTRACT SWITCH RATES FROM RAW
        %--------------------------------
        
        %Get switch rates
        for i = 1:length(choices_yee)-1
            
            Curr_choice = choices_yee(i+1);
            Past_choice = choices_yee(i);
            
            if Curr_choice ~= Past_choice
                switch_vector(i) = 1;
            else
                switch_vector(i) = 0;
            end
            
        end
        
        
        %Sum and normalize to get switch rates
        switch_idx(cond, sub) = sum(switch_vector)/length(choices_yee);
        
        
    end
end


%Save Payoff data in "Processed_data" file
%--------------------------------------------------------------
Payoff.vertex_yee = payoff_yee(1, :); 
Payoff.vertex_yer = payoff_yer(1, :);
Payoff.rTPJ_yee = payoff_yee(2, :); 
Payoff.rTPJ_yer = payoff_yer(2, :); 

SavePath = [fullPath(1:end-46),'/data/Processed_data/Payoffs']; 
save([SavePath,'/Mean_Subject_Payoffs'],'Payoff')

%Save Switch data in "Processed_data" file
%--------------------------------------------------------------
switch_rate.control = switch_idx(1,:); 
switch_rate.active = switch_idx(2,:); 

SavePath = [fullPath(1:end-46),'/data/Processed_data/Switch_rates']; 
save([SavePath,'/Mean_Subjects_SwitchRates'],'switch_rate')

