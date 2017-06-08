clear variables

%Code to get Payoffs and Switch rates (used for Figure 1C and 2A)
%---------------------------------------------------------------------
%Processes subject raw choice data.
%The output of this script is used by 'Make_Figure1_C' and 'Make_Figure2_A'
%Christopher Hill, June 2017

%Define root path
%Enter your path to the analysis folder
%-------------------------------------%
rootPath = '/Users/chill/Desktop';

%Define array size
SubVec = 29;
RunVec = 2;

%Define payoff matrix
payoff_mtrx_yee = [0,50;50,0];
payoff_mtrx_yer = [25,0;0,100];

%Path to raw choice data
cond_path{1} = '/cTBS-vertex';
cond_path{2} = '/cTBS-rTPJ';

for cond = 1:2
    for sub = 1:SubVec
        for run = 1:RunVec
            
            %Load raw data of all runs with no missing trials
            load([rootPath,'/Figure_NN-A58070/Raw_data/Behavior',cond_path{cond},'/fMRI_pair_S',num2str(sub),'.mat']);
            choices_yee = eval(['Run_' num2str(run), '.choices_yee']);
            choices_yer = eval(['Run_' num2str(run), '.choices_yer']);
            
            %--------------------------------
            %1. EXTRACT PAYOFF DATA FROM RAW
            %--------------------------------
            
            for i = 1:length(choices_yee)
                choices_yee_tmp(i) = choices_yee(i)+1;
                choices_yer_tmp(i) = choices_yer(i)+1;
                rwd_yee(i) = payoff_mtrx_yee(choices_yee_tmp(i),choices_yer_tmp(i));
                rwd_yer(i) = payoff_mtrx_yer(choices_yee_tmp(i),choices_yer_tmp(i));
            end
            
            
            %Sum payoff
            payoff_yee(cond, sub, run) = sum(rwd_yee);
            payoff_yer(cond, sub, run) = sum(rwd_yer);
            
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
            switch_idx(cond, sub, run) = sum(switch_vector)/length(choices_yee);
            
            
        end
    end
end

%Save Payoff data in "Processed_data" file
%--------------------------------------------------------------
Payoff.vertex_yee = (payoff_yee(1, :, 1)+payoff_yee(1, :, 2))';
Payoff.vertex_yer = (payoff_yer(1, :, 1)+payoff_yer(1, :, 2))';
Payoff.rTPJ_yee = (payoff_yee(2, :, 1)+payoff_yee(2, :, 2))';
Payoff.rTPJ_yer = (payoff_yee(2, :, 1)+payoff_yee(2, :, 2))';
save([rootPath,'/Figure_NN-A58070/Processed_data/Payoffs/Mean_Subject_Payoffs'],'Payoff')

%Save Switch data in "Processed_data" file
%--------------------------------------------------------------
switch_rate.control = (switch_idx(1,:,1)+switch_idx(1,:,2))/2;
switch_rate.active = (switch_idx(2,:,1)+switch_idx(2,:,2))/2;
save([rootPath,'/Figure_NN-A58070/Processed_data/Switch_rates/Mean_Subjects_SwitchRates'],'switch_rate')

