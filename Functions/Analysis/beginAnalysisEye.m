function [success] = beginAnalysisEye(pathToSavedEpochFile,alpha)

% This program allows to process data by the different methods proposed
% Curves
% Peak dilation
% Comparison from one time to the next
% PCA
%It does not display the results, for this, the following scripts must
%be used :
% Results_Curves
% Results_PeakDilation
% Results_TimesComparison
% Results_PCA







%%


selectedAlpha = num2str(getAlphaPerc);
clear ('All_Data', 'AnswerDel','Component','COEFF','SCORE','TF_1','Var','X_Corr_Sum','ans','answer','del_tot','dlg_title','h','i','ind','j','latent','line','line_del','line_start','lines_toDel','lines_toDel_Sum','lines_toDel','lines_toDel_Sum','nb_variables','num_lines','participant','participants_del','participants_del_Total','prompt','stimulus','time','times','tsquare','z','Part_To_Del','Part_To_Del')


