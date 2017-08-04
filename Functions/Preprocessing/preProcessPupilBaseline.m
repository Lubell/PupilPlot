function [varargout] = preProcessPupilBaseline(varargin)
% What's passed in:
% 1) the cleaning yes/no
% 2) the baseline options: if yes ask about how to remove
% 3) number of stimuli
% 4) the names of the triggers in the file
% 5) sampling rate
% What's passed back
% 1)


%% setItUp

if size(varargin,2)>=2
    % necessary variables passed in
    optVar = varargin{1};
    genData = varargin{2};
    trigOff = varargin{3};
    interestLine= varargin{4};
    baseLine= varargin{5};
    Stimulations_All = varargin{6};
    L_stim = varargin{7};
    
else
    pathIMPFolder = varargin{1};
    if strcmp(pathIMPFolder(end),filesep)
        pathIMPFolder(end) = [];
    end
    load([pathIMPFolder filesep 'epoched_preproc.mat'])
    load([pathIMPFolder filesep 'preprocSettings.mat'])
end




workingD = optVar{1,2};
samplesEye = dir([workingD filesep '*_IMP.mat']);



%% Set Some General Details 
num_stimulations = genData.stimNum;
num_participants = length(samplesEye);





%% Remove Baseline
disp('Removing Baseline...');

% Baseline correction
for participant = 1:num_participants % Calculating reference value from baselineSEC-baseLineMS
    for i = 1:baseLine
        for stimulus = 1 : num_stimulations
            Stimulations_Ref(participant, i, stimulus) = Stimulations_All (participant,i,stimulus);
        end
    end
end

for participant =1:num_participants
    for stimulus = 1 : num_stimulations
        Stimulations_Ref_Mean (participant, stimulus) = mean (Stimulations_Ref (participant,:,stimulus));
    end
end

for participant = 1:num_participants % Corrected data (mm)
    for stimulus = 1 : num_stimulations
        for i = 1:interestLine
            Stimulations_Data_Corr (participant,i,stimulus) = Stimulations_All (participant,i,stimulus) - Stimulations_Ref_Mean (participant ,stimulus);
            Stimulations_Data_UnCorr(participant,i,stimulus) = Stimulations_All(participant,i,stimulus);
        end
    end
end

for participant = 1:num_participants % Corrected data (%)
    for stimulus = 1 : num_stimulations
        for i = 1:interestLine
            Stimulations_Data_Perc (participant,i,stimulus) = (Stimulations_All (participant,i,stimulus)-Stimulations_Ref_Mean (participant ,stimulus)) ./ Stimulations_Ref_Mean (participant ,stimulus) * 100;
        end
    end
end






Stimulations_Data_Corr_mm = Stimulations_Data_Corr;
clear('L_Stimulations','L_Before_pupils','L_After_pupils','R_Stimulations','R_Before_pupils','R_After_pupils','Stimulations_Ref','Target','answer','directory','display','dlg_title','eye_data','file_prefixes','foo_data', 'foo_index','foo_pre' ,'foo_str', 'fr','nLength'); % Cleaning of the work space




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Average repetitions per stimulus for repeated stimuli



Stimulations_names = genData.triggerNames;
Stimulations_names = Stimulations_names(:,1); % stimuli names
Stim_rep = genData.triggerNames;
Stim_rep = Stim_rep(:,2); % stimuli representation #s
num_stimulations = length(genData.triggerNames);
num_participants = length(samplesEye);




Stimuli_presentations_text = genData.triggerNames;
Stimuli_presentations_text = Stimuli_presentations_text(:,2); % number of presentations

Stimuli_presentations  = zeros(length(Stimuli_presentations_text),1);

num_stimuli=length(Stimuli_presentations_text);%genData.stimNum; % number of trials


for i = 1:length(Stimuli_presentations_text)
    Stimuli_presentations(i)=Stimuli_presentations_text{i};
end







