function [plotItself] = plotAnalysisResults(varargin)
%plotAnalysisResults   pupil plot. 
%   plotAnalysisResults(X,Y,Z) plots the results of pupil analysis
%
%   The first argument (X) is a string that inidicates the type of plot
%
%       The possible strings that can be designated for X are:
%       'raw' - plots the raw traces of all patients' left pupils
%       'clean' - plots the cleaned traces for all patients
%       'uncorrmm' - plots the non-baselined traces by condition
%       'corrperc' - plots the percentage change (from baseline) traces by
%                    condition
%       'corrmm' - plots the millimeter change (from baseline) traces by
%                   condition 
%       'meandiam' - plots the functional difference between pupil sizes
%                   between conditions
%       'bins' - bins the data at designated time points and plots it as a
%                   bar graph (by condition)
%       'p' - plots the p-value of the comparision of pupil size during
%                   designated conditions
%       'f' - plots the f-value of the comparison of different conditions
%       't' - plots the functional t-test of pupil diameter by condition
%       'pca' - asks for the given time period during the trial to look at
%                   and determine the principle components there within
%       'peak' - shows a table that indicates whether the conditions have a
%       significantly different peak dilation than each other
%       'help' - show this message
%
%   The second argument (Y) is a pupil plot GeneralData struct 
%       - See preProcessPupil_Wrapper for more info on GeneralData structs
%   The third argument (Z) is a option variable (log) cell
%       - See preProcessPupil_Wrapper for more info on log cells
%   
%   plotAnalysisResults(X,Y,Z,C) plots the results of pupil analysis
%
%   If a fourth argument is specified (C), then it should be an array that
%   represents which conditions should be plotted
%
%   Examples:
%     Call to plotAnalysisResults without conditions assigned:
%
%       plotAnalysisResults('raw',GeneralData,optVar)
%
%       'raw' - the type of plot
%       GeneralData - a struct that contains info generated by preprocess
%       optVar - a cell with information relating to file location also
%                generated by preprocess
%
%     Call to plotAnalysisResults with conditions assigned:
%
%       conditions = [1 3];
%
%       plotAnalysisResults('meandiam',GeneralData,optVar,conditions)
%
%       'raw' - the type of plot
%       GeneralData - a struct that contains info generated by preprocess
%       optVar - a cell with information relating to file location also
%                generated by preprocess
%       conditions - a 1xn array where n is the number of conditions to be
%                    compared and the individual members of the array are
%                    the conditions to be assessed.  In this case the
%                    condition 1 and condition 3 will be compared.



if size(varargin,2)>=3 && isstr(varargin{1}) && iscell(varargin{3}) && isstruct(varargin{2})
    % to be plotted in GUI window and different varargins
    typeOAnalysis = lower(varargin{1});
    genData = varargin{2};
    optVar = varargin{3};
    
    % load
    saveDir = optVar{1,2};
    analysisVariables = load([saveDir filesep 'Analysis_StageOne_' genData.papaDir '.mat']);
    
    if isequal(size(varargin,2),4)
        
        conditions = varargin{4};
    else
        conditions = 1:size(genData.triggerNames,1);
        
    end
    
elseif isequal(size(varargin,2),1)
    % help
    typeOAnalysis = 'help';
    
else
    % called from the command line and to produce its own plot window
    disp('************************************')
    disp('Incorrect input arguments.')
    disp('************************************')        
    typeOAnalysis = 'help';
end



