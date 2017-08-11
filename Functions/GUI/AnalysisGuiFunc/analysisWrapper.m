function [success] = analysisWrapper(epochProcessFile,parentDir,alphaSelect)
% This function takes the preProcess file generated from the preprocess
% functions and throws it into the analysis steps

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data Selection
pPR = load(epochProcessFile); %pPR stands for preprocessResults which is what is being loaded

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% build Stim Ranks
num_stimuli = size(pPR.Stimulations_names,1);
Stimuli_ranks = [1:num_stimuli]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define alpha
alphaReal = 1-alphaSelect;
zScore = abs(norminv(alphaReal/2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extract relevant Data

[~,num_participants_F,participants_del_Total] = eyeAnalysisDataExtract(pPR.TF_REP,...
    pPR.Stimuli_Data_Corr_Mean,...
    Stimuli_ranks);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% organize Values
[X_Corr_DataSelected_Means,X_Uncorr_DataSelected_Means,X_Uncorr_DataSelected,X_Corr_DataSelected,X_Perc_DataSelected,X_Perc_DataSelected_Means,COND,SUBJECTS]...
    = eyeAnalysisDataPreProcess(num_participants_F,...
    pPR.Stimuli_Data_Corr_Mean,...
    pPR.Stimulations_Data_UnCorr_Mean,...
    pPR.Stimuli_Data_Perc_Mean,...
    Stimuli_ranks,...
    pPR.TF_REP,...
    participants_del_Total);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate plots for pupil diameter evolution

[xPercSD,xPercCIAbove,xPercCIBelow,xCorrSD,xCorrCIAbove,xCorrCIBelow,xUncorrSD,xUncorrCIAbove,xUncorrCIBelow] = ...
    eyeAnalysisCurveCalc(zScore,...
    X_Perc_DataSelected,...
    X_Perc_DataSelected_Means,...
    X_Corr_DataSelected_Means,...
    X_Uncorr_DataSelected_Means,...
    num_participants_F,...
    X_Corr_DataSelected,...
    X_Uncorr_DataSelected);

X_Perc_DataSelected_SD = xPercSD;
X_Perc_DataSelected_CI_Above = xPercCIAbove;
X_Perc_DataSelected_CI_Below = xPercCIBelow;
X_Corr_DataSelected_SD = xCorrSD;
X_Corr_DataSelected_CI_Above = xCorrCIAbove;
X_Corr_DataSelected_CI_Below = xCorrCIBelow;
X_Uncorr_DataSelected_SD = xUncorrSD;
X_Uncorr_DataSelected_CI_Above = xUncorrCIAbove;
X_Uncorr_DataSelected_CI_Below  = xUncorrCIBelow;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate mobile averages
[F_Sign,F,xPercMeans,p_time,F_time,p_sign] = eyeAnalysisCompMobileAvg(...
    X_Perc_DataSelected,...
    COND,SUBJECTS,...
    alphaReal,...
    num_participants_F);


clear('trigOff','interestLine','participants_del_Total')
L_stim =  pPR.L_stim;
Stimulations_All = pPR.Stimulations_All;
Stimulations_Data_Perc = pPR.Stimulations_Data_Perc;
Stimulations_names = pPR.Stimulations_names;
Stimuli_Data_Corr_Mean = pPR.Stimuli_Data_Corr_Mean;
Stimulations_Data_UnCorr_Mean = pPR.Stimulations_Data_UnCorr_Mean;
Stimuli_Data_Perc_Mean = pPR.Stimuli_Data_Perc_Mean;

% We've got all the pieces we need 
% SO save:
newFile = fileparts(epochProcessFile);
save([newFile filesep 'Analysis_StageOne_' parentDir '.mat'],'L_stim','Stimulations_All','Stimulations_Data_Perc','alphaSelect','Stimulations_names',...
    'Stimuli_ranks','alphaReal','zScore','num_participants_F','Stimuli_Data_Corr_Mean',...
    'X_Corr_DataSelected_Means','X_Uncorr_DataSelected_Means','X_Uncorr_DataSelected',...
    'X_Corr_DataSelected','X_Perc_DataSelected','X_Perc_DataSelected_Means',...
    'COND','SUBJECTS','Stimulations_Data_UnCorr_Mean','Stimuli_Data_Perc_Mean',...
    'X_Perc_DataSelected_SD','X_Perc_DataSelected_CI_Above','X_Perc_DataSelected_CI_Below',...
    'X_Corr_DataSelected_SD','X_Corr_DataSelected_CI_Above','X_Corr_DataSelected_CI_Below',...
    'X_Uncorr_DataSelected_SD','X_Uncorr_DataSelected_CI_Above','X_Uncorr_DataSelected_CI_Below',...
    'F_Sign','F','p_time','F_time','p_sign');

disp('Done with Analysis')
success = 1;


