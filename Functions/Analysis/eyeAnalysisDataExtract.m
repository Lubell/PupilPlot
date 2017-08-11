function [X_Corr_Sum,num_participants_F,participants_del_Total] = eyeAnalysisDataExtract(varargin)


if size(varargin,2)==1
    %just an epoch file
else
    TF_REP = varargin{1};
    Data_Corr = varargin{2};
    num_stimuli = size(Data_Corr,3);
    subjects_all = size(Data_Corr,1);
    Stimuli_ranks = varargin{3};

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data prep

% ----- Calculation of the observations removed
% If conditions are repeated within a subject's data record (they see the same
% condition more than once) the matrix is Data_Corr_Mean and Data_Perc_Mean
if TF_REP == 1 
    num_del = zeros (num_stimuli,1);
    for stimulus = 1:num_stimuli
        for subject = 1:subjects_all
            X_Corr_Sum (subject,stimulus) = sum((Data_Corr(subject,:,Stimuli_ranks(stimulus,1)))');
            if X_Corr_Sum (subject,stimulus) ==0
                num_del (stimulus,1) = num_del (stimulus,1) + 1;
                participants_del (num_del (stimulus,1),stimulus) = subject;
            end
        end
    end
    if num_del ==0
        participants_del=0;
    end
    

    
else % Otherwise the matrix for data analysis is Data_Corr Perc_Corr
    num_del = zeros (num_stimuli,1);
    for stimulus = 1:num_stimuli
        for subject = 1:subjects_all
            X_Corr_Sum (subject,stimulus) = sum ((Data_Corr(subject,:,Stimuli_ranks(stimulus,1)))');
            if X_Corr_Sum (subject,stimulus) ==0
                num_del (stimulus,1) = num_del (stimulus,1) + 1;
                participants_del (num_del (stimulus,1),stimulus) = subject;
            end
        end
    end
    if num_del ==0
        participants_del=0;
    end
    
end

% Identification of participants to remove
participants_del_Total = 0;
for subject = 1:subjects_all
    ans=length(find(participants_del==subject));
    if ans ~=0
        participants_del_Total = participants_del_Total +1;
        Part_To_Del (participants_del_Total,1) = subject;
    end
end
for stimulus = 1:num_stimuli
    num_participants_F (stimulus,1) = subjects_all - participants_del_Total;
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
        z = z + subjects_all;
    end
end