switch typeOAnalysis
    case 'raw'
        plotItself = plotRawData(genData,analysisVariables);
    case 'clean'
        plotItself = plotCleanData(genData,analysisVariables);
    case 'uncorrmm'
        plotItself = plotUncorrPupilDiameterMM(optVar,genData,analysisVariables,conditions);
    case 'corrperc'
        plotItself = plotCorrPupilDiameterPerc(optVar,genData,analysisVariables,conditions);
    case 'corrmm'
        plotItself = plotCorrPupilDiameterMM(optVar,genData,analysisVariables,conditions);
    case 'meandiam'
        plotItself = plotMeanFunctionalPupilDiameterMM(optVar,genData,analysisVariables,conditions);
    case 'bins'
        plotCorrPupilDiameterMMBinned(optVar,genData,analysisVariables,conditions);
    case 'p'
        plotItself = plotPValPupil(optVar,genData,analysisVariables,conditions);
    case 'f'
        plotItself = plotFfactor(optVar,genData,analysisVariables,conditions);
    case 't'
        plotItself = plotTtest(optVar,genData,analysisVariables,conditions);
    case 'pca'
        plotItself = plotPCAfactors(genData,analysisVariables,conditions);
    case 'peak'
        plotItself = showPeakDialation(analysisVariables);
    otherwise
        %show help stuff
        help plotAnalysisResults
        plotItself = [];
        % quit
        return
        
end



% --------------------------------------------------------------------
function hFig = plotRawData(genData,analysisVariables)
% hObject    handle to plot1Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


sampleRate = genData.fs;

% Dirty Data (no corrections all subjects)

num_parts = analysisVariables.num_participants_F(1); % how many participants?
foo = max(size(analysisVariables.Stimulations_All)); % how many samples?



scatter(1:foo,analysisVariables.L_stim(1,foo-(foo-1):foo),4,'k','filled') % plot the last 600 (or 10s given 60Hz sampling)

ax = gca;

xtickMSLabel = (0:round((foo*sampleRate)/11):foo*sampleRate);


hold on; % we will add to plot, rather than replace with new data
for j = 2:num_parts % repeat for remaining participants
    %foo = max(size(data(j).trial_data(6).CleanPupil)); % how many samples
    scatter(ax,1:foo,analysisVariables.L_stim(j,foo-(foo-1):foo),4,'k','filled')
end
hold off; % done adding data

ax.XLabel.String = 'Time (ms)';
ax.YLabel.String = 'Pupil diameter (mm)';
set(ax,'XTick',0:(foo/10):foo,'XTickLabel',xtickMSLabel); % ticks along x axis
title('Left pupils of all subjects uncleaned values');
set(ax,'Box','off', 'FontSize',10);
set(ax,'XMinorTick','on')
grid on
hFig = gcf;



% --------------------------------------------------------------------
function hFig = plotCleanData(genData,analysisVariables)
% hObject    handle to plot2Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


sampleRate = genData.fs;


% Cleaned Data (no corrections all subjects)
num_parts = analysisVariables.num_participants_F(1); % how many participants?



foo = max(size(analysisVariables.Stimulations_All)); % how many samples?

scatter(1:foo,analysisVariables.Stimulations_All(1,foo-(foo-1):foo),4,'k','filled') % plot the
ax = gca;
hold on; % we will add to plot, rather than replace with new data
for j = 2:num_parts % repeat for remaining participants
    %foo = max(size(data(j).trial_data(6).CleanPupil)); % how many samples
    scatter(1:foo,analysisVariables.Stimulations_All(j,foo-(foo-1):foo),4,'k','filled') % plot last 600
end
hold off; % done adding data
set(ax,'XTickLabelRotation',0);
ax.XLabel.String = 'Time (ms)';
ax.YLabel.String = 'Pupil diameter (mm)';
xtickMSLabel = (0:round((foo*sampleRate)/8):foo*sampleRate);
set(ax,'XTick',0:(foo/6):foo,'XTickLabel',xtickMSLabel); % ticks along x axis
title([analysisVariables.Stimulations_names{1} ' cleaned values']);

set(ax,'Box','off', 'FontSize',10);
set(ax,'XMinorTick','on')


grid on
hFig = gcf;



% --------------------------------------------------------------------
function hFig = plotUncorrPupilDiameterMM(optVar,genData,analysisVariables,conditions)
% hObject    handle to plot3Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

num_stimuli = size(genData.triggerNames,1);

sampleRate = genData.fs;
trialOpts = optVar{4,2};


trialTime = strfind(trialOpts,',T:');
trialLine = str2double(trialOpts(trialTime+3:end));
interestLineSamples = trialLine*sampleRate;

