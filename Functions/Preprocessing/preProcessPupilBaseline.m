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
    interestLine= varargin{3};
    baseLine= varargin{4};
    Stimulations_All = varargin{5};
    L_stim = varargin{6};
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


% predefine
stimulationsReferenceMat = zeros(num_participants,baseLine,num_stimulations);
stimulationsReferenceMatMean = zeros(num_participants,num_stimulations);
stimulationsCorrectedMM = zeros(num_participants,interestLine,num_stimulations);
stimulationsUncorrectedMM = zeros(num_participants,interestLine,num_stimulations);
stimulationsCorrectedPerc = zeros(num_participants,interestLine,num_stimulations);

% Baseline correction
for participant = 1:num_participants % Calculating reference value from baselineSEC-baseLineMS
    for i = 1:baseLine
        for stimulus = 1 : num_stimulations
            stimulationsReferenceMat(participant, i, stimulus) = Stimulations_All(participant,i,stimulus);
        end
    end
end

for participant =1:num_participants
    for stimulus = 1 : num_stimulations
        stimulationsReferenceMatMean(participant, stimulus) = mean(stimulationsReferenceMat(participant,:,stimulus));
    end
end

for participant = 1:num_participants % remove the baseline for data(mm) and data(%)
    for stimulus = 1 : num_stimulations
        for i = 1:interestLine
            stimulationsCorrectedMM(participant,i,stimulus) = Stimulations_All(participant,i,stimulus) - stimulationsReferenceMatMean(participant ,stimulus);
            stimulationsUncorrectedMM(participant,i,stimulus) = Stimulations_All(participant,i,stimulus);
            stimulationsCorrectedPerc(participant,i,stimulus) =(Stimulations_All(participant,i,stimulus)-stimulationsReferenceMatMean(participant ,stimulus)) ./ stimulationsReferenceMatMean(participant ,stimulus) * 100;
        end
    end
end





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Average repetitions per stimulus for repeated stimuli

Stim_rep = genData.triggerNames;
Stim_rep = Stim_rep(:,2); % stimuli representation #s
Stimulations_names = genData.triggerNames;
Stimulations_names = Stimulations_names(:,1); % stimuli names
num_stimulations = length(genData.triggerNames);
num_participants = length(samplesEye);




Stimuli_presentations_text = genData.triggerNames;
Stimuli_presentations_text = Stimuli_presentations_text(:,2); % number of presentations

Stimuli_presentations  = zeros(length(Stimuli_presentations_text),1);

num_stimuli=length(Stimuli_presentations_text);%genData.stimNum; % number of trials




TF_REP = 0;
for matchers = 1:num_stimulations
    if Stim_rep{matchers}>=2
        TF_REP = 1;
    end
end


% predefine
stimulationsCorrectedPercMean = zeros(num_participants,interestLine,num_stimulations);
stimuliCorrectedMean = zeros(num_participants, interestLine, num_stimuli);
stimulationsUncorrectedMean = zeros(num_participants, interestLine, num_stimuli);

if TF_REP
    disp('Averaging repeated Conditions')
    
    
    
    for i = 1:length(Stimuli_presentations_text)
        Stimuli_presentations(i)=Stimuli_presentations_text{i};
    end
    
    % ------- Baseline-Corrected data
    First_Stimulation = 1;
    rep=zeros(num_participants,num_stimuli);
    
    
    %Sum of the repetitions(only good quality recordings)
    for stimulus = 1:num_stimuli
        for participant = 1:num_participants
            for Stimulation = First_Stimulation:First_Stimulation+Stimuli_presentations(stimulus)-1
                if sum(stimulationsCorrectedMM(participant,:,Stimulation)) ~= 0
                    stimuliCorrectedMean(participant,:,stimulus) = stimuliCorrectedMean(participant,:,stimulus) + stimulationsCorrectedMM(participant,:,Stimulation);
                    stimulationsUncorrectedMean(participant,:,stimulus) = stimulationsUncorrectedMean(participant,:,stimulus) + stimulationsUncorrectedMM(participant,:,Stimulation);
                    rep(participant,stimulus) = rep(participant,stimulus) +1;
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
                    stimuliCorrectedMean(participant,i,stimulus) = stimuliCorrectedMean(participant,i,stimulus)./rep(participant,stimulus);
                    stimulationsUncorrectedMean(participant,i,stimulus) = stimulationsUncorrectedMean(participant,i,stimulus)./rep(participant,stimulus);
                end
                if rep(participant,stimulus) == 0
                    stimuliCorrectedMean(participant,i,stimulus) = stimuliCorrectedMean(participant,i,stimulus);
                    stimulationsUncorrectedMean(participant,i,stimulus) = stimulationsUncorrectedMean(participant,i,stimulus);
                end
            end
        end
    end
    
    % ------- Percentages of change of pupil diameter
    First_Stimulation = 1;
    rep=zeros(num_participants,num_stimuli);
    stimuliPercSum = zeros(num_participants, interestLine, num_stimuli);
    
    for participant = 1:num_participants
        for stimulus = 1 : num_stimulations
            for i = 1:interestLine
                if isnan(stimulationsCorrectedPerc(participant,i,stimulus))
                    stimulationsCorrectedPerc(participant,i,stimulus)= 0;
                end
            end
        end
    end
    
    %Sum of the repetitions(only good quality recordings)
    for stimulus = 1:num_stimuli
        for participant = 1:num_participants
            for Stimulation = First_Stimulation:First_Stimulation+Stimuli_presentations(stimulus)-1
                if sum(stimulationsCorrectedPerc(participant,:,Stimulation)) ~= 0
                    stimuliPercSum(participant,:,stimulus) = stimuliPercSum(participant,:,stimulus) + stimulationsCorrectedPerc(participant,:,Stimulation);
                    rep(participant,stimulus) = rep(participant,stimulus) +1;
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
                    stimulationsCorrectedPercMean(participant,i,stimulus) = stimuliPercSum(participant,i,stimulus)./rep(participant,stimulus);
                end
                if rep(participant,stimulus) == 0
                    stimulationsCorrectedPercMean(participant,i,stimulus) = stimuliPercSum(participant,i,stimulus);
                end
            end
        end
    end
end



%% Saving Data

varargout{1} = stimulationsCorrectedPercMean; % with repitions mean of the percentage pupil
varargout{2} = stimulationsCorrectedPerc; % without repitions mean of the percentage pupil
varargout{3} = stimuliCorrectedMean; % with repitions mean of the pupil in mm
varargout{4} = Stimulations_All; % without repitions cleaned values all trials all pt
varargout{5} = TF_REP; % if there are repitions = 1
varargout{6} = Stimulations_names; % names of the different KINDS of trials
varargout{7} = L_stim;
varargout{8} = stimulationsUncorrectedMean;
varargout{9} = stimulationsCorrectedMM;

