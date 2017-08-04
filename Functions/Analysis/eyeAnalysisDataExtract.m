function [X_Corr_Sum,num_participants_F,participants_del_Total] = eyeAnalysisDataExtract(varargin)


if size(varargin,2)==1
    %just an epoch file
else
    TF_REP = varargin{1};
    Data_Corr = varargin{2};
    num_stimuli = size(Data_Corr,3);
    num_participants = size(Data_Corr,1);
    Stimuli_ranks = varargin{3};

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data extraction

% ----- Calculation of the observations removed
if TF_REP == 1; % If there are repetitions, the matrix for data analysis is Stimuli_Data_Corr/Perc_Mean
    num_del = zeros (num_stimuli,1);
    for stimulus = 1:num_stimuli
        for participant = 1:num_participants
            X_Corr_Sum (participant,stimulus) = sum((Data_Corr(participant,:,Stimuli_ranks(stimulus,1)))');
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
    num_del = zeros (num_stimuli,1);
    for stimulus = 1:num_stimuli
        for participant = 1:num_participants
            X_Corr_Sum (participant,stimulus) = sum ((Data_Corr(participant,:,Stimuli_ranks(stimulus,1)))');
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
for stimulus = 1:num_stimuli
    num_participants_F (stimulus,1) = num_participants - participants_del_Total;
end
lines_toDel_Sum = participants_del_Total * num_stimuli;
lines_toDel = zeros (lines_toDel_Sum,1);
if participants_del_Total>0
    z=0;
    line_start = 1;
    lines_toDel = zeros (participants_del_Total*num_stimuli,1);
    for stimulus = 1 :num_stimuli
        lines_toDel (line_start : participants_del_Total*stimulus)= Part_To_Del (:,1)+z;
        line_start = line_start + participants_del_Total;
        z = z + num_participants;
    end
end