% show means by problem type
xtickle = 0:(interestLineSamples/6):interestLineSamples;
xtickMSLabel = (xtickle/sampleRate)*1000;
if ~isequal(conditions,1:num_stimuli)
    
    num_stimuli = conditions;
else
    num_stimuli = 1:num_stimuli;
end
namesOFcondi = cell(length(num_stimuli),1);
outCount = 1;
for i = num_stimuli %(2:end)
    plot(1:interestLineSamples,analysisVariables.X_Uncorr_DataSelected_Means(i,:));
    hold on
    namesOFcondi{outCount} = analysisVariables.Stimulations_names{i};
    outCount = outCount + 1;
end


ax = gca;
Colors = colormap(ax.ColorOrder);
Colors = Colors(num_stimuli,:);


title('Uncorrected with baseline pupil diameter evolution');
ax.XLabel.String = 'Time (ms)';
ax.YLabel.String = 'Average change in pupil diameter (mm)';
set(ax,'XTick',xtickle,'XTickLabel',xtickMSLabel); % ticks along x axis
set(ax,'XMinorTick','on')
set(ax,'XTickLabelRotation',0);

grid on

% Addition of the confidence intervals
AnswerDel = questdlg('Do you want to add confidence intervals ?','CI','Yes - Between Subject','Yes - Within Subject','No','Yes - Between Subject');
genData.AnswerDel = AnswerDel;
if strcmpi(AnswerDel,'Yes - Between Subject')

    X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
    colorCounter = 1;
    for stimulus = num_stimuli
        fillUP = analysisVariables.X_Uncorr_DataSelected_CI_Above(stimulus,:);
        fillDown = analysisVariables.X_Uncorr_DataSelected_CI_Below(stimulus,:);
        Y=[fillUP,fliplr(fillDown)];
        fill(X,Y,Colors(stimulus,:));
        colorCounter = colorCounter +1;
    end
    
    f = findobj(ax,'Type','patch');
    alpha(f,0.1)
elseif strcmpi(AnswerDel,'Yes - Within Subject')
    % Add
    [ciAbove,ciBelow]=CI_loftus_wthnPT(num_stimuli,analysisVariables.X_Uncorr_DataSelected,...
        analysisVariables.num_participants_F,analysisVariables.X_Uncorr_DataSelected_Means,analysisVariables.zScore);
    X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
    for stimulus = num_stimuli
        fillUP = ciAbove(stimulus,:);
        fillDown = ciBelow(stimulus,:);
        Y=[fillUP,fliplr(fillDown)];
        v= caxis;
        fill(ax,X,Y,Colors(stimulus,:));
    end
    
    f = findobj(ax,'Type','patch');
    alpha(f,0.1)
    
    
end

legend(ax,namesOFcondi);
hFig = gcf;
hold off



% --------------------------------------------------------------------
function hFig = plotCorrPupilDiameterPerc(optVar,genData,analysisVariables,conditions)
% hObject    handle to plot4Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe

num_stimuli = size(genData.triggerNames,1);

sampleRate = genData.fs;
trialOpts = optVar{4,2};

trialTime = strfind(trialOpts,',T:');
trialLine = str2double(trialOpts(trialTime+3:end));
interestLineSamples = trialLine*sampleRate;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Percentage of change of pupil diameter
xtickle = 0:(interestLineSamples/6):interestLineSamples;
xtickMSLabel = (xtickle/sampleRate)*1000;
% Plot of percentage of change of pupil diameter over time for each stimulus
if ~isequal(conditions,1:num_stimuli)
    num_stimuli = conditions;
else
    num_stimuli = 1:num_stimuli;
end


for stimulus = num_stimuli
    plot(analysisVariables.X_Perc_DataSelected_Means(stimulus,:));
    hold on
end


ax = gca;
Colors = colormap(ax.ColorOrder);
Colors = Colors(num_stimuli,:);

nameCounter = 1;
if 1
    for stimulus = num_stimuli
        Stimuli_selected_names(nameCounter,1) = analysisVariables.Stimulations_names(analysisVariables.Stimuli_ranks(stimulus,1),1);
        nameCounter = nameCounter + 1;
    end
