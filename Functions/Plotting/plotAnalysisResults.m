function [plotItself] = plotAnalysisResults(guiSource,varargin)
% hObject    handle to plotAnal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(guiSource,1)
    % to be plotted in GUI window and different varargins
    typeOAnalysis = varargin{1};
    genData = varargin{2};
    optVar = varargin{3};
    graphingStuff = varargin{4};
    saveDir = optVar{1,2};
    
    
    analysisVariables = load([saveDir filesep 'Analysis_StageOne_' genData.papaDir '.mat']);
    num_stimuli = size(analysisVariables.num_participants_F,1);
    Colors = graphingStuff.Colors(1:num_stimuli,:);
    
    sampleRate = genData.fs;
    trialOpts = optVar{4,2};
    
    trialTime = strfind(trialOpts,',T:');
    trialLine = str2double(trialOpts(trialTime+3:end));
    interestLineMS = trialLine*1000;
    interestLineSamples = trialLine*sampleRate;
    




    
    
    
else
    % called from the command line and to produce its own plot window
    typeOAnalysis = varargin{1};
    
end


skipCBfunc=1;

switch typeOAnalysis
    
    case 1
        %% Dirty Data (no corrections all subjects)
        
        num_parts = num_participants; % how many participants?
        
        
        % plot data for a particular trial, for illustration
        % let us plot the raw data for the left pupil on the last (hard) problem
        %figure; % open a figure
        foo = max(size(Stimulations_All)); % how many samples?
        
        scatter(handles.mainAxe,1:foo,L_stim(1,foo-(foo-1):foo),4,'k','filled') % plot the last 600 (or 10s given 60Hz sampling)
        
        xtickMSLabel = (0:round((foo*sampleRate)/11):foo*sampleRate);
        
        
        hold on; % we will add to plot, rather than replace with new data
        for j = 2:num_parts % repeat for remaining participants
            %foo = max(size(data(j).trial_data(6).CleanPupil)); % how many samples
            scatter(handles.mainAxe,1:foo,L_stim(j,foo-(foo-1):foo),4,'k','filled')
        end
        hold off; % done adding data
        
        handles.mainAxe.XLabel.String = 'Time (ms)';
        handles.mainAxe.YLabel.String = 'Pupil diameter (mm)';
        set(handles.mainAxe,'XTick',0:(foo/10):foo,'XTickLabel',xtickMSLabel); % ticks along x axis
        handles.graphName.String = 'Left pupils of all patients uncleaned values';
        
        set(handles.mainAxe,'Box','off', 'FontSize',10);
        set(handles.mainAxe,'XMinorTick','on')
        %set(handles.mainAxe,'Position',handles.graphingStuff.maingraphSize)
        %set(handles.mainAxe,'OuterPosition',handles.graphingStuff.maingraphSizeOUT)
        
        grid on
        skipCBfunc = 0;
        guidata(hObject,handles)
        
    case 2
        %% Cleaned Data (no corrections all subjects)
        
        skipCBfunc = 0;
        
        % let's look at clean data
        
        
        num_parts = num_participants; % how many participants?
        
        
        % plot data for a particular trial, for illustration
        % let us plot the raw data for the left pupil on the last (hard) problem
        %figure; % open a figure
        foo = max(size(Stimulations_All)); % how many samples?
        
        scatter(handles.mainAxe,1:foo,Stimulations_All(1,foo-(foo-1):foo),4,'k','filled') % plot the
        hold on; % we will add to plot, rather than replace with new data
        for j = 2:num_parts % repeat for remaining participants
            %foo = max(size(data(j).trial_data(6).CleanPupil)); % how many samples
            scatter(handles.mainAxe,1:foo,Stimulations_All(j,foo-(foo-1):foo),4,'k','filled') % plot last 600
        end
        hold off; % done adding data
        
        handles.mainAxe.XLabel.String = 'Time (ms)';
        handles.mainAxe.YLabel.String = 'Pupil diameter (mm)';
        xtickMSLabel = (0:round((foo*sampleRate)/8):foo*sampleRate);
        set(handles.mainAxe,'XTick',0:(foo/6):foo,'XTickLabel',xtickMSLabel); % ticks along x axis
        handles.graphName.String = [Stimulations_names{1} ' cleaned values'];
        
        set(handles.mainAxe,'Box','off', 'FontSize',10);
        set(handles.mainAxe,'XMinorTick','on')
        set(handles.mainAxe,'Position',handles.graphingStuff.maingraphSize)
        set(handles.mainAxe,'OuterPosition',handles.graphingStuff.maingraphSizeOUT)
        
        grid on
        
        guidata(hObject,handles)
        
        
    case 3
        %% Average Pupil Change no corrections
        
        % show means by problem type
        xtickle = 0:(interestLineSamples/6):interestLineSamples;
        xtickMSLabel = (xtickle/sampleRate)*1000;
        if ~isequal(genData.selectMe,1:num_stimuli)
            
            num_stimuli = genData.selectMe;
        else
            num_stimuli = 1:num_stimuli;
        end
        namesOFcondi = cell(length(num_stimuli),1);
        hold on;
        set(handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
        outCount = 1;
        for i = num_stimuli %(2:end)
            plot(handles.mainAxe,1:interestLineSamples,X_Uncorr_DataSelected_Means(i,:),'buttonDownFcn',@mainAxe_ButtonDownFcn);
            %squeeze(Stimuli_Data_Corr_Mean(:,:,i))));%,'Color',Colors(i,:));
            namesOFcondi{outCount} = Stimulations_names{i};
            outCount = outCount + 1;
        end
        
        handles.graphName.String = 'Uncorrected with baseline pupil diameter evolution';
        handles.mainAxe.XLabel.String = 'Time (ms)';
        handles.mainAxe.YLabel.String = 'Average change in pupil diameter (mm)';
        set(handles.mainAxe,'XTick',xtickle,'XTickLabel',xtickMSLabel); % ticks along x axis
        set(handles.mainAxe,'XMinorTick','on')
        set(handles.mainAxe,'Position',handles.graphingStuff.maingraphSize)
        set(handles.mainAxe,'OuterPosition',handles.graphingStuff.maingraphSizeOUT)
        grid on
        guidata(hObject,handles)
        % Addition of the confidence intervals
        AnswerDel = questdlg('Do you want to add confidence intervals ?','CI','Yes - Between Subject','Yes - Within Subject','No','Yes - Between Subject');
        genData.AnswerDel = AnswerDel;
        if strcmpi(AnswerDel,'Yes - Between Subject')
            set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
            X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
            colorCounter = 1;
            for stimulus = num_stimuli
                fillUP = X_Uncorr_DataSelected_CI_Above(stimulus,:);
                fillDown = X_Uncorr_DataSelected_CI_Below(stimulus,:);
                Y=[fillUP,fliplr(fillDown)];
                fill(X,Y,Colors(stimulus,:));
                colorCounter = colorCounter +1;
            end
            
            f = findobj(handles.mainAxe,'Type','patch');
            alpha(f,0.1)
        elseif strcmpi(AnswerDel,'Yes - Within Subject')
            % Add
            [ciAbove,ciBelow]=CI_loftus(num_stimuli,X_Uncorr_DataSelected,num_participants_F,X_Uncorr_DataSelected_Means,zScore);
            set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
            X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
            for stimulus = num_stimuli
                fillUP = ciAbove(stimulus,:);
                fillDown = ciBelow(stimulus,:);
                Y=[fillUP,fliplr(fillDown)];
                fill(X,Y,Colors(stimulus,:));
            end
            
            f = findobj(handles.mainAxe,'Type','patch');
            alpha(f,0.1)
            
            
        end
        
        legend(handles.mainAxe,namesOFcondi);
        handles.GraphingStuff.hLeg = namesOFcondi;
        hold off
        guidata(hObject,handles)
        
        
        
        
        
    case 4
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Percentage of change of pupil diameter
        xtickle = 0:(interestLineSamples/6):interestLineSamples;
        xtickMSLabel = (xtickle/sampleRate)*1000;
        % Plot of percentage of change of pupil diameter over time for each stimulus
        if ~isequal(genData.selectMe,1:num_stimuli)
            num_stimuli = genData.selectMe;
        else
            num_stimuli = 1:num_stimuli;
        end
        
        hold on
        set(handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
        for stimulus = num_stimuli
            plot(handles.mainAxe,X_Perc_DataSelected_Means(stimulus,:));
        end
        nameCounter = 1;
        if TF_REP ==1;
            for stimulus = num_stimuli
                Stimuli_selected_names(nameCounter,1) = Stimulations_names(Stimuli_ranks(stimulus,1),1);
                nameCounter = nameCounter + 1;
            end
        else
            for stimulus = num_stimuli
                Stimuli_selected_names(nameCounter,1) = Stimulations_names(Stimuli_ranks(stimulus,1),1);
                nameCounter = nameCounter + 1;
            end
        end
        
        
        
        set(handles.mainAxe,'XTick',xtickle);
        set(handles.mainAxe,'XTickLabel', xtickMSLabel);
        handles.mainAxe.XLabel.String = 'Time (ms)';
        handles.mainAxe.YLabel.String = 'Pupil diameter change (%)';
        set(handles.mainAxe,'Box','off', 'FontSize',10);
        set(handles.mainAxe,'XMinorTick','on')
        set(handles.mainAxe,'Position',handles.graphingStuff.maingraphSize)
        set(handles.mainAxe,'OuterPosition',handles.graphingStuff.maingraphSizeOUT)
        grid on
        guidata(hObject,handles)
        
        handles.graphName.String = 'Percentage of change of the baseline corrected pupil diameter over time';
        
        % Addition of the confidence intervals
        AnswerDel = questdlg('Do you want to add confidence intervals ?','CI','Yes - Between Subject','Yes - Within Subject','No','Yes - Between Subject');
        genData.AnswerDel = AnswerDel;
        if strcmpi(AnswerDel,'Yes - Between Subject');
            %set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
            %plot(handles.mainAxe,X_Perc_DataSelected_CI_Above(num_stimuli,:));
            %plot(handles.mainAxe,X_Perc_DataSelected_CI_Below(num_stimuli,:));
            X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
            colorCounter = 1;
            for stimulus = num_stimuli
                fillUP = X_Perc_DataSelected_CI_Above(stimulus,:);
                fillDown = X_Perc_DataSelected_CI_Below(stimulus,:);
                Y=[fillUP,fliplr(fillDown)];
                fill(X,Y,Colors(stimulus,:));
                colorCounter = colorCounter +1;
            end
            
            %h = findobj(handles.mainAxe,'Type','line');
            %set(h,'Color',Colors(num_stimuli,:))
            %'LineStyle',':','LineWidth',2);
            f = findobj(handles.mainAxe,'Type','patch');
            alpha(f,0.1)
        elseif strcmpi(AnswerDel,'Yes - Within Subject')
            % Add
            [ciAbove,ciBelow]=CI_loftus(num_stimuli,X_Perc_DataSelected,num_participants_F,X_Perc_DataSelected_Means,zScore);
            set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
            X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
            for stimulus = num_stimuli
                fillUP = ciAbove(stimulus,:);
                fillDown = ciBelow(stimulus,:);
                Y=[fillUP,fliplr(fillDown)];
                fill(X,Y,Colors(stimulus,:));
            end
            
            f = findobj(handles.mainAxe,'Type','patch');
            alpha(f,0.1)
        end
        
        legend(handles.mainAxe,Stimuli_selected_names);%,'FontSize',8, 'Location','NorthWestOutside');
        handles.GraphingStuff.hLeg = Stimuli_selected_names;
        hold off
        guidata(hObject,handles)
        
    case 5
        %% Baseline-corrected data
        % Plot of baseline-corrected pupil diameter over time for each stimulus
        % show means by problem type
        xtickle = 0:(interestLineSamples/6):interestLineSamples;
        xtickMSLabel = (xtickle/sampleRate)*1000;
        if ~isequal(genData.selectMe,1:num_stimuli)
            num_stimuli = genData.selectMe;
        else
            num_stimuli = 1:num_stimuli;
        end
        namesOFcondi = cell(length(num_stimuli),1);
        hold on;
        set(handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
        outCount = 1;
        for i = num_stimuli %(2:end)
            plot(handles.mainAxe,1:interestLineSamples,X_Corr_DataSelected_Means(i,:));
            %squeeze(Stimuli_Data_Corr_Mean(:,:,i))));%,'Color',Colors(i,:));
            namesOFcondi{outCount} = Stimulations_names{i};
            outCount = outCount + 1;
        end
        
        handles.graphName.String = 'Baseline-corrected pupil diameter evolution';
        handles.mainAxe.XLabel.String = 'Time (ms)';
        handles.mainAxe.YLabel.String = 'Average change in pupil diameter (mm)';
        set(handles.mainAxe,'XTick',xtickle,'XTickLabel',xtickMSLabel); % ticks along x axis
        set(handles.mainAxe,'XMinorTick','on')
        set(handles.mainAxe,'Position',handles.graphingStuff.maingraphSize)
        set(handles.mainAxe,'OuterPosition',handles.graphingStuff.maingraphSizeOUT)
        grid on
        guidata(hObject,handles)
        % Addition of the confidence intervals
        AnswerDel = questdlg('Do you want to add confidence intervals ?','CI','Yes - Between Subject','Yes - Within Subject','No','Yes - Between Subject');
        genData.AnswerDel = AnswerDel;
        if strcmpi(AnswerDel,'Yes - Between Subject');
            set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
            X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
            
            for stimulus = num_stimuli
                fillUP = X_Corr_DataSelected_CI_Above(stimulus,:);
                fillDown = X_Corr_DataSelected_CI_Below(stimulus,:);
                Y=[fillUP,fliplr(fillDown)];
                fill(X,Y,Colors(stimulus,:));
            end
            
            f = findobj(handles.mainAxe,'Type','patch');
            alpha(f,0.1)
        elseif strcmpi(AnswerDel,'Yes - Within Subject')
            % Add
            [ciAbove,ciBelow]=CI_loftus(num_stimuli,X_Corr_DataSelected,num_participants_F,X_Corr_DataSelected_Means,zScore);
            set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
            X=[1:interestLineSamples,fliplr(1:interestLineSamples)];
            for stimulus = num_stimuli
                fillUP = ciAbove(stimulus,:);
                fillDown = ciBelow(stimulus,:);
                Y=[fillUP,fliplr(fillDown)];
                fill(X,Y,Colors(stimulus,:));
            end
            
            f = findobj(handles.mainAxe,'Type','patch');
            alpha(f,0.1)
            
        end
        legend(handles.mainAxe,namesOFcondi);
        handles.GraphingStuff.hLeg = namesOFcondi;
        hold off
        guidata(hObject,handles)
        
    case 6
        %% Plot mean functional pupil diameter by condition
        
        if  isequal(numel(genData.selectMe),1) || gt(numel(genData.selectMe),2)
            warndlg('Please Select Two Conditions to compare.','Condition Select')
        else
            compareIndexes = genData.selectMe;
            genData.lastCompIndex = compareIndexes;
            hold on
            %get comparision
            
            [fdaComplete,~,~,~] = doFDA(Stimuli_Data_Corr_Mean,compareIndexes,interestLineSamples,num2str(selectedAlpha),0);
            
            
            data_mat = eval_fd(1:interestLineSamples,fdaComplete);
            plot(handles.mainAxe,data_mat);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % add line here
            lineOne = line([1 interestLineSamples],[0,0],'Color', 'r');
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            set(handles.mainAxe,'XTick',0:60:interestLineSamples);
            set(handles.mainAxe,'XTickLabel',0:1000:interestLineMS);
            handles.mainAxe.XLabel.String = 'Time (ms)';
            handles.mainAxe.YLabel.String = 'Mean pupil diameter difference (mm)';
            condiNames = genData.triggerNames(compareIndexes,1);
            condiMast = [condiNames{1} ' vs ' condiNames{2}];
            
            handles.graphName.String = [condiMast ' mean function pupil diameter difference'];
            set(handles.mainAxe,'Box','off');
            %set(handles.mainAxe,'Position',handles.graphingStuff.maingraphSize)
            %set(handles.mainAxe,'OuterPosition',handles.graphingStuff.maingraphSizeOUT)
            
            grid on
            guidata(hObject,handles)
            
        end
        
        
    case 7
        %% Anova and bin
        if ~isequal(genData.selectMe,1:num_stimuli)
            num_stimuli = genData.selectMe;
        else
            num_stimuli = 1:num_stimuli;
        end
        
        
        
        [ANOVA_data,binNumber] = anovaAndPlot(interestLineSamples,interestLineMS,num_participants,num_stimuli,Stimuli_Data_Corr_Mean);
        %         hold on
        
        
        genData.binned = binNumber;
        if isequal(binNumber,1)
            
            bar(handles.mainAxe,ANOVA_data')
            
            set(handles.mainAxe,'Box','off');
            set(handles.mainAxe,'XTick',1:numel(num_stimuli));
            set(handles.mainAxe,'XTickLabel',Stimulations_names(num_stimuli));
            set(handles.mainAxe,'XTickLabelRotation',90);
            
            %handles.mainAxe.XLabel.String = 'All Conditions';
            handles.mainAxe.YLabel.String = 'Average pupil diameter change from baseline';
            
            handles.graphName.String = 'Average change in pupil diameter per Condition';
            
            
        else
            
            slots = 1:interestLineSamples/binNumber:interestLineSamples;
            
            
            
            bar_data = reshape(mean(ANOVA_data),numel(num_stimuli),binNumber)';
            
            
            
            slots = ((slots-1)/sampleRate)*1000;
            
            
            
            
            bar(handles.mainAxe,slots,bar_data);
            set(handles.mainAxe,'Box','off');
            set(handles.mainAxe,'XTick',slots);
            set(handles.mainAxe,'XTickLabel',0:interestLineMS/binNumber:interestLineMS);
            
            
            handles.mainAxe.XLabel.String = 'Time from stimulus onset (ms)';
            handles.mainAxe.YLabel.String = 'Average pupil diameter change from baseline';
            
            
            
            legend(handles.mainAxe,Stimulations_names(num_stimuli));%,'FontSize',8, 'Location','NorthWestOutside');
            handles.GraphingStuff.hLeg = Stimulations_names(num_stimuli);
            set(handles.mainAxe,'XMinorTick','on')
            
            
            handles.graphName.String = 'Average change in pupil diameter at key points over time';
            
            
        end
        
        
        
        
        
        
        
        grid on
        hold off
        skipCBfunc = 0;
        guidata(hObject,handles)
        
        
        
    case 8
        %% stimuli factor p-value over time
        triggerNames = genData.triggerNames;
        
        triggerNames(:,2) = [];
        if ~isequal(genData.selectMe,1:num_stimuli)
            num_stimuli = genData.selectMe;
        else
            num_stimuli = 1:num_stimuli;
        end
        %triggerNames = triggerNames{1:length(triggerNames),1};
        [~,P_stim,~] = functandp([saveDir filesep 'epoched_preproc.mat'],num_stimuli,triggerNames,alphaReal,0,1);
        
        p_time = P_stim.ptime;
        p_sign = P_stim.psign;
        xtickle = 0:(interestLineSamples/6):interestLineSamples;
        xtickMSLabel = (xtickle/sampleRate)*1000;
        
        plot(handles.mainAxe,p_time(1,:));
        h = findobj(handles.mainAxe,'Type','line');
        set(h(1),'Color','k','LineWidth',2);
        hold on;
        plot(handles.mainAxe,p_sign(1,:));
        h = findobj(handles.mainAxe,'Type','line');
        set(h(1),'Color','r','LineWidth',2);
        legend(handles.mainAxe,'p-value (stimuli)',num2str(alphaReal));
        handles.GraphingStuff.hLeg = ['p-value (stimuli)',num2str(alphaReal)];
        set(handles.mainAxe,'XTick',xtickle);
        set(handles.mainAxe,'XTickLabel', xtickMSLabel);
        handles.mainAxe.XLabel.String = 'Time (ms)';
        handles.mainAxe.YLabel.String = 'p-value';
        set(handles.mainAxe,'Box','off');
        if isequal(numel(num_stimuli),1)
            condiNames = [triggerNames{num_stimuli(1)}];
        else
            condiNames = [triggerNames{num_stimuli(1)} ' vs ' triggerNames{num_stimuli(2)}];
        end
        handles.graphName.String = ['P-value stimuli factor over time for: ' condiNames];
        set(handles.mainAxe,'XMinorTick','on')
        grid on
        hold off
        guidata(hObject,handles)
        
    case 9
        %% Functional t-test of difference (corrected)
        triggerNamesTop = genData.triggerNames;
        
        
        if ~isequal(genData.selectMe,1:num_stimuli)
            num_stimuli = genData.selectMe;
            triggerNames = cell(1,numel(num_stimuli));
            for i = num_stimuli
                triggerNames{i} = triggerNamesTop{i};
            end
        else
            num_stimuli = 1:num_stimuli;
            triggerNames = triggerNamesTop;
            triggerNames(:,2) = [];
        end
        %triggerNames = triggerNames{1:length(triggerNames),1};
        [F_stim,~,~] = functandp([saveDir filesep 'epoched_preproc.mat'],num_stimuli,triggerNames,alphaReal,0,0);
        F_time = F_stim.ftime;
        F_Sign = F_stim.fsign;
        xtickle = 0:(interestLineSamples/6):interestLineSamples;
        xtickMSLabel = (xtickle/sampleRate)*1000;
        
        plot(handles.mainAxe,F_time(1,:));
        h = findobj(handles.mainAxe,'Type','line');
        set(h(1),'Color','k','LineWidth',2);
        hold on;
        plot(handles.mainAxe,F_Sign(1,:));
        h = findobj(handles.mainAxe,'Type','line');
        set(h(1),'Color','r','LineWidth',2);
        legend(handles.mainAxe,'F',['sign. ' num2str(alphaReal*100) '%']);
        exLeg = ['sign. ' num2str(alphaReal*100) '%'];
        handles.GraphingStuff.hLeg = {'F',exLeg};
        set(handles.mainAxe,'XTick',xtickle);
        set(handles.mainAxe,'XTickLabel',xtickMSLabel);
        handles.mainAxe.XLabel.String = 'Time (ms)';
        handles.mainAxe.YLabel.String = 'f-value';
        set(handles.mainAxe,'Box','off');
        if numel(triggerNames)==1
            condiNames = ['F of stimuli factor over time for: ' triggerNames{num_stimuli(1)}];
        elseif numel(triggerNames)==2
            condiNames = ['F of stimuli factor over time for: ' triggerNames{num_stimuli(1)} ' vs ' triggerNames{num_stimuli(2)}];
        else
            condiNames = 'F of stimuli factor over time';
        end
        handles.graphName.String = condiNames;
        set(handles.mainAxe,'XMinorTick','on')
        set(handles.mainAxe,'Position',handles.graphingStuff.maingraphSize)
        set(handles.mainAxe,'OuterPosition',handles.graphingStuff.maingraphSizeOUT)
        
        grid on
        hold off
        guidata(hObject,handles)
    case 10
        %% Plot functional t-test pupil diameter by condition
        
        if isequal(numel(genData.selectMe),1) || gt(numel(genData.selectMe),2)
            warndlg('Please Select Two Conditions to compare.','Condition Select')
        else
            compareIndexes = genData.selectMe;
            genData.lastCompIndex = compareIndexes;
            
            %get comparision
            [~,t_fd,crit_t_val,numTails] = doFDA(Stimuli_Data_Corr_Mean,compareIndexes,interestLineSamples,str2num(selectedAlpha),1);
            genData.tailNumber = numTails;
            
            plot(handles.mainAxe,1:interestLineSamples,t_fd,'Color','k','LineWidth',4);
            lineOne = line([1 interestLineSamples],[crit_t_val,crit_t_val],'Color', 'r');
            lineTwo = line([1 interestLineSamples],[-crit_t_val,-crit_t_val],'Color', 'r');
            
            %set(handles.mainAxe,'Children',[lineOne lineTwo])
            set(handles.mainAxe,'XTick',0:60:interestLineSamples);
            set(handles.mainAxe,'XTickLabel',0:1000:interestLineMS);
            handles.mainAxe.XLabel.String = 'Time (ms)';
            handles.mainAxe.YLabel.String = 't-test value';
            condiNames = genData.triggerNames;
            conditions = [condiNames{compareIndexes(1),1} ' - ' condiNames{compareIndexes(2),1}];
            
            handles.graphName.String = [conditions ': Functional t-test of the difference'];
            set(handles.mainAxe,'Box','off');
            set(handles.mainAxe,'Position',handles.graphingStuff.maingraphSize)
            set(handles.mainAxe,'OuterPosition',handles.graphingStuff.maingraphSizeOUT)
            grid on
            legend(handles.mainAxe,{'t-val over time',['Critical t-value ' num2str(crit_t_val)]});
            handles.GraphingStuff.hLeg = {'t-val over time',['Critical t-value ' num2str(crit_t_val)]};
            
            guidata(hObject,handles)
        end
        
    case 11
        %% PCA (corrected)
        % ------------ PCA
        triggerNames = genData.triggerNames;
        
        triggerNames(:,2) = [];
        
        if isequal(numel(genData.selectMe),1) || gt(numel(genData.selectMe),2)
            warndlg('Please Select Two Conditions to compare.','Condition Select')
        else
            num_stimuli = genData.selectMe;
            
            %triggerNames = triggerNames{1:length(triggerNames),1};
            [~,~,PCA_time] = functandp([saveDir filesep 'epoched_preproc.mat'],num_stimuli,triggerNames,alphaReal,1,0);
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
            Colors = colormap(lines(nb_Components_Selected+1));
            %         for i = 1:nb_Components_Selected % was hardcoded at 3?
            %             for Component = 1:nb_Components_Selected
            %                 Colors (Component,i) = Colors(Component+1,i);
            %             end
            %         end
            %         Colors(nb_Components_Selected+1,:) = Colors(1,:);
            %         Colors(nb_Components_Selected+2,:) = Colors(1,:);
            set(handles.mainAxe,'ColorOrder',Colors);
            hold all
            for Component = 1:nb_Components_Selected+2
                plot(handles.mainAxe,ComponentsSelected_Loadings(Component,:));
            end
            hold on
            plot(handles.mainAxe,ComponentsSelected_Loadings (nb_Components_Selected+1,:),'-k');
            plot(handles.mainAxe,ComponentsSelected_Loadings (nb_Components_Selected+2,:),'-k');
            for Component= 1:nb_Components_Selected
                Components_selected_numbers(Component,1)=Component;
            end
            Components_selected_numbers= num2str(Components_selected_numbers);
            
            
            legend(handles.mainAxe,Components_selected_numbers);
            handles.GraphingStuff.hLeg = Components_selected_numbers;
            xTickle = 1:SamplesSign/10:SamplesSign;
            begin_MS = (beg_signperiod_time/sampleRate)*1000;
            end_MS = (end_signperiod_time/sampleRate)*1000;
            xlaborDor = begin_MS:round(end_MS/19):end_MS;
            set(handles.mainAxe,'XTick',xTickle);
            set(handles.mainAxe,'XTickLabel',xlaborDor);
            handles.mainAxe.XLabel.String = 'Time (ms)';
            handles.mainAxe.YLabel.String = 'Factor Loadings';
            set(handles.mainAxe,'Box','off');
            handles.graphName.String = ['Factor loadings over time for: ' triggerNames{num_stimuli(1)} ' vs ' triggerNames{num_stimuli(2)}];
            set(handles.mainAxe,'XMinorTick','on')
            set(handles.mainAxe,'Position',handles.graphingStuff.maingraphSize)
            set(handles.mainAxe,'OuterPosition',handles.graphingStuff.maingraphSizeOUT)
            grid on
            hold off
            guidata(hObject,handles)
        end
    case 12
        %% ------------ PeakDilation
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calculation of peak dilations
        
        
        Peak = (max(X_Perc_DataSelected'))';
        [p_Peak,tablePeak,statsPeak] = anovan(Peak,[COND SUBJECTS],'display','off');
        
        
        % Display of p-value of stimuli factor for peak dilation
        
        if p_Peak (1,1) < alphaReal
            figure;
            hold on
            multcompare(statsPeak);
            hold off
            display(tablePeak)
            msgbox('There is a significant difference between the peak dilations of the stimuli','Peak Dilation Test')
        else
            msgbox('There is no difference in terms of peak dilation between stimuli','Peak Dilation Test')
        end
        skipCBfunc = 0;
        
end

if skipCBfunc
    set(handles.mainAxe.Children,'buttonDownFcn',@mainAxe_ButtonDownFcn);
end

genData.lastNumStim = num_stimuli;
