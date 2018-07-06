function [X_Corr_DataSelected_Means,X_Uncorr_DataSelected_Means,X_Uncorr_DataSelected,X_Corr_DataSelected,X_Perc_DataSelected,X_Perc_DataSelected_Means,COND,SUBJECTS] = eyeAnalysisDataPreProcess(varargin)


if isequal(size(varargin,2),4)
    %just an epoch file
    num_participants_F = varargin{1};
    Stimuli_ranks = varargin{2};
    participants_del_Total = varargin{3};
    load(varargin{4})
    num_stimuli = size(Stimulations_Data_Corr_mm,3);
    num_participants = size(Stimulations_Data_Corr_mm,1);
else
    num_participants_F = varargin{1};
    
    Data_Corr = varargin{2};
    Stimulations_Data_UnCorr_Mean = varargin{3};
    Data_Perc = varargin{4};
    num_stimuli = size(Data_Corr,3);
    num_participants = size(Data_Corr,1);
    Stimuli_ranks = varargin{5};
    TF_REP = varargin{6};
    participants_del_Total = varargin{7};

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ----- Preparation of data processing

% Factor vector creations
line_start = 1; % Conditions vector creation
for stimulus = 1:num_stimuli
    COND(line_start:num_participants_F (stimulus,1)*stimulus,1) = stimulus;
    line_start = line_start + num_participants_F;
end

% Subject vector creation
line_start = 1;
for stimulus = 1:num_stimuli
    SUBJECTS (line_start:num_participants_F (stimulus,1)*stimulus,1) = 1:num_participants_F;
    line_start = line_start + num_participants_F(stimulus,1);
end

% Isolating the data for mm baseline corrected analysis

% Baseline-corrected data

if TF_REP ==1
    line_start = 1;
    for stimulus = 1:num_stimuli
        X_Corr_DataSelected(line_start:num_participants*stimulus,:) = Data_Corr(:,:,Stimuli_ranks(stimulus,1));
        X_Uncorr_DataSelected(line_start:num_participants*stimulus,:) = Stimulations_Data_UnCorr_Mean(:,:,Stimuli_ranks(stimulus,1));
        line_start = num_participants*stimulus + 1;
    end
else
    line_start = 1;
    for stimulus = 1:num_stimuli
        X_Corr_DataSelected (line_start:num_participants*stimulus,:) = Data_Corr(:,:,Stimuli_ranks(stimulus,1));
        X_Uncorr_DataSelected(line_start:num_participants*stimulus,:) = Stimulations_Data_UnCorr_Mean(:,:,Stimuli_ranks(stimulus,1));
        line_start = num_participants*stimulus + 1;
    end
end

% Removal of lines to delete
lines_toDel_Sum = participants_del_Total * num_stimuli; 
line_del = 0 ;
for line = 1 : lines_toDel_Sum
    X_Corr_DataSelected(lines_toDel(line,1)-line_del,:) = [];
    X_Uncorr_DataSelected(lines_toDel(line,1)-line_del,:) = [];
    line_del = line_del + 1;
end
% Average baseline-corrected pupil diameter by stimulus
line_start = 1; 
for stimulus = 1:num_stimuli
    X_Corr_DataSelected_Means(stimulus,:) = mean (X_Corr_DataSelected (line_start:line_start+num_participants_F-1,:));
    X_Uncorr_DataSelected_Means(stimulus,:) = mean (X_Uncorr_DataSelected (line_start:line_start+num_participants_F-1,:));
    line_start = line_start + num_participants_F;
end

% Below is the isolation of pupil diameter by Percentage change

% Select and isolate the data to be compared
if TF_REP ==1 
    line_start = 1;
    for stimulus = 1:num_stimuli
        X_Perc_DataSelected (line_start:num_participants*stimulus,:) = Data_Perc(:,:,Stimuli_ranks(stimulus,1));
        line_start = num_participants*stimulus + 1;
    end
else
    line_start = 1;
    for stimulus = 1:num_stimuli
        X_Perc_DataSelected (line_start:num_participants*stimulus,:) = Data_Perc(:,:,Stimuli_ranks(stimulus,1));
        line_start = num_participants*stimulus + 1;
    end
end

lines_toDel_Sum = participants_del_Total * num_stimuli; % Removal of lines to delete
line_del = 0 ;
for line = 1 : lines_toDel_Sum
    X_Perc_DataSelected (lines_toDel(line,1)-line_del,:) = [];
    line_del = line_del + 1;
end

line_start = 1; % Average percentage of change of pupil diameter by stimulus
for stimulus = 1:num_stimuli
    X_Perc_DataSelected_Means (stimulus,:) = mean (X_Perc_DataSelected (line_start:line_start+num_participants_F-1,:));
    line_start = line_start + num_participants_F;
end