else
    for stimulus = num_stimuli
        Stimuli_selected_names(nameCounter,1) = analysisVariables.Stimulations_names(analysisVariables.Stimuli_ranks(stimulus,1),1);
        nameCounter = nameCounter + 1;
    end
end

set(ax,'ColorOrder',Colors(num_stimuli,:));
set(ax,'XTickLabelRotation',0);
set(ax,'XTick',xtickle);
set(ax,'XTickLabel', xtickMSLabel);
ax.XLabel.String = 'Time (ms)';
ax.YLabel.String = 'Pupil diameter change (%)';
set(ax,'Box','off', 'FontSize',10);
set(ax,'XMinorTick','on')
grid on


title('Percentage of change of the baseline corrected pupil diameter over time');

% Addition of the confidence intervals
AnswerDel = questdlg('Do you want to add confidence intervals ?','CI','Yes - Between Subject','Yes - Within Subject','No','Yes - Between Subject');
genData.AnswerDel = AnswerDel;
if strcmpi(AnswerDel,'Yes - Between Subject');
    X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
    colorCounter = 1;
    for stimulus = num_stimuli
        fillUP = analysisVariables.X_Perc_DataSelected_CI_Above(stimulus,:);
        fillDown = analysisVariables.X_Perc_DataSelected_CI_Below(stimulus,:);
        Y=[fillUP,fliplr(fillDown)];
        fill(X,Y,Colors(stimulus,:));
        colorCounter = colorCounter +1;
    end
    f = findobj(ax,'Type','patch');
    alpha(f,0.1)
elseif strcmpi(AnswerDel,'Yes - Within Subject')
    % Add
    [ciAbove,ciBelow]=CI_loftus_wthnPT(num_stimuli,analysisVariables.X_Perc_DataSelected,...
        analysisVariables.num_participants_F,analysisVariables.X_Perc_DataSelected_Means,analysisVariables.zScore);
    set(ax,'ColorOrder',Colors(num_stimuli,:));
    X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
    for stimulus = num_stimuli
        fillUP = ciAbove(stimulus,:);
        fillDown = ciBelow(stimulus,:);
        Y=[fillUP,fliplr(fillDown)];
        fill(X,Y,Colors(stimulus,:));
    end
    
    f = findobj(ax,'Type','patch');
    alpha(f,0.1)
end

legend(ax,Stimuli_selected_names);%,'FontSize',8, 'Location','NorthWestOutside');

hFig = gcf;
hold off



% --------------------------------------------------------------------
function hFig = plotCorrPupilDiameterMM(optVar,genData,analysisVariables,conditions)
% hObject    handle to plot5Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


num_stimuli = size(genData.triggerNames,1);


sampleRate = genData.fs;
trialOpts = optVar{4,2};

trialTime = strfind(trialOpts,',T:');
trialLine = str2double(trialOpts(trialTime+3:end));
interestLineSamples = trialLine*sampleRate;



% Baseline-corrected data
% Plot of baseline-corrected pupil diameter over time for each stimulus
% show means by problem type
xtickle = 0:(interestLineSamples/6):interestLineSamples;
xtickMSLabel = (xtickle/sampleRate)*1000;
if ~isequal(conditions,1:num_stimuli)
    num_stimuli = conditions;
else
    num_stimuli = 1:num_stimuli;
end
namesOFcondi = cell(length(num_stimuli),1);

outCount = 1;
for i = num_stimuli %(2:end)
    plot(1:interestLineSamples,analysisVariables.X_Corr_DataSelected_Means(i,:));
    hold on
    namesOFcondi{outCount} = analysisVariables.Stimulations_names{i};
    outCount = outCount + 1;
end


ax = gca;
Colors = colormap(ax.ColorOrder);
Colors = Colors(num_stimuli,:);


title('Baseline-corrected pupil diameter evolution');

