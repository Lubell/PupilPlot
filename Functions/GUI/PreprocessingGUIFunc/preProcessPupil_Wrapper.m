function [success] = preProcessPupil_Wrapper(optVar,genData)
% contains only the functions for preprocessing
% document


%% save current settings into preprocessing file

workingD = optVar{1,2};

% resave current values to new prepocessing file
save([workingD filesep 'preprocSettings.mat'] ,'optVar','genData')



%% define values from Gui:
sampleRate = genData.fs;

trialOpts = optVar{4,2};
baseLineOpts = optVar{4,3};

interestLine = trialOpts.*sampleRate;
baseLine = baseLineOpts.*sampleRate;

% move into new epoched_preproc file
save([workingD filesep 'epoched_preproc.mat'] ,'optVar','genData','interestLine','baseLine')

%% Clean the pupils
cleanWrapper(optVar,genData)

%% segment into trials
segSucess = preProcessPupilSegment(optVar,genData,interestLine);
Stimulations_All = segSucess.StimAll;
L_stim = segSucess.L_Eye;
%% Finsih with baseline removal

[Stimuli_Data_Perc_Mean,Stimulations_Data_Perc,Stimuli_Data_Corr_Mean,Stimulations_All,...
    TF_REP,Stimulations_names,L_stim,Stimulations_Data_UnCorr_Mean,Stimulations_Data_Corr_mm,...
    ] = preProcessPupilBaseline(optVar,genData,interestLine,baseLine,Stimulations_All,L_stim);
%% save it
save([workingD filesep 'epoched_preproc.mat'],'Stimuli_Data_Perc_Mean','Stimulations_Data_Perc','Stimuli_Data_Corr_Mean','Stimulations_All',...
    'TF_REP','Stimulations_names','L_stim','Stimulations_Data_UnCorr_Mean','Stimulations_Data_Corr_mm');
success = 1;