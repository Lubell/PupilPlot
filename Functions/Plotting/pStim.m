function [F_stim,P_stim,PCA_time] = pStim(Stimuli_Data_Corr_Mean,Stimuli_Data_Perc_Mean,num_stimuli,triggerNames,alphaReal,pca_go,pLock)
% 
% clear ('Stimuli_ranks');
% clear ('COND');
% clear ('SUBJECTS');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data Selection


numberOFstimuli = numel(num_stimuli);
countMEIN = 1;
for stimulus = num_stimuli
    prompt {countMEIN} = sprintf([triggerNames{stimulus} ' %d'],stimulus);
    countMEIN = countMEIN+1;
end
Stimuli_ranks = zeros(numberOFstimuli,2);
Stimuli_ranks(:,1) = num_stimuli;
num_participants = size(Stimuli_Data_Corr_Mean,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data extraction

% ----- Calculation of the observations removed
if 1 % If there are repetitions, the matrix for data analysis is Stimuli_Data_Corr/Perc_Mean
    num_del = zeros (numberOFstimuli,1);
    for stimulus = 1:numberOFstimuli
        for participant = 1:num_participants
            X_Corr_Sum (participant,stimulus) = sum ((Stimuli_Data_Corr_Mean(participant,:,Stimuli_ranks(stimulus,1)))');
            if X_Corr_Sum (participant,stimulus) ==0
                num_del (stimulus,1) = num_del (stimulus,1) + 1;
                participants_del (num_del (stimulus,1),stimulus) = participant;
            end
        end
    end
    if num_del ==0
        participants_del=0;
    end
else % If there is no repetitions, the matrix for data analysis is Stimuli_Data_Corr/Perc
    num_del = zeros (numberOFstimuli,1);
    for stimulus = 1:numberOFstimuli
        for participant = 1:num_participants
            X_Corr_Sum (participant,stimulus) = sum ((Stimulations_Data_Corr(participant,:,Stimuli_ranks(stimulus,1)))');
            if X_Corr_Sum (participant,stimulus) ==0
                num_del (stimulus,1) = num_del (stimulus,1) + 1;
                participants_del (num_del (stimulus,1),stimulus) = participant;
            end
        end
    end
    if num_del ==0
        participants_del=0;
    end
end

% Identification of participants to remove
participants_del_Total = 0;
for participant = 1:num_participants
    ans=length(find(participants_del==participant));
    if ans ~=0
        participants_del_Total = participants_del_Total +1;
        Part_To_Del (participants_del_Total,1) = participant;
    end
end
for stimulus = 1:numberOFstimuli
    num_participants_F (stimulus,1) = num_participants - participants_del_Total;
end
lines_toDel_Sum = participants_del_Total * numberOFstimuli;
lines_toDel = zeros (lines_toDel_Sum,1);
if participants_del_Total>0
    z=0;
    line_start = 1;
    lines_toDel = zeros (participants_del_Total*numberOFstimuli,1);
    for stimulus = 1 :numberOFstimuli
        lines_toDel (line_start : participants_del_Total*stimulus)= Part_To_Del (:,1)+z;
        line_start = line_start + participants_del_Total;
        z = z + num_participants;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ----- Preparation of data processing

% Factor vector creations

line_start = 1; % Conditions vector creation
for stimulus = 1:numberOFstimuli
    COND (line_start:num_participants_F (stimulus,1)*stimulus,1) = stimulus;
    line_start = line_start + num_participants_F;
end

line_start = 1;% Subjects vector creation
for stimulus = 1:numberOFstimuli
    SUBJECTS (line_start:num_participants_F (stimulus,1)*stimulus,1) = 1:num_participants_F;
    line_start = line_start + num_participants_F(stimulus,1);
end

% Extraction of data to compare

% Baseline-corrected data

if 1;
    line_start = 1;
    for stimulus = 1:numberOFstimuli
        X_Corr_DataSelected (line_start:num_participants*stimulus,:) = Stimuli_Data_Corr_Mean(:,:,Stimuli_ranks(stimulus,1));
        line_start = num_participants*stimulus + 1;
    end
else
    line_start = 1;
    for stimulus = 1:numberOFstimuli
        X_Corr_DataSelected (line_start:num_participants*stimulus,:) = Stimulations_Data_Corr(:,:,Stimuli_ranks(stimulus,1));
        line_start = num_participants*stimulus + 1;
    end
end

lines_toDel_Sum = participants_del_Total * numberOFstimuli; % Removal of lines to delete
line_del = 0 ;
for line = 1 : lines_toDel_Sum
    X_Corr_DataSelected (lines_toDel(line,1)-line_del,:) = [];
    line_del = line_del + 1;
end

line_start = 1; % Average baseline-corrected pupil diameter by stimulus
for stimulus = 1:numberOFstimuli
    X_Corr_DataSelected_Means (stimulus,:) = mean (X_Corr_DataSelected (line_start:line_start+num_participants_F-1,:));
    line_start = line_start + num_participants_F;
end

% Percentage change of pupil diameter

if 1; % Extraction of data to compare
    line_start = 1;
    for stimulus = 1:numberOFstimuli
        X_Perc_DataSelected (line_start:num_participants*stimulus,:) = Stimuli_Data_Perc_Mean(:,:,Stimuli_ranks(stimulus,1));
        line_start = num_participants*stimulus + 1;
    end
else
    line_start = 1;
    for stimulus = 1:numberOFstimuli
        X_Perc_DataSelected (line_start:num_participants*stimulus,:) = Stimulations_Data_Perc(:,:,Stimuli_ranks(stimulus,1));
        line_start = num_participants*stimulus + 1;
    end
end

lines_toDel_Sum = participants_del_Total * numberOFstimuli; % Removal of lines to delete
line_del = 0 ;
for line = 1 : lines_toDel_Sum
    X_Perc_DataSelected (lines_toDel(line,1)-line_del,:) = [];
    line_del = line_del + 1;
end

line_start = 1; % Average percetnage of change of pupil diameter by stimulus
for stimulus = 1:numberOFstimuli
    X_Perc_DataSelected_Means (stimulus,:) = mean (X_Perc_DataSelected (line_start:line_start+num_participants_F-1,:));
    line_start = line_start + num_participants_F;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparison from one time to the next by mobile averages

observations = size (X_Perc_DataSelected,1); % Calculation of the mobile averages
times = size (X_Perc_DataSelected,2);
for i = 1:times-11
    for j = 1:observations
        X_Perc_DataSelected_means (j,i) = mean (X_Perc_DataSelected(j,i:i+11));
    end
end

for time = 1:times-11 % two-way ANOVA time by time
    [p,tableTimes,statsTimes] = anovan(X_Perc_DataSelected(:,time),[COND SUBJECTS],'display','off');
    p_time(1,time) = tableTimes{2,7};
    p_time(2,time) = tableTimes{3,7};
    F_time(1,time) = tableTimes{2,6};
    F_time(2,time) = tableTimes{3,6};
    p_sign(1,time)=0.05;
end
ddf_1 = numberOFstimuli-1; % Calculation degrees of freedom
ddf_2 = num_participants_F(1,1)-1;
ddf_error = (size(X_Perc_DataSelected,1)-1)-ddf_1 - ddf_2;

F=finv(1-alphaReal,ddf_1,ddf_error);

times = size (X_Perc_DataSelected,2);
for time = 1:times
    F_Sign(1,time) = F;
end

if pca_go
    
    PCA_time= fstimInvest({F_time,F_Sign,X_Perc_DataSelected,0,COND,SUBJECTS,1-alphaReal});
    

    
    P_stim.ptime = p_time;
    P_stim.psign = p_sign;
    F_stim.fsign = F_Sign;
    F_stim.ftime = F_time;
elseif pLock
    P_stim.ptime = p_time;
    P_stim.psign = p_sign;
    F_stim.fsign = F_Sign;
    F_stim.ftime = F_time;
    PCA_time = 1;
    
else
    F_stim.fsign = F_Sign;
    F_stim.ftime = F_time;
    P_stim = 1;
    PCA_time = 1;
end