ax.XLabel.String = 'Time (ms)';
ax.YLabel.String = 'Average change in pupil diameter (mm)';
set(ax,'XTick',xtickle,'XTickLabel',xtickMSLabel); % ticks along x axis
set(ax,'XMinorTick','on')
grid on
set(ax,'ColorOrder',Colors(num_stimuli,:));
% Addition of the confidence intervals
AnswerDel = questdlg('Do you want to add confidence intervals ?','CI','Yes - Between Subject','Yes - Within Subject','No','Yes - Between Subject');
genData.AnswerDel = AnswerDel;
if strcmpi(AnswerDel,'Yes - Between Subject');
    X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
    for stimulus = num_stimuli
        fillUP = analysisVariables.X_Corr_DataSelected_CI_Above(stimulus,:);
        fillDown = analysisVariables.X_Corr_DataSelected_CI_Below(stimulus,:);
        Y=[fillUP,fliplr(fillDown)];
        fill(ax,X,Y,Colors(stimulus,:));
    end
    
    f = findobj(ax,'Type','patch');
    alpha(f,0.1)
elseif strcmpi(AnswerDel,'Yes - Within Subject')
    % Add
    [ciAbove,ciBelow]=CI_loftus_wthnPT(num_stimuli,analysisVariables.X_Corr_DataSelected,...
        analysisVariables.num_participants_F,analysisVariables.X_Corr_DataSelected_Means,analysisVariables.zScore);
    X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
    for stimulus = num_stimuli
        fillUP = ciAbove(stimulus,:);
        fillDown = ciBelow(stimulus,:);
        Y=[fillUP,fliplr(fillDown)];
        fill(ax,X,Y,Colors(stimulus,:));
    end
    f = findobj(ax,'Type','patch');
    alpha(f,0.1)
end
legend(ax,namesOFcondi);
hFig = gcf;
hold off



% --------------------------------------------------------------------
function hFig = plotMeanFunctionalPupilDiameterMM(optVar,genData,analysisVariables,conditions)
% hObject    handle to plot6Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
sampleRate = genData.fs;
trialOpts = optVar{4,2};

trialTime = strfind(trialOpts,',T:');
trialLine = str2double(trialOpts(trialTime+3:end));
interestLineMS = trialLine*1000;
interestLineSamples = trialLine*sampleRate;


% Plot mean functional pupil diameter by condition

if  isequal(numel(conditions),1) || gt(numel(conditions),2)
    disp('Only Two Conditions can be compared.')
    return
else
    compareIndexes = conditions;
    %get comparision
    [fdaComplete,~,~,~] = performFDAfunc(analysisVariables.Stimuli_Data_Corr_Mean,compareIndexes,interestLineSamples,analysisVariables.alphaSelect,0);
    data_mat = eval_fd(1:interestLineSamples,fdaComplete);
    
    plot(data_mat);
    ax = gca;
    hold on
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % add zero line
    line([1 interestLineSamples],[0,0],'Color', 'r');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(ax,'XTick',0:60:interestLineSamples);
    set(ax,'XTickLabel',0:1000:interestLineMS);
    ax.XLabel.String = 'Time (ms)';
    ax.YLabel.String = 'Mean pupil diameter difference (mm)';
    condiNames = genData.triggerNames(compareIndexes,1);
    condiMast = [condiNames{1} ' vs ' condiNames{2}];
    set(ax,'XTickLabelRotation',0);
    title([condiMast ' mean function pupil diameter difference']);
    set(ax,'Box','off');
    grid on
    hFig = gcf;
end


% --------------------------------------------------------------------
function hFig = plotCorrPupilDiameterMMBinned(optVar,genData,analysisVariables,conditions)
% hObject    handle to plot7Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


num_stimuli = size(genData.triggerNames,1);
sampleRate = genData.fs;
trialOpts = optVar{4,2};

trialTime = strfind(trialOpts,',T:');
trialLine = str2double(trialOpts(trialTime+3:end));
interestLineMS = trialLine*1000;
interestLineSamples = trialLine*sampleRate;

% Anova and bin
if ~isequal(conditions,1:num_stimuli)
    num_stimuli = conditions;
else
    num_stimuli = 1:num_stimuli;
end

