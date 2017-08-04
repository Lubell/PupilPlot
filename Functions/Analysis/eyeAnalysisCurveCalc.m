function [xPercSD,xPercCIAbove,xPercCIBelow,xCorrSD,xCorrCIAbove,xCorrCIBelow,xUncorrSD,xUncorrCIAbove,xUncorrCIBelow] = eyeAnalysisCurveCalc(varargin)


if size(varargin,2)==1
    %just an epoch file
else
    zScore = varargin{1};
    X_Perc_DataSelected = varargin{2};
    X_Perc_DataSelected_Means = varargin{3};
    num_stimuli = size(X_Perc_DataSelected_Means,1);
    X_Corr_DataSelected_Means = varargin{4};
    X_Uncorr_DataSelected_Means = varargin{5};
    num_participants_F = varargin{6};
    X_Corr_DataSelected= varargin{7};
    X_Uncorr_DataSelected= varargin{8};
end
%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation for curves

% Percentage of change

line_start = 1; % Calculation of Confidence Intervals
for stimulus = 1:num_stimuli
    xPercSD(stimulus,:) = (zScore * std(X_Perc_DataSelected (line_start:line_start+num_participants_F(stimulus,1)-1,:))./ sqrt (size(X_Perc_DataSelected (line_start:line_start+num_participants_F(stimulus,1)-1,:),1)));
    xPercCIAbove (stimulus,:) = X_Perc_DataSelected_Means (stimulus,:) + xPercSD (stimulus,:);
    xPercCIBelow(stimulus,:) = X_Perc_DataSelected_Means (stimulus,:) - xPercSD (stimulus,:);
    line_start = line_start + num_participants_F(stimulus,1);
end

% Baseline-corrected data

line_start = 1; % Calculation of Confidence Intervals
for stimulus = 1:num_stimuli
    xCorrSD(stimulus,:) = (zScore * std(X_Corr_DataSelected (line_start:line_start+num_participants_F(stimulus,1)-1,:))./ sqrt (size(X_Corr_DataSelected (line_start:line_start+num_participants_F(stimulus,1)-1,:),1)));
    xCorrCIAbove(stimulus,:) = X_Corr_DataSelected_Means (stimulus,:) + xCorrSD (stimulus,:);
    xCorrCIBelow(stimulus,:) = X_Corr_DataSelected_Means (stimulus,:) - xCorrSD (stimulus,:);
    xUncorrSD(stimulus,:) = (zScore * std(X_Uncorr_DataSelected (line_start:line_start+num_participants_F(stimulus,1)-1,:))./ sqrt (size(X_Uncorr_DataSelected (line_start:line_start+num_participants_F(stimulus,1)-1,:),1)));
    xUncorrCIAbove(stimulus,:) = X_Uncorr_DataSelected_Means (stimulus,:) + xUncorrSD(stimulus,:);
    xUncorrCIBelow(stimulus,:) = X_Uncorr_DataSelected_Means (stimulus,:) - xUncorrSD(stimulus,:);
    line_start = line_start + num_participants_F(stimulus,1);
end