% ------- Baseline-Corrected data
First_Stimulation = 1;
rep=zeros (num_participants,num_stimuli);
Stimuli_Data_Corr_Mean = zeros(num_participants, interestLine, num_stimuli);
Stimulations_Data_UnCorr_Mean = zeros(num_participants, interestLine, num_stimuli);
%Sum of the repetitions (only good quality recordings)
for stimulus = 1:num_stimuli
    for participant = 1:num_participants
        for Stimulation = First_Stimulation:First_Stimulation+Stimuli_presentations(stimulus)-1
            if sum(Stimulations_Data_Corr(participant,:,Stimulation)) ~= 0
                Stimuli_Data_Corr_Mean(participant,:,stimulus) = Stimuli_Data_Corr_Mean(participant,:,stimulus) + Stimulations_Data_Corr(participant,:,Stimulation);
                Stimulations_Data_UnCorr_Mean(participant,:,stimulus) = Stimulations_Data_UnCorr_Mean(participant,:,stimulus) + Stimulations_Data_UnCorr(participant,:,Stimulation);
                rep (participant,stimulus) = rep(participant,stimulus) +1;
            end
        end
    end
    First_Stimulation = Stimuli_presentations(stimulus) + First_Stimulation;
end




% Mean of the repetitions
for participant = 1:num_participants
    for stimulus = 1 : num_stimuli
        for i = 1 : interestLine
            if rep(participant,stimulus) > 0
                Stimuli_Data_Corr_Mean(participant,i,stimulus) = Stimuli_Data_Corr_Mean(participant,i,stimulus)./rep(participant,stimulus);
                Stimulations_Data_UnCorr_Mean(participant,i,stimulus) = Stimulations_Data_UnCorr_Mean(participant,i,stimulus)./rep(participant,stimulus);
            end
            if rep(participant,stimulus) == 0
                Stimuli_Data_Corr_Mean(participant,i,stimulus) = Stimuli_Data_Corr_Mean(participant,i,stimulus);
                Stimulations_Data_UnCorr_Mean(participant,i,stimulus) = Stimulations_Data_UnCorr_Mean(participant,i,stimulus);
            end
        end
    end
end

% ------- Percentages of change of pupil diameter
First_Stimulation = 1;
rep=zeros (num_participants,num_stimuli);
Stimuli_Data_Perc_Sum = zeros (num_participants, interestLine, num_stimuli);

for participant = 1:num_participants
    for stimulus = 1 : num_stimulations
        for i = 1:interestLine
            if isnan (Stimulations_Data_Perc (participant,i,stimulus))
                Stimulations_Data_Perc (participant,i,stimulus)= 0;
            end
        end
    end
end

%Sum of the repetitions (only good quality recordings)
for stimulus = 1:num_stimuli
    for participant = 1:num_participants
        for Stimulation = First_Stimulation:First_Stimulation+Stimuli_presentations(stimulus)-1
            if sum(Stimulations_Data_Perc(participant,:,Stimulation)) ~= 0
                Stimuli_Data_Perc_Sum(participant,:,stimulus) = Stimuli_Data_Perc_Sum(participant,:,stimulus) + Stimulations_Data_Perc (participant,:,Stimulation);
                rep (participant,stimulus) = rep(participant,stimulus) +1;
            end
        end
    end
    First_Stimulation = Stimuli_presentations(stimulus) + First_Stimulation;
end

% Mean of the repetitions
for participant = 1:num_participants
    for stimulus = 1 : num_stimuli
        for i = 1 : interestLine
            if rep(participant,stimulus) > 0
                Stimuli_Data_Perc_Mean(participant,i,stimulus) = Stimuli_Data_Perc_Sum(participant,i,stimulus)./rep(participant,stimulus);
            end
            if rep(participant,stimulus) == 0
                Stimuli_Data_Perc_Mean(participant,i,stimulus) = Stimuli_Data_Perc_Sum(participant,i,stimulus);
            end
        end
    end
end





TF_REP = 1;
for matchers = 1:num_stimulations
    if str2double(Stim_rep(matchers))>=2
        TF_REP = 1;
    end
end






%% Saving Data

% 'Stimuli_Data_Perc_Sum',... not used in next step
% 'Stimulations_Data_Corr_mm',... % I see no value for this


varargout{1} = Stimuli_Data_Perc_Mean; % with repitions mean of the percentage pupil
varargout{2} = Stimulations_Data_Perc; % without repitions mean of the percentage pupil
varargout{3} = Stimuli_Data_Corr_Mean; % with repitions mean of the pupil in mm
varargout{4} = Stimulations_All; % without repitions cleaned values all trials all pt
varargout{5} = TF_REP; % if there are repitions = 1
varargout{6} = Stimulations_names; % names of the different KINDS of trials
varargout{7} = L_stim;
varargout{8} = Stimulations_Data_UnCorr_Mean;
varargout{9} = Stimulations_Data_Corr_mm;