[ANOVA_data,binNumber] = anova_Plot(interestLineSamples,interestLineMS,analysisVariables.num_participants_F(1),num_stimuli,analysisVariables.Stimuli_Data_Corr_Mean);

genData.binned = binNumber;

if isequal(binNumber,1)
    bar(ANOVA_data')
    hold on
    
    ax = gca;
    set(ax,'Box','off');
    set(ax,'XTick',1:numel(num_stimuli));
    set(ax,'XTickLabel',analysisVariables.Stimulations_names(num_stimuli));
    set(ax,'XTickLabelRotation',0);
    set(ax,'XTickLabelRotation',90);
    ax.YLabel.String = 'Average pupil diameter change from baseline';
    title('Average change in pupil diameter per Condition');
else
    slots = 1:interestLineSamples/binNumber:interestLineSamples;
    bar_data = reshape(mean(ANOVA_data),numel(num_stimuli),binNumber)';
    slots = ((slots-1)/sampleRate)*1000;

    bar(slots,bar_data);
    hold on
    ax = gca;
    
    set(ax,'Box','off');
    set(ax,'XTick',slots);
    set(ax,'XTickLabel',0:interestLineMS/binNumber:interestLineMS);
    
    ax.XLabel.String = 'Time from stimulus onset (ms)';
    ax.YLabel.String = 'Average pupil diameter change from baseline';
    
    legend(ax,analysisVariables.Stimulations_names(num_stimuli));%,'FontSize',8, 'Location','NorthWestOutside');
    set(ax,'XMinorTick','on')
    title('Average change in pupil diameter at key points over time');
end
hFig = gcf;
grid on
hold off



% --------------------------------------------------------------------
function hFig = plotPValPupil(optVar,genData,analysisVariables,conditions)
% hObject    handle to plot8Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
num_stimuli = size(genData.triggerNames,1);
sampleRate = genData.fs;
trialOpts = optVar{4,2};

trialTime = strfind(trialOpts,',T:');
trialLine = str2double(trialOpts(trialTime+3:end));
interestLineSamples = trialLine*sampleRate;


% stimuli factor p-value over time
triggerNames = genData.triggerNames;

triggerNames(:,2) = [];
if ~isequal(conditions,1:num_stimuli)
    num_stimuli = conditions;
else
    num_stimuli = 1:num_stimuli;
end

[~,P_stim,~] = pStim(analysisVariables.Stimuli_Data_Corr_Mean,...
    analysisVariables.Stimuli_Data_Perc_Mean,...
    num_stimuli,triggerNames,...
    analysisVariables.alphaReal,0,1);

p_time = P_stim.ptime;
p_sign = P_stim.psign;
xtickle = 0:(interestLineSamples/6):interestLineSamples;
xtickMSLabel = (xtickle/sampleRate)*1000;

plot(p_time(1,:));
hold on
ax = gca;

h = findobj(ax,'Type','line');
set(h(1),'Color','k','LineWidth',2);
hold on;
plot(p_sign(1,:));
h = findobj(ax,'Type','line');
set(h(1),'Color','r','LineWidth',2);
legend(ax,'p-value (stimuli)',num2str(analysisVariables.alphaReal));
set(ax,'XTick',xtickle);
set(ax,'XTickLabelRotation',0);
set(ax,'XTickLabel', xtickMSLabel);
ax.XLabel.String = 'Time (ms)';
ax.YLabel.String = 'p-value';
set(ax,'Box','off');
if isequal(numel(num_stimuli),1)
    condiNames = [triggerNames{num_stimuli(1)}];
else
    condiNames = [triggerNames{num_stimuli(1)} ' vs ' triggerNames{num_stimuli(2)}];
end
title(['P-value stimuli factor over time for: ' condiNames]);
set(ax,'XMinorTick','on')
hFig = gcf;
grid on
hold off



% --------------------------------------------------------------------
function hFig = plotFfactor(optVar,genData,analysisVariables,conditions)
% hObject    handle to plot9Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

num_stimuli = size(genData.triggerNames,1);
sampleRate = genData.fs;
trialOpts = optVar{4,2};

trialTime = strfind(trialOpts,',T:');
trialLine = str2double(trialOpts(trialTime+3:end));
interestLineSamples = trialLine*sampleRate;


% Functional t-test of difference (corrected)
triggerNamesTop = genData.triggerNames;


if ~isequal(conditions,1:num_stimuli)
    num_stimuli = conditions;
    triggerNames = cell(1,numel(num_stimuli));
    for i = num_stimuli
        triggerNames{i} = triggerNamesTop{i};
    end
else
    num_stimuli = 1:num_stimuli;
    triggerNames = triggerNamesTop;
    triggerNames(:,2) = [];
end

[F_stim,~,~] = pStim(analysisVariables.Stimuli_Data_Corr_Mean,...
    analysisVariables.Stimuli_Data_Perc_Mean,...
    num_stimuli,triggerNames,...
    analysisVariables.alphaReal,0,0);

F_time = F_stim.ftime;
F_Sign = F_stim.fsign;
xtickle = 0:(interestLineSamples/6):interestLineSamples;
xtickMSLabel = (xtickle/sampleRate)*1000;


plot(F_time(1,:));
hold on
ax = gca;
h = findobj(ax,'Type','line');
set(h(1),'Color','k','LineWidth',2);
plot(ax,F_Sign(1,:));
h = findobj(gca,'Type','line');
set(h(1),'Color','r','LineWidth',2);
legend(ax,'F',['significance ' num2str(analysisVariables.alphaReal*100) '%']);
set(ax,'XTick',xtickle);
set(ax,'XTickLabel',xtickMSLabel);
ax.XLabel.String = 'Time (ms)';
ax.YLabel.String = 'f-value';
set(ax,'Box','off');


numCurrCon = 0;
currTriggerNames = cell(1,1);

for findN = 1:numel(triggerNames)
    if ~isempty(triggerNames{findN})
        numCurrCon = numCurrCon+1;
        currTriggerNames{numCurrCon} = triggerNames{findN};
    end
end

if numCurrCon==1
    condiNames = ['F of stimuli factor over time for: ' currTriggerNames{1}];
elseif numCurrCon==2
    condiNames = ['F of stimuli factor over time for: ' currTriggerNames{1} ' vs ' currTriggerNames{2}];
else
    condiNames = 'F of stimuli factor over time';
end
title(condiNames);
set(ax,'XMinorTick','on')
hFig = gcf;
grid on
hold off



% --------------------------------------------------------------------
function hFig = plotTtest(optVar,genData,analysisVariables,conditions)
% hObject    handle to plot12Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sampleRate = genData.fs;
trialOpts = optVar{4,2};

trialTime = strfind(trialOpts,',T:');
trialLine = str2double(trialOpts(trialTime+3:end));
interestLineMS = trialLine*1000;
interestLineSamples = trialLine*sampleRate;


% Plot functional t-test pupil diameter by condition

if isequal(numel(conditions),1) || gt(numel(conditions),2)
    disp('T-test plotting requires 2 conditions')
    hFig = [];
    return
end


compareIndexes = conditions;

%get comparision
[~,t_fd,crit_t_val,numTails] = performFDAfunc(analysisVariables.Stimuli_Data_Corr_Mean,compareIndexes,interestLineSamples,analysisVariables.alphaSelect,1);
genData.tailNumber = numTails;

plot(1:interestLineSamples,t_fd,'Color','k','LineWidth',4);

hold on

lineOne = line([1 interestLineSamples],[crit_t_val,crit_t_val],'Color', 'r');
lineTwo = line([1 interestLineSamples],[-crit_t_val,-crit_t_val],'Color', 'r');
ax = gca;
set(ax,'XTick',0:60:interestLineSamples);
set(ax,'XTickLabel',0:1000:interestLineMS);
ax.XLabel.String = 'Time (ms)';
ax.YLabel.String = 't-test value';
condiNames = genData.triggerNames;
conditions = [condiNames{compareIndexes(1),1} ' - ' condiNames{compareIndexes(2),1}];

title([conditions ': Functional t-test of the difference']);
set(ax,'Box','off');
grid on
legend(ax,{'t-val over time',['Critical t-value ' num2str(crit_t_val)]});
hold off
hFig = gcf;



% --------------------------------------------------------------------
function hFig = plotPCAfactors(genData,analysisVariables,conditions)
% hObject    handle to plot12Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
sampleRate = genData.fs;

% PCA (corrected)
% ------------ PCA
triggerNames = genData.triggerNames;

triggerNames(:,2) = [];

if isequal(numel(conditions),1) || gt(numel(conditions),2)
    disp('PCA can only be run between two conditions')
    hFig = [];
    return
else
    num_stimuli = conditions;
    
    [~,~,PCA_time] = pStim(analysisVariables.Stimuli_Data_Corr_Mean,analysisVariables.Stimuli_Data_Perc_Mean,...
        num_stimuli,triggerNames,analysisVariables.alphaReal,1,0);
    close(gcf)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Display of p-value of stimuli factor for each selected component
    p_PCA = PCA_time.p;
    nb_Components_Selected = PCA_time.nb;
    ComponentsSelected_Loadings = PCA_time.CSL;
    SamplesSign = PCA_time.sampSign;
    beg_signperiod_time = PCA_time.beg;
    end_signperiod_time = PCA_time.end;
    
    times = size (ComponentsSelected_Loadings,2);
    for Component = 1 : nb_Components_Selected
        display(Component)
        if p_PCA(Component,1) <0.05
            disp('discriminates conditions')
            disp('p-value of condition effect')
            disp(p_PCA(Component,1))
        else
            disp('NOT discriminates conditions')
            disp('p-value of condition effect')
            disp(p_PCA(Component,1))
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Display of factor loadings of each selected component
    ComponentsSelected_Loadings (nb_Components_Selected+1,1:times)=0.4; % Addition of the meaningful thresholds in the loadings matrix
    ComponentsSelected_Loadings (nb_Components_Selected+2,1:times)=-0.4; % why is 0.4 the meaningful threshold?
    
    
    for Component = 1:nb_Components_Selected+2
        plot(ComponentsSelected_Loadings(Component,:));
        hold on
    end
    ax = gca;
    plot(ax,ComponentsSelected_Loadings (nb_Components_Selected+1,:),'-k');
    plot(ax,ComponentsSelected_Loadings (nb_Components_Selected+2,:),'-k');
    for Component= 1:nb_Components_Selected
        Components_selected_numbers(Component,1)=Component;
    end
    Components_selected_numbers= num2str(Components_selected_numbers);
    
    
    legend(ax,Components_selected_numbers);
    xTickle = 1:SamplesSign/10:SamplesSign;
    begin_MS = (beg_signperiod_time/sampleRate)*1000;
    end_MS = (end_signperiod_time/sampleRate)*1000;
    xlaborDor = begin_MS:round(end_MS/19):end_MS;
    set(ax,'XTick',xTickle);
    set(ax,'XTickLabel',xlaborDor);
    ax.XLabel.String = 'Time (ms)';
    ax.YLabel.String = 'Factor Loadings';
    set(ax,'Box','off');
    title(['Factor loadings over time for: ' triggerNames{num_stimuli(1)} ' vs ' triggerNames{num_stimuli(2)}]);
    set(ax,'XMinorTick','on')
    grid on
    hold off
    
    hFig = gcf;
end


% --------------------------------------------------------------------
function hFig = showPeakDialation(analysisVariables)
% hObject    handle to plot12Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe



% ------------ PeakDilation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of peak dilations


Peak = (max(analysisVariables.X_Perc_DataSelected'))';
[p_Peak,tablePeak,statsPeak] = anovan(Peak,[analysisVariables.COND analysisVariables.SUBJECTS],'display','off');



% Display of p-value of stimuli factor for peak dilation

if p_Peak (1,1) < analysisVariables.alphaReal
    hFig = multcompare(statsPeak);
    display(tablePeak)
    disp('There is a significant difference between the peak dilations of the stimuli')
else
    disp('There is no difference in terms of peak dilation between stimuli')
    hFig = [];
end
