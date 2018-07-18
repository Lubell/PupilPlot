function varargout = pupilPlotGUI(varargin)
% PUPILPLOTGUI MATLAB code for pupilPlotGUI.fig
%      PUPILPLOTGUI, by itself, creates a new PUPILPLOTGUI or raises the existing
%      singleton*.
%
%      H = PUPILPLOTGUI returns the handle to a new PUPILPLOTGUI or the handle to
%      the existing singleton*.
%
%      PUPILPLOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PUPILPLOTGUI.M with the given input arguments.
%
%      PUPILPLOTGUI('Property','Value',...) creates a new PUPILPLOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pupilPlotGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pupilPlotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pupilPlotGUI

% Last Modified by GUIDE v2.5 12-Aug-2017 10:11:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pupilPlotGUI_OpeningFcn, ...
    'gui_OutputFcn',  @pupilPlotGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before pupilPlotGUI is made visible.
function pupilPlotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pupilPlotGUI (see VARARGIN)

% Choose default command line output for pupilPlotGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using pupilPlotGUI.
imgSecond= peaks(400);
plot(handles.mainAxe,imgSecond);

if ~isempty(varargin{1})
    currDirr = varargin{1};
    handles.topDirPP = currDirr{1};
else
    handles.topDirPP = 0;
end
Colors = colormap(lines(20));
cheatColor = colormap(autumn);


Colors(3,:) = cheatColor(10,:);

handles.graphingStuff.Colors = Colors;


checkOutTable = cell(6,3);
trigTable = cell(22,2);

for i = 1:length(checkOutTable)
    checkOutTable{i,1} = 0;
    checkOutTable{i,2} = '     not available yet';
    checkOutTable{i,3} = '        ~';
end

for i = 1:length(trigTable)
    trigTable{i,1} = '';
    trigTable{i,2} = '';
end

graphTitle = sprintf('Graph: ');
graphName = sprintf('Welcome to the Pupil Plot GUI!');
set(handles.graphName, 'string', graphName);
set(handles.graphTitle, 'string', graphTitle);

handles.alphaSelect = .95;
handles.GeneralData.usePriorDir = 0;

handles.GeneralData.fs = 0;
handles.GeneralData.preProcOkay = 0;
handles.GeneralData.runAnalysisOkay = 0;

handles.log = checkOutTable;
handles.triggerInfo = trigTable;

handles.plotMenu.Enable = 'off';
handles.analysisMenu.Enable = 'off';
handles.preProcMenu.Enable = 'off';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pupilPlotGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pupilPlotGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
% FILE MENU FUNCTIONS
% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LoadMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function loadFolderMenu_Callback(hObject, eventdata, handles)
% hObject    handle to loadFolderMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
whereAmI = pwd;
dname = uigetdir(whereAmI,'Select folder with already imported files');

if ~ischar(dname)
    dname=[];
end

if ~isempty(dname)
    handles.GeneralData.importFolder = dname;
    handles.GeneralData.usePriorDir = 1;
    
    
    localSep = strfind(dname,filesep);
    papaDir = dname((localSep(end)+1):end);
    handles.GeneralData.papaDir = papaDir;
    handles.log{1,1} = 1;
    
    guidata(hObject, handles);
    
    handles = importSMIRun(handles);
    handles.preProcMenu.Enable = 'on';
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function loadFileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to loadFileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Choice of data files for analysis (Note that other file formats can be chosen)
[filenames,directory] = uigetfile('*.*','Select data files','MultiSelect', 'on');

if isequal(filenames,0)
   % empty clause
elseif ~iscell(filenames)
    warndlg('Please select more than one file')
    return
else
    
    handles.GeneralData.importTxt = filenames;
    handles.GeneralData.importFolder = directory;
    handles.GeneralData.usePriorDir = 0;
    
    localSep = strfind(directory,filesep);
    papaDir = directory((localSep(end)+1):end);
    handles.GeneralData.papaDir = papaDir;
    
    guidata(hObject, handles);
    handles = importSMIRun(handles);
    if isequal(handles,0)
        disp('Import Cancelled')
        return
    end
    handles.preProcMenu.Enable = 'on';
    guidata(hObject, handles);
end



% --------------------------------------------------------------------
function clearSettingsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to clearSettingsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

checkOutTable = cell(6,3);
trigTable = cell(22,2);

for i = 1:length(checkOutTable)
    checkOutTable{i,1} = 0;
    checkOutTable{i,2} = '     not available yet';
    checkOutTable{i,3} = '        ~';
end

for i = 1:length(trigTable)
    trigTable{i,1} = '';
    trigTable{i,2} = '';
end

graphTitle = sprintf('Graph: ');
graphName = sprintf('Welcome to the Pupil Plot GUI!');
set(handles.graphName, 'string', graphName);
set(handles.graphTitle, 'string', graphTitle);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using pupilPlotGUI.
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
imgSecond= peaks(400);
plot(handles.mainAxe,imgSecond);


handles.alphaSelect = .95;
handles.GeneralData.usePriorDir = 0;

handles.GeneralData.fs = 0;
handles.GeneralData.preProcOkay = 0;
handles.log = checkOutTable;
handles.triggerInfo = trigTable;
handles.preProcMenu.Enable = 'off';
handles.plotMenu.Enable = 'off';
handles.analysisMenu.Enable = 'off';
[~,handles] = plotMenuCheck(1,handles);
disp('PupilPlot Reset!')
% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function saveSetMenu_Callback(hObject, eventdata, handles)
% hObject    handle to saveSetMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
genData = handles.GeneralData;
optVar = handles.log;

curLoc = pwd;
genData = handles.GeneralData;

if isfield(genData,'importFolder')
    papaDir = handles.GeneralData.importFolder;
    papaDirFile = [handles.GeneralData.importFolder filesep 'preprocSettings.mat'];
    if exist(papaDirFile,'file')
        answer = questdlg('Sure you want to overwrite existing saved preprocSettings file?','Overwrite?','Yes','No','Yes');
        switch answer
            case 'Yes'
                save(papaDirFile,'genData','optVar')
            otherwise
                return
        end
    else
        save(papaDirFile,'genData','optVar')
    end
else
    warndlg('No files imported yet.','NADA')
    return
end



% --------------------------------------------------------------------
function viewLogMenu_Callback(hObject, eventdata, handles)
% hObject    handle to viewLogMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
viewLog(handles.log)



% --------------------------------------------------------------------
function quitMenu_Callback(hObject, eventdata, handles)
% hObject    handle to quitMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)



% --------------------------------------------------------------------
% PREPROCESS MENU FUNCTIONS
% --------------------------------------------------------------------
function preProcMenu_Callback(hObject, eventdata, handles)
% hObject    handle to preProcMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function setPreProcOptMenu_Callback(hObject, eventdata, handles)
% hObject    handle to setPreProcOptMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[logMan,saveType] = preprocGUI(handles.log);



if isequal(saveType,1)
    
    
    handles.GeneralData.fs = logMan{2,3};
    handles.log = logMan;
    
    procFiles = [logMan{1,2} filesep 'preprocSettings.mat'];
    
    if exist(procFiles,'file')
        load(procFiles)
        optVar = logMan;
        save([logMan{1,2} filesep 'preprocSettings.mat'],'optVar','genData')
    else
        optVar = logMan;
        handles.GeneralData.fs = optVar{2,3};
        genData = handles.GeneralData;
        save([logMan{1,2} filesep 'preprocSettings.mat'],'optVar','genData')
        
    end
    
end


guidata(hObject,handles)


% --------------------------------------------------------------------
function baselineToolMenu_Callback(hObject, eventdata, handles)
% hObject    handle to baselineToolMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

miniProc(handles.log);


% --------------------------------------------------------------------
function defTrigMenu_Callback(hObject, eventdata, handles)
% hObject    handle to defTrigMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

checkOutTable = handles.log;
if isequal(checkOutTable{1,1},1)
    
    [checkOutTable,longestGuy] = findShortestRec(checkOutTable);
    
    handles.GeneralData.AutoShort = checkOutTable{5,3};
    checkOutTableTI = checkOutTable;
    slprompt = ['The shortest data record is: ' checkOutTable{5,2} '. Length is: ' num2str(checkOutTable{5,3})...
        ' For reference the Longest data record is: ' longestGuy{2} '. Length is: ' num2str(longestGuy{1})...
        '.  If this is an error remove the shortest data record from the Import folder and rerun.'];
    
    choice = questdlg(slprompt,'Info and quest','Okay','Cancel','Okay');
    switch choice
        case 'Longest Rec'
            checkOutTable{5,2} = ['Shortest Rec.: ' longestGuy{2}];
            checkOutTable{5,3} = longestGuy{1};
            checkOutTableTI{7,1} = longestGuy{2};
        case 'Okay'
            checkOutTableTI{7,1} = checkOutTable{5,2};
            checkOutTable{5,2} = ['Shortest Rec.: '  checkOutTable{5,2}];
        otherwise
            return
    end
    
    gennyData = handles.GeneralData;
    if isfield(gennyData,'fs')
        checkOutTableTI{7,2} = gennyData.fs;
    else
        checkOutTableTI{7,2} = 0;
    end
    
    
    workingD = checkOutTableTI{1,2};
    alreadyNamed = exist([workingD filesep 'trigger_definitions.mat'],'file');
    if alreadyNamed>=2
        selection = questdlg('Use already saved trigger definitions?','Load?', ...
            'Use trigger definitions as is','Use trigger definitions and edit','No','Use trigger definitions as is');
        
    else
        selection = 'No';
    end
    
    
    TriggerImporter(checkOutTableTI,selection);
    
    handles.log = checkOutTable;
    
    
    
    
    workingD = checkOutTable{1,2};
    if exist([workingD filesep 'trigger_definitions.mat'],'file')
        load([workingD filesep 'trigger_definitions.mat'])
        
        
        
        
        triggerData = handles.triggerInfo;
        for i = 1:length(triggerData)
            triggerData{i,1} = '';
            triggerData{i,2} = '';
        end
        
        
        countTheOccur = 0;
        
        for i = 1:size(occurrances,1)
            triggerData{i,1} = occurrances{i,1};
            triggerData{i,2} = occurrances{i,2};
            countTheOccur = countTheOccur + occurrances{i,2};
            
        end
        
        handles.stimNum.String = num2str(countTheOccur);
        handles.GeneralData.stimNum = countTheOccur;
        handles.GeneralData.triggerNames = triggerData;
        handles.triggerInfo = triggerData;
        
        
        checkOutTable = handles.log;
        checkOutTable{6,3} = ['Trial Num: ' num2str(countTheOccur)];
        checkOutTable{6,2} = [triggerData{1} ' etc...'];
        checkOutTable{6,1} = 1;
        handles.log = checkOutTable;
    end
    % Update handles structure
    guidata(hObject, handles);
else
    warndlg('First Use Import Functions to enable this functionality')
end



% --------------------------------------------------------------------
function importPreProcOptMenu_Callback(hObject, eventdata, handles)
% hObject    handle to importPreProcOptMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curLoc = pwd;
genData = handles.GeneralData;

if isfield(genData,'papaDir')
    papaDir = handles.GeneralData.importFolder;
    [FileName,PathName] = uigetfile([papaDir filesep 'prepro*.mat'],'Select Folder with preproccess file');
else
    [FileName,PathName] = uigetfile([curLoc filesep 'prepro*.mat'],'Select Folder with preproccess file');
end

if ~ischar(PathName)
    return
end


load([PathName FileName])

checkOutTable = handles.log;
checkOutTable{3,1} = optVar{3,1};
checkOutTable{3,2} = optVar{3,2};
checkOutTable{3,3} = optVar{3,3};
checkOutTable{4,1} = optVar{4,1};
checkOutTable{4,2} = optVar{4,2};
checkOutTable{4,3} = optVar{4,3};
checkOutTable{2,1} = optVar{2,1};
checkOutTable{2,2} = optVar{2,2};
checkOutTable{2,3} = optVar{2,3};

handles.GeneralData.fs = genData.fs;


handles.log = checkOutTable;

guidata(hObject, handles);



% --------------------------------------------------------------------
function runPreProc_Callback(hObject, eventdata, handles)
% hObject    handle to runPreProc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles] = checkValForPreProcess(handles);

guidata(hObject,handles)

if isequal(handles.log{1,1},0)
    warndlg('First load some eye tracking data','No files')
    return
elseif isequal(handles.GeneralData.preProcOkay,0)
    warndlg('Looks like not all the preprocess options have been set. Check Command line for more info.','PreProc Opt Error')
    return
end
dataOpt = handles.log;
genData = handles.GeneralData;
userShort = dataOpt{5,3};
autoShort =  genData.AutoShort;
success = 0;

% Change mouse pointer (cursor) to an hourglass.
% QUIRK: use 'watch' and you'll actually get an hourglass not a watch.
set(gcf,'Pointer','watch');
drawnow;	% Cursor won't change right away unless you do this.
try
    success = preProcessPupil_Wrapper(dataOpt,genData);
catch ME
    set(gcf,'Pointer','arrow');
    drawnow;
    warndlg('Something didn''t go as planned.  Check error and try again','Preprocess Error')
    rethrow(ME)
end

set(gcf,'Pointer','arrow');
drawnow;	% Cursor won't change right away unless you do this.

if success
    % Change mouse pointer (cursor) to an arrow.
    warndlg('PreProccessing Complete!')
    handles.graphName.String = 'PreProccessing Complete!';
    handles.GeneralData.runAnalysisOkay = 1;
    disp('Preproccessing Finished')
    optVar = handles.log;
    workingD = optVar{1,2};
    % save current values to new prepocessing file
    save([workingD filesep 'preprocSettings.mat'] ,'optVar','genData')
    handles.analysisMenu.Enable = 'on';
else
    warndlg('Something isn''t Right')
end
guidata(hObject, handles);



% --------------------------------------------------------------------
% ANALYSIS MENU FUNCTIONS
% --------------------------------------------------------------------
function analysisMenu_Callback(hObject, eventdata, handles)
% hObject    handle to analysisMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function setAlphaMenu_Callback(hObject, eventdata, handles)
% hObject    handle to setAlphaMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ninetyMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ninetyMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if strcmpi(hObject.Checked,'on')
    disp('Alpha already set at .90')
else
    handles.ninetyMenu.Checked = 'on';
    handles.ninetynineMenu.Checked = 'off';
    handles.ninetyfiveMenu.Checked = 'off';
    handles.otherAlphaMenu.Checked = 'off';
    disp('Alpha set at .90')
end
handles.alphaSelect = .90;
guidata(hObject,handles)


% --------------------------------------------------------------------
function ninetyfiveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ninetyfiveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmpi(hObject.Checked,'on')
    disp('Alpha already set at .95')
else
    handles.ninetyMenu.Checked = 'off';
    handles.ninetynineMenu.Checked = 'off';
    handles.ninetyfiveMenu.Checked = 'on';
    handles.otherAlphaMenu.Checked = 'off';
    disp('Alpha set at .95')
end
handles.alphaSelect = .95;
guidata(hObject,handles)





% --------------------------------------------------------------------
function ninetynineMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ninetynineMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmpi(hObject.Checked,'on')
    disp('Alpha already set at .99')
else
    handles.ninetyMenu.Checked = 'off';
    handles.ninetynineMenu.Checked = 'on';
    handles.ninetyfiveMenu.Checked = 'off';
    handles.otherAlphaMenu.Checked = 'off';
    disp('Alpha set at .99')
end
handles.alphaSelect = .99;
guidata(hObject,handles)



% --------------------------------------------------------------------
function otherAlphaMenu_Callback(hObject, eventdata, handles)
% hObject    handle to otherAlphaMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if strcmpi(hObject.Checked,'on')
    disp(['Alpha was set at ' num2str(handles.alphaSelect)])
    answer = inputdlg('Enter new Alpha:','Alpha');
    newAlpha = str2double(answer{1});
    
else
    answer = inputdlg('Enter new Alpha:','Alpha');
    newAlpha = str2double(answer{1});
    handles.ninetyMenu.Checked = 'off';
    handles.ninetynineMenu.Checked = 'off';
    handles.ninetyfiveMenu.Checked = 'off';
    handles.otherAlphaMenu.Checked = 'on';
end

if newAlpha >=1
    newAlpha = newAlpha/100;
end

handles.alphaSelect = newAlpha;
disp(['Alpha set at ' num2str(handles.alphaSelect)])

guidata(hObject,handles)




% --------------------------------------------------------------------
function runAnalysisMenu_Callback(hObject, eventdata, handles)
% hObject    handle to runAnalysisMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

checkOutTable = handles.log;
importFolder = checkOutTable{1,2};
success = 0;
parentDir = handles.GeneralData.papaDir;

if exist([importFolder filesep 'epoched_preproc.mat'],'file')
    set(gcf,'Pointer','watch');
    drawnow;
    try
        success = analysisWrapper([importFolder filesep 'epoched_preproc.mat'],parentDir,handles.alphaSelect);
    catch ME
        set(gcf,'Pointer','arrow');
        drawnow;
        warndlg('Something didn''t go as planned.  Check error and try again','Analysis Error')
        success = 0;
        rethrow(ME)
    end
    
else
    success = 0;
    warndlg('Could not find Epoched files')
end


set(gcf,'Pointer','arrow');
drawnow;

if success
    
    warndlg('Analysis Finished')
    handles.plotMenu.Enable = 'on';
    handles.graphName.String = 'Analysis Finished.  Ready to plot.';
    handles.GeneralData.selectMe = 1:length(handles.GeneralData.triggerNames);
else
    warndlg('Something isn''t right')
    return
end
guidata(hObject, handles);


% --------------------------------------------------------------------
% PLOT MENU FUNCTIONS
% --------------------------------------------------------------------
function plotMenu_Callback(hObject, eventdata, handles)
% hObject    handle to plotMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function selConMenu_Callback(hObject, eventdata, handles)
% hObject    handle to selConMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
triggyN = handles.GeneralData.triggerNames;

condiSelect = cell(length(triggyN),1);

for i = 1:length(condiSelect)
    condiSelect{i}=triggyN{i,1};
end

[s,v] = listdlg('PromptString','Choose Conditions to Compare','Name',...
    'Condition Select','ListString',condiSelect,'ListSize',[250 300]);


if v
    handles.GeneralData.selectMe = s;
end
guidata(hObject,handles)

% --------------------------------------------------------------------
function plotTypeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to plotTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveplotMenu_Callback(hObject, eventdata, handles)
% hObject    handle to saveplotMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function plotNewWinMenu_Callback(hObject, eventdata, handles)
% hObject    handle to plotNewWinMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

subAxe = handles.mainAxe;
handleLEG = handles;

sFig = figure;
newAx = copyobj(subAxe,sFig);
if isfield(handleLEG,'GraphingStuff')
    hLeg = handles.GraphingStuff.hLeg;
    legend(newAx,hLeg);
end

set(newAx, 'units', 'normalized', 'position', [0.13 0.11 0.775 0.815]);
title(gca,handles.graphName.String)


% --------------------------------------------------------------------
function saveAsJpegMenu_Callback(hObject, eventdata, handles)
% hObject    handle to saveAsJpegMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveNameFig = inputdlg('Give the image file a name');
if isempty(saveNameFig)
    return
end
checkOutTable = handles.log;
workingD = checkOutTable{1,2};
saveD = [workingD filesep 'Figures'];

if ~exist(saveD,'dir')
    mkdir(saveD)
end


saveNameFig = saveNameFig{1};
subAxe = handles.mainAxe;
handleLEG = handles;

sFig = figure('Name',saveNameFig);
newAx = copyobj(subAxe,sFig);
if isfield(handleLEG,'GraphingStuff')
    hLeg = handles.GraphingStuff.hLeg;
    legend(newAx,hLeg);
end

set(newAx, 'units', 'normalized', 'position', [0.13 0.11 0.775 0.815]);
title(gca,handles.graphName.String)
saveas(sFig,[saveD filesep saveNameFig '.jpeg'])    % save it
close(sFig)
disp(['image location: ' saveD filesep saveNameFig '.jpeg'])


% --------------------------------------------------------------------
function saveAsFig_Callback(hObject, eventdata, handles)
% hObject    handle to saveAsFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saveNameFig = inputdlg('Give the figure a name');
if isempty(saveNameFig)
    return
end
checkOutTable = handles.log;
workingD = checkOutTable{1,2};
saveD = [workingD filesep 'Figures'];

if ~exist(saveD,'dir')
    mkdir(saveD)
end


saveNameFig = saveNameFig{1};
subAxe = handles.mainAxe;
handleLEG = handles;

sFig = figure('Name',saveNameFig);
newAx = copyobj(subAxe,sFig);
if isfield(handleLEG,'GraphingStuff')
    hLeg = handles.GraphingStuff.hLeg;
    legend(newAx,hLeg);
end

set(newAx, 'units', 'normalized', 'position', [0.13 0.11 0.775 0.815]);
title(gca,handles.graphName.String)
saveas(sFig,[saveD filesep saveNameFig '.fig'])    % save it
close(sFig)
disp(['figure location: ' saveD filesep saveNameFig '.fig'])

% --------------------------------------------------------------------
function plot1Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot1Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar =  handles.log;
saveDir = optVar{1,2};


analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
sampleRate = handles.GeneralData.fs;

set(handles.mainAxe,'XTickLabelRotation',0);

% Dirty Data (no corrections all subjects)

num_parts = analysisVariables.num_participants_F(1);
maxSamp = max(size(analysisVariables.Stimulations_All));

scatter(handles.mainAxe,1:maxSamp,...
    analysisVariables.L_stim(1,maxSamp-(maxSamp-1):maxSamp),4,'k','filled') %
% tester = analysisVariables.L_stim(1,foo-(foo-1):foo);
xtickMSLabel = (0:round((maxSamp*sampleRate)/11):maxSamp*sampleRate);


hold on; % we will add to plot, rather than replace with new data
for j = 2:num_parts % repeat for remaining participants
    %foo = max(size(data(j).trial_data(6).CleanPupil)); % how many samples
    scatter(handles.mainAxe,1:maxSamp,...
        analysisVariables.L_stim(j,maxSamp-(maxSamp-1):maxSamp),4,'k','filled')
end

%
hold off; % done adding data

handles.mainAxe.XLabel.String = 'Time (ms)';
handles.mainAxe.YLabel.String = 'Pupil diameter (mm)';
set(handles.mainAxe,'XTick',0:(maxSamp/10):maxSamp,'XTickLabel',xtickMSLabel); % ticks along x axis
handles.graphName.String = 'Left pupils of all subjects uncleaned values';
set(handles.mainAxe,'Box','off', 'FontSize',10);
set(handles.mainAxe,'XMinorTick','on')
grid on
[hObject,handles] = plotMenuCheck(hObject,handles);
guidata(hObject,handles)



% --------------------------------------------------------------------
function plot2Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot2Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar =  handles.log;
saveDir = optVar{1,2};


analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
sampleRate = handles.GeneralData.fs;
set(handles.mainAxe,'XTickLabelRotation',0);

% Cleaned Data (no corrections all subjects)
num_parts = analysisVariables.num_participants_F(1); % how many participants?


foo = max(size(analysisVariables.Stimulations_All)); % how many samples?

scatter(handles.mainAxe,1:foo,analysisVariables.Stimulations_All(1,foo-(foo-1):foo),4,'k','filled') % plot the
hold on; % we will add to plot, rather than replace with new data
for j = 2:num_parts % repeat for remaining participants
    %foo = max(size(data(j).trial_data(6).CleanPupil)); % how many samples
    scatter(handles.mainAxe,1:foo,analysisVariables.Stimulations_All(j,foo-(foo-1):foo),4,'k','filled') % plot last 600
end
hold off; % done adding data

handles.mainAxe.XLabel.String = 'Time (ms)';
handles.mainAxe.YLabel.String = 'Pupil diameter (mm)';
xtickMSLabel = (0:round((foo*sampleRate)/8):foo*sampleRate);
set(handles.mainAxe,'XTick',0:(foo/6):foo,'XTickLabel',xtickMSLabel); % ticks along x axis
handles.graphName.String = [analysisVariables.Stimulations_names{1} ' cleaned values'];

set(handles.mainAxe,'Box','off', 'FontSize',10);
set(handles.mainAxe,'XMinorTick','on')


grid on
[hObject,handles] = plotMenuCheck(hObject,handles);
guidata(hObject,handles)


% --------------------------------------------------------------------
function plot3Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot3Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar =  handles.log;
saveDir = optVar{1,2};


analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
num_stimuli = size(handles.GeneralData.triggerNames,1);
Colors = handles.graphingStuff.Colors(1:num_stimuli,:);
sampleRate = handles.GeneralData.fs;


trialOpts = optVar{4,2};

interestLine = trialOpts.*sampleRate;
interestLineSamples = numel(interestLine(1):interestLine(2));
% show means by problem type
xtack = interestLine(1):(interestLineSamples/6):interestLine(2);
posVals = find(xtack>0);
negVals = find(xtack<0);

if ~isequal(numel(negVals),1) && ~isempty(negVals)
    baseVals = xtack(negVals(1)):(xtack(negVals(1))/numel(negVals))*-1:0;
else
    baseVals = xtack;
end

xtickle = zeros(length(xtack)+1,1);
xtickle(posVals+1) = xtack(posVals);
xtickle(negVals) = baseVals(negVals);

x = interestLine(1)+1:interestLine(2);
xtickMSLabel = ceil((xtickle/sampleRate)*1000);

xlim(handles.mainAxe,[xtickle(1) xtickle(end)])

% set(handles.mainAxe,'XTickLabelRotation',0);

if ~isequal(handles.GeneralData.selectMe,1:num_stimuli)
    
    num_stimuli = handles.GeneralData.selectMe;
else
    num_stimuli = 1:num_stimuli;
end
namesOFcondi = cell(length(num_stimuli),1);
hold on;
set(handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
outCount = 1;
for i = num_stimuli %(2:end)
    plot(handles.mainAxe,x,analysisVariables.X_Uncorr_DataSelected_Means(i,:),'buttonDownFcn',@mainAxe_ButtonDownFcn);
    %squeeze(Stimuli_Data_Corr_Mean(:,:,i))));%,'Color',Colors(i,:));
    namesOFcondi{outCount} = analysisVariables.Stimulations_names{i};
    outCount = outCount + 1;
end

handles.graphName.String = 'Uncorrected with baseline pupil diameter evolution';
handles.mainAxe.XLabel.String = 'Time (ms)';
handles.mainAxe.YLabel.String = 'Average change in pupil diameter (mm)';
set(handles.mainAxe,'XTick',xtickle,'XTickLabel',xtickMSLabel); % ticks along x axis
set(handles.mainAxe,'XMinorTick','on')

grid on
guidata(hObject,handles)
% Addition of the confidence intervals
AnswerDel = questdlg('Do you want to add confidence intervals ?','CI','Yes - Between Subject','Yes - Within Subject','No','Yes - Between Subject');
handles.GeneralData.AnswerDel = AnswerDel;
if strcmpi(AnswerDel,'Yes - Between Subject')
    set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
    X=[x,fliplr(x)];
    colorCounter = 1;
    for stimulus = num_stimuli
        fillUP = analysisVariables.X_Uncorr_DataSelected_CI_Above(stimulus,:);
        fillDown = analysisVariables.X_Uncorr_DataSelected_CI_Below(stimulus,:);
        Y=[fillUP,fliplr(fillDown)];
        fill(X,Y,Colors(stimulus,:));
        colorCounter = colorCounter +1;
    end
    
    f = findobj(handles.mainAxe,'Type','patch');
    alpha(f,0.05)
elseif strcmpi(AnswerDel,'Yes - Within Subject')
    % Add
    [ciAbove,ciBelow]=CI_loftus_wthnPT(num_stimuli,analysisVariables.X_Uncorr_DataSelected,...
        analysisVariables.num_participants_F,analysisVariables.X_Uncorr_DataSelected_Means,analysisVariables.zScore);
    set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
    X=[x,fliplr(x)];
    for stimulus = num_stimuli
        fillUP = ciAbove(stimulus,:);
        fillDown = ciBelow(stimulus,:);
        Y=[fillUP,fliplr(fillDown)];
        fill(X,Y,Colors(stimulus,:));
    end
    
    f = findobj(handles.mainAxe,'Type','patch');
    alpha(f,0.05)
    
    
end


handles.GraphingStuff.hLeg = namesOFcondi;
y1 = ylim;
% y1(2) = max(Y);
line([0 0],y1,'LineWidth',1,...
    'Color',[0 0 0],...
    'LineStyle','--');%,...
%'Parent',handles.mainAxe);
hold off
legend(handles.mainAxe,namesOFcondi);
[hObject,handles] = plotMenuCheck(hObject,handles);
guidata(hObject,handles)


% --------------------------------------------------------------------
function plot4Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot4Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar = handles.log;
saveDir = optVar{1,2};

num_stimuli = size(handles.GeneralData.triggerNames,1);

analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
num_stimuli = size(handles.GeneralData.triggerNames,1);
Colors = handles.graphingStuff.Colors(1:num_stimuli,:);
sampleRate = handles.GeneralData.fs;

trialOpts = optVar{4,2};

interestLine = trialOpts.*sampleRate;
interestLineSamples = numel(interestLine(1):interestLine(2));
% show means by problem type
xtack = interestLine(1):(interestLineSamples/6):interestLine(2);
posVals = find(xtack>0);
negVals = find(xtack<0);


if ~isequal(numel(negVals),1) && ~isempty(negVals)
    baseVals = xtack(negVals(1)):(xtack(negVals(1))/numel(negVals))*-1:0;
else
    baseVals = xtack;
end


xtickle = zeros(length(xtack)+1,1);
xtickle(posVals+1) = xtack(posVals);
xtickle(negVals) = baseVals(negVals);

x = interestLine(1)+1:interestLine(2);
xtickMSLabel = ceil((xtickle/sampleRate)*1000);
xlim(handles.mainAxe,[xtickle(1) xtickle(end)])

set(handles.mainAxe,'XTickLabelRotation',0);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Percentage of change of pupil diameter

% Plot of percentage of change of pupil diameter over time for each stimulus
if ~isequal(handles.GeneralData.selectMe,1:num_stimuli)
    num_stimuli = handles.GeneralData.selectMe;
else
    num_stimuli = 1:num_stimuli;
end

hold on
set(handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
for stimulus = num_stimuli
    plot(handles.mainAxe,x,analysisVariables.X_Perc_DataSelected_Means(stimulus,:));
end
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



set(handles.mainAxe,'XTick',xtickle);
set(handles.mainAxe,'XTickLabel', xtickMSLabel);
handles.mainAxe.XLabel.String = 'Time (ms)';
handles.mainAxe.YLabel.String = 'Pupil diameter change (%)';
set(handles.mainAxe,'Box','off', 'FontSize',10);
set(handles.mainAxe,'XMinorTick','on')
grid on
guidata(hObject,handles)

handles.graphName.String = 'Percentage of change of the baseline corrected pupil diameter over time';

% Addition of the confidence intervals
AnswerDel = questdlg('Do you want to add confidence intervals ?','CI','Yes - Between Subject','Yes - Within Subject','No','Yes - Between Subject');
handles.GeneralData.AnswerDel = AnswerDel;
if strcmpi(AnswerDel,'Yes - Between Subject');
    %set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
    %plot(handles.mainAxe,X_Perc_DataSelected_CI_Above(num_stimuli,:));
    %plot(handles.mainAxe,X_Perc_DataSelected_CI_Below(num_stimuli,:));
    X=[x,fliplr(x)];
    colorCounter = 1;
    for stimulus = num_stimuli
        fillUP = analysisVariables.X_Perc_DataSelected_CI_Above(stimulus,:);
        fillDown = analysisVariables.X_Perc_DataSelected_CI_Below(stimulus,:);
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
    [ciAbove,ciBelow]=CI_loftus_wthnPT(num_stimuli,analysisVariables.X_Perc_DataSelected,...
        analysisVariables.num_participants_F,analysisVariables.X_Perc_DataSelected_Means,analysisVariables.zScore);
    set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
    X=[x,fliplr(x)];
    for stimulus = num_stimuli
        fillUP = ciAbove(stimulus,:);
        fillDown = ciBelow(stimulus,:);
        Y=[fillUP,fliplr(fillDown)];
        fill(X,Y,Colors(stimulus,:));
    end
    
    f = findobj(handles.mainAxe,'Type','patch');
    alpha(f,0.1)
end


handles.GraphingStuff.hLeg = Stimuli_selected_names;
y1 = ylim;
% y1(2) = max(Y);
line([0 0],y1,'LineWidth',1,...
    'Color',[0 0 0],...
    'LineStyle','--',...
    'Parent',handles.mainAxe);
hold off
legend(handles.mainAxe,Stimuli_selected_names);
[hObject,handles] = plotMenuCheck(hObject,handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function plot5Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot5Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar = handles.log;
saveDir = optVar{1,2};

num_stimuli = size(handles.GeneralData.triggerNames,1);

analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
Colors = handles.graphingStuff.Colors(1:num_stimuli,:);
sampleRate = handles.GeneralData.fs;
trialOpts = optVar{4,2};

interestLine = trialOpts.*sampleRate;
interestLineSamples = numel(interestLine(1):interestLine(2));
% show means by problem type
x = interestLine(1)+1:interestLine(2);

xtack = interestLine(1):(interestLineSamples/6):interestLine(2);
posVals = find(xtack>0);
negVals = find(xtack<0);


if ~isequal(numel(negVals),1) && ~isempty(negVals)
    baseVals = xtack(negVals(1)):(xtack(negVals(1))/numel(negVals))*-1:0;
else
    baseVals = xtack;
end

xtickle = zeros(length(xtack)+1,1);
xtickle(posVals+1) = xtack(posVals);
xtickle(negVals) = baseVals(negVals);

xtickMSLabel = ceil((xtickle/sampleRate)*1000);

xlim(handles.mainAxe,interestLine)


% set(handles.mainAxe,'XTickLabelRotation',0);

% Baseline-corrected data
% Plot of baseline-corrected pupil diameter over time for each stimulus
% show means by problem type

if ~isequal(handles.GeneralData.selectMe,1:num_stimuli)
    num_stimuli = handles.GeneralData.selectMe;
else
    num_stimuli = 1:num_stimuli;
end
namesOFcondi = cell(length(num_stimuli),1);
hold on;
set(handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
outCount = 1;
for i = num_stimuli %(2:end)
    plot(handles.mainAxe,x,analysisVariables.X_Corr_DataSelected_Means(i,:));
    namesOFcondi{outCount} = analysisVariables.Stimulations_names{i};
    outCount = outCount + 1;
end

handles.graphName.String = 'Baseline-corrected pupil diameter evolution';
handles.mainAxe.XLabel.String = 'Time (ms)';
handles.mainAxe.YLabel.String = 'Average change in pupil diameter (mm)';
set(handles.mainAxe,'XTick',xtickle,'XTickLabel',xtickMSLabel); % ticks along x axis
set(handles.mainAxe,'XMinorTick','on')
grid on
guidata(hObject,handles)
% Addition of the confidence intervals
AnswerDel = questdlg('Do you want to add confidence intervals ?','CI','Yes - Between Subject','Yes - Within Subject','No','Yes - Between Subject');
handles.GeneralData.AnswerDel = AnswerDel;
if strcmpi(AnswerDel,'Yes - Between Subject');
    set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
    X=[x,fliplr(x)];
    
    for stimulus = num_stimuli
        fillUP = analysisVariables.X_Corr_DataSelected_CI_Above(stimulus,:);
        fillDown = analysisVariables.X_Corr_DataSelected_CI_Below(stimulus,:);
        Y=[fillUP,fliplr(fillDown)];
        fill(X,Y,Colors(stimulus,:));
    end
    
    f = findobj(handles.mainAxe,'Type','patch');
    alpha(f,0.1)
elseif strcmpi(AnswerDel,'Yes - Within Subject')
    % Add
    [ciAbove,ciBelow]=CI_loftus_wthnPT(num_stimuli,analysisVariables.X_Corr_DataSelected,...
        analysisVariables.num_participants_F,analysisVariables.X_Corr_DataSelected_Means,analysisVariables.zScore);
    set (handles.mainAxe,'ColorOrder',Colors(num_stimuli,:));
    X=[x,fliplr(x)];
    for stimulus = num_stimuli
        fillUP = ciAbove(stimulus,:);
        fillDown = ciBelow(stimulus,:);
        Y=[fillUP,fliplr(fillDown)];
        fill(X,Y,Colors(stimulus,:));
    end
    
    f = findobj(handles.mainAxe,'Type','patch');
    alpha(f,0.1)
    
end

handles.GraphingStuff.hLeg = namesOFcondi;
y1 = ylim;
%y1(2) = max(Y);
line([0 0],y1,'LineWidth',1,...
    'Color',[0 0 0],...
    'LineStyle','--',...
    'Parent',handles.mainAxe);
hold off
legend(handles.mainAxe,namesOFcondi);
[hObject,handles] = plotMenuCheck(hObject,handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function plot6Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot6Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar = handles.log;
saveDir = optVar{1,2};

analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
sampleRate = handles.GeneralData.fs;
trialOpts = optVar{4,2};

interestLine = trialOpts.*sampleRate;
interestLineSamples = numel(interestLine(1):interestLine(2));
% show means by problem type
x = interestLine(1)+1:interestLine(2);

xtack = interestLine(1):(interestLineSamples/6):interestLine(2);
posVals = find(xtack>0);
negVals = find(xtack<0);

if ~isequal(numel(negVals),1) && ~isempty(negVals)
    baseVals = xtack(negVals(1)):(xtack(negVals(1))/numel(negVals))*-1:0;
else
    baseVals = xtack;
end


xtickle = zeros(length(xtack)+1,1);
xtickle(posVals+1) = xtack(posVals);
xtickle(negVals) = baseVals(negVals);

xtickMSLabel = ceil((xtickle/sampleRate)*1000);

xlim(handles.mainAxe,[interestLine(1) xtickle(end)])
set(handles.mainAxe,'XTickLabelRotation',0);
% Plot mean functional pupil diameter by condition

if  isequal(numel(handles.GeneralData.selectMe),1) || gt(numel(handles.GeneralData.selectMe),2)
    warndlg('Please Select Two Conditions to compare.','Condition Select')
else
    compareIndexes = handles.GeneralData.selectMe;
    handles.GeneralData.lastCompIndex = compareIndexes;
    hold on
    %get comparision
    [fdaComplete,~,~,~] = performFDAfunc(analysisVariables.Stimuli_Data_Corr_Mean,compareIndexes,interestLineSamples-1,analysisVariables.alphaSelect,0);
    data_mat = eval_fd(1:interestLineSamples-1,fdaComplete);
    plot(handles.mainAxe,x,data_mat);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % add zero line
    line([x(1) x(end)],[0,0],'Color', 'r');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(handles.mainAxe,'XTick',xtickle);
    set(handles.mainAxe,'XTickLabel',xtickMSLabel);
    handles.mainAxe.XLabel.String = 'Time (ms)';
    handles.mainAxe.YLabel.String = 'Mean pupil diameter difference (mm)';
    condiNames = handles.GeneralData.triggerNames(compareIndexes,1);
    condiMast = [condiNames{1} ' vs ' condiNames{2}];
    
    handles.graphName.String = [condiMast ' mean function pupil diameter difference'];
    set(handles.mainAxe,'Box','off');
    grid on
    [hObject,handles] = plotMenuCheck(hObject,handles);
    guidata(hObject,handles)
    
end

% --------------------------------------------------------------------
function plot7Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot7Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar = handles.log;
saveDir = optVar{1,2};
num_stimuli = size(handles.GeneralData.triggerNames,1);
analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
sampleRate = handles.GeneralData.fs;
trialOpts = optVar{4,2};

interestLine = trialOpts.*sampleRate;
interestLineMSWhole = trialOpts.*1000;

interestLineSamples = numel(interestLine(1):interestLine(2));
% show means by problem type
x = interestLine(1)+1:interestLine(2);

xtack = interestLine(1):(interestLineSamples/6):interestLine(2);
posVals = find(xtack>0);
negVals = find(xtack<0);

if ~isequal(numel(negVals),1) && ~isempty(negVals)
    baseVals = xtack(negVals(1)):(xtack(negVals(1))/numel(negVals))*-1:0;
else
    baseVals = xtack;
end


xtickle = zeros(length(xtack)+1,1);
xtickle(posVals+1) = xtack(posVals);
xtickle(negVals) = baseVals(negVals);

xtickMSLabel = ceil((xtickle/sampleRate)*1000);
% xlim(handles.mainAxe,[interestLine(1) xtickle(end)])

% trialTime = strfind(trialOpts,',T:');
% trialLine = str2double(trialOpts(trialTime+3:end));
interestLineMS = numel(interestLineMSWhole(1)+1:interestLineMSWhole(2));
% interestLineSamples = interestLineSamples*sampleRate;

set(handles.mainAxe,'XTickLabelRotation',0);

% Anova and bin
if ~isequal(handles.GeneralData.selectMe,1:num_stimuli)
    num_stimuli = handles.GeneralData.selectMe;
else
    num_stimuli = 1:num_stimuli;
end

anovaPlotData = analysisVariables.Stimuli_Data_Corr_Mean;

[ANOVA_data,binNumber] = anova_Plot(interestLineSamples-1,interestLineMS,...
    analysisVariables.num_participants_F(1),num_stimuli,...
    anovaPlotData,sampleRate);

handles.GeneralData.binned = binNumber;
if isequal(binNumber,1)
    bar(handles.mainAxe,ANOVA_data')
    set(handles.mainAxe,'Box','off');
    set(handles.mainAxe,'XTick',1:numel(num_stimuli));
    set(handles.mainAxe,'XTickLabel',analysisVariables.Stimulations_names(num_stimuli));
    set(handles.mainAxe,'XTickLabelRotation',90);
    handles.mainAxe.YLabel.String = 'Average pupil diameter change from baseline';
    handles.graphName.String = 'Average change in pupil diameter per Condition';
else
    slots = 1:interestLineSamples/binNumber:interestLineSamples;
    
    bar_data = reshape(mean(ANOVA_data),numel(num_stimuli),binNumber)';
    slots = ((slots-1)/sampleRate)*1000;
    
    bar(handles.mainAxe,slots,bar_data);
    set(handles.mainAxe,'Box','off');
    set(handles.mainAxe,'XTick',slots);
    set(handles.mainAxe,'XTickLabel',xtickMSLabel);
    
    handles.mainAxe.XLabel.String = 'Time from stimulus onset (ms)';
    handles.mainAxe.YLabel.String = 'Average pupil diameter change from baseline';
    
    legend(handles.mainAxe,analysisVariables.Stimulations_names(num_stimuli));%,'FontSize',8, 'Location','NorthWestOutside');
    handles.GraphingStuff.hLeg = analysisVariables.Stimulations_names(num_stimuli);
    set(handles.mainAxe,'XMinorTick','on')
    
    handles.graphName.String = 'Average change in pupil diameter at key points over time';
end

grid on
hold off
[hObject,handles] = plotMenuCheck(hObject,handles);
guidata(hObject,handles)


% --------------------------------------------------------------------
function plot8Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot8Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar = handles.log;
saveDir = optVar{1,2};
num_stimuli = size(handles.GeneralData.triggerNames,1);
analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
sampleRate = handles.GeneralData.fs;
trialOpts = optVar{4,2};

interestLine = trialOpts.*sampleRate;
interestLineSamples = numel(interestLine(1):interestLine(2));
% show means by problem type
x = interestLine(1)+1:interestLine(2);

xtack = interestLine(1):(interestLineSamples/5):interestLine(2);
posVals = find(xtack>0);
negVals = find(xtack<0);

if ~isequal(numel(negVals),1) && ~isempty(negVals)
    baseVals = xtack(negVals(1)):(xtack(negVals(1))/numel(negVals))*-1:0;
else
    baseVals = xtack;
end


xtickle = zeros(length(xtack)+1,1);
xtickle(posVals+1) = xtack(posVals);
xtickle(negVals) = baseVals(negVals);

xtickMSLabel = ceil((xtickle/sampleRate)*1000);



set(handles.mainAxe,'XTickLabelRotation',0);
% stimuli factor p-value over time
triggerNames = handles.GeneralData.triggerNames;

triggerNames(:,2) = [];
if ~isequal(handles.GeneralData.selectMe,1:num_stimuli)
    num_stimuli = handles.GeneralData.selectMe;
else
    num_stimuli = 1:num_stimuli;
end

[~,P_stim,~] = pStim(analysisVariables.Stimuli_Data_Corr_Mean,...
    analysisVariables.Stimuli_Data_Perc_Mean,...
    num_stimuli,triggerNames,analysisVariables.TF_REP,...
    analysisVariables.alphaReal,0,1);

p_time = P_stim.ptime;
p_sign = P_stim.psign;



plot(handles.mainAxe,p_time(1,:));
h = findobj(handles.mainAxe,'Type','line');
set(h(1),'Color','k','LineWidth',2);
hold on;

plot(handles.mainAxe,p_sign(1,:));
h = findobj(handles.mainAxe,'Type','line');
set(h(1),'Color','r','LineWidth',2);

handles.GraphingStuff.hLeg = ['p-value (stimuli)',num2str(analysisVariables.alphaReal)];
set(handles.mainAxe,'XTick',xtickle);
set(handles.mainAxe,'XTickLabel', xtickMSLabel);
handles.mainAxe.XLabel.String = 'Time (ms)';
handles.mainAxe.YLabel.String = 'p-value';
set(handles.mainAxe,'Box','off');

if isequal(numel(num_stimuli),1)
    condiNames = [triggerNames{num_stimuli(1)}];
elseif isequal(numel(num_stimuli),2)
    condiNames = [triggerNames{num_stimuli(1)} ' vs ' triggerNames{num_stimuli(2)}];
else
    condiNames = 'All Conditions';
end
handles.graphName.String = ['P-value stimuli factor over time for: ' condiNames];
set(handles.mainAxe,'XMinorTick','on')
grid on
hold off
legend(handles.mainAxe,'p-value (stimuli)',num2str(analysisVariables.alphaReal));
[hObject,handles] = plotMenuCheck(hObject,handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function plot9Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot9Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar = handles.log;
saveDir = optVar{1,2};
num_stimuli = size(handles.GeneralData.triggerNames,1);
analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
sampleRate = handles.GeneralData.fs;
trialOpts = optVar{4,2};

interestLine = trialOpts.*sampleRate;
interestLineSamples = numel(interestLine(1):interestLine(2));
% show means by problem type
x = interestLine(1)+1:interestLine(2);

xtack = interestLine(1):(interestLineSamples/6):interestLine(2);
posVals = find(xtack>0);
negVals = find(xtack<0);

if ~isequal(numel(negVals),1) && ~isempty(negVals)
    baseVals = xtack(negVals(1)):(xtack(negVals(1))/numel(negVals))*-1:0;
else
    baseVals = xtack;
end


xtickle = zeros(length(xtack)+1,1);
xtickle(posVals+1) = xtack(posVals);
xtickle(negVals) = baseVals(negVals);

xtickMSLabel = ceil((xtickle/sampleRate)*1000);

set(handles.mainAxe,'XTickLabelRotation',0);
% Functional t-test of difference (corrected)
triggerNamesTop = handles.GeneralData.triggerNames;


if ~isequal(handles.GeneralData.selectMe,1:num_stimuli)
    num_stimuli = handles.GeneralData.selectMe;
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
    num_stimuli,triggerNames,analysisVariables.TF_REP,...
    analysisVariables.alphaReal,0,0);

F_time = F_stim.ftime;
F_Sign = F_stim.fsign;


plot(handles.mainAxe,F_time(1,:));
h = findobj(handles.mainAxe,'Type','line');
set(h(1),'Color','k','LineWidth',2);
hold on;
plot(handles.mainAxe,F_Sign(1,:));
h = findobj(handles.mainAxe,'Type','line');
set(h(1),'Color','r','LineWidth',2);

exLeg = ['sign. ' num2str(analysisVariables.alphaReal*100) '%'];
handles.GraphingStuff.hLeg = {'F',exLeg};
set(handles.mainAxe,'XTick',xtickle);
set(handles.mainAxe,'XTickLabel',xtickMSLabel);
handles.mainAxe.XLabel.String = 'Time (ms)';
handles.mainAxe.YLabel.String = 'f-value';
set(handles.mainAxe,'Box','off');


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
handles.graphName.String = condiNames;
set(handles.mainAxe,'XMinorTick','on')

grid on
hold off
legend(handles.mainAxe,'F',['significance ' num2str(analysisVariables.alphaReal*100) '%']);
[hObject,handles] = plotMenuCheck(hObject,handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function plot10Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot12Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar = handles.log;
saveDir = optVar{1,2};
num_stimuli = size(handles.GeneralData.triggerNames,1);
analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
sampleRate = handles.GeneralData.fs;
trialOpts = optVar{4,2};

interestLine = trialOpts.*sampleRate;
interestLineSamples = numel(interestLine(1):interestLine(2));
% show means by problem type
x = interestLine(1)+1:interestLine(2);

xtack = interestLine(1):(interestLineSamples/5):interestLine(2);
posVals = find(xtack>0);
negVals = find(xtack<0);

if ~isequal(numel(negVals),1) && ~isempty(negVals)
    baseVals = xtack(negVals(1)):(xtack(negVals(1))/numel(negVals))*-1:0;
else
    baseVals = xtack;
end


xtickle = zeros(length(xtack)+1,1);
xtickle(posVals+1) = xtack(posVals);
xtickle(negVals) = baseVals(negVals);

xtickMSLabel = ceil((xtickle/sampleRate)*1000);
set(handles.mainAxe,'XTickLabelRotation',0);

% Plot functional t-test pupil diameter by condition

if isequal(numel(handles.GeneralData.selectMe),1) || gt(numel(handles.GeneralData.selectMe),2)
    triggyN = handles.GeneralData.triggerNames;
    
    condiSelect = cell(length(triggyN),1);
    
    for i = 1:length(condiSelect)
        condiSelect{i}=triggyN{i,1};
    end
    
    [s,v] = listdlg('PromptString','Choose Conditions to Compare','Name',...
        'Condition Select','ListString',condiSelect,'ListSize',[250 300]);
    
    
    if v
        if isequal(size(s,2),2)
            handles.GeneralData.selectMe = s;
        else
            warndlg('Please select only two conditions')
            return
        end
    else
        return
    end
    guidata(hObject,handles)
end


compareIndexes = handles.GeneralData.selectMe;
handles.GeneralData.lastCompIndex = compareIndexes;

%get comparision
[~,t_fd,crit_t_val,numTails] = performFDAfunc(analysisVariables.Stimuli_Data_Corr_Mean,compareIndexes,interestLineSamples-1,analysisVariables.alphaSelect,1);
handles.GeneralData.tailNumber = numTails;

plot(handles.mainAxe,x,t_fd,'Color','k','LineWidth',4);
lineOne = line([x(1) x(end)],[crit_t_val,crit_t_val],'Color', 'r');
lineTwo = line([x(1) x(end)],[-crit_t_val,-crit_t_val],'Color', 'r');

%set(handles.mainAxe,'Children',[lineOne lineTwo])
xlim(handles.mainAxe,[interestLine(1) xtickle(end)])
set(handles.mainAxe,'XTick',xtickle);
set(handles.mainAxe,'XTickLabel',xtickMSLabel);
handles.mainAxe.XLabel.String = 'Time (ms)';
handles.mainAxe.YLabel.String = 't-test value';
condiNames = handles.GeneralData.triggerNames;
conditions = [condiNames{compareIndexes(1),1} ' - ' condiNames{compareIndexes(2),1}];

handles.graphName.String = [conditions ': Functional t-test of the difference'];
set(handles.mainAxe,'Box','off');
grid on

handles.GraphingStuff.hLeg = {'t-val over time',['Critical t-value ' num2str(crit_t_val)]};
hold off
legend(handles.mainAxe,{'t-val over time',['Critical t-value ' num2str(crit_t_val)]});
[hObject,handles] = plotMenuCheck(hObject,handles);
guidata(hObject,handles)


% --------------------------------------------------------------------
function plot11Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot12Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar = handles.log;
saveDir = optVar{1,2};
analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
sampleRate = handles.GeneralData.fs;
trialOpts = optVar{4,2};

set(handles.mainAxe,'XTickLabelRotation',0);

% PCA (corrected)
% ------------ PCA
triggerNames = handles.GeneralData.triggerNames;

triggerNames(:,2) = [];

if isequal(numel(handles.GeneralData.selectMe),1) || gt(numel(handles.GeneralData.selectMe),2)
    warndlg('Please Select Two Conditions to compare.','Condition Select')
else
    num_stimuli = handles.GeneralData.selectMe;
    
    [~,~,PCA_time] = pStim(analysisVariables.Stimuli_Data_Corr_Mean,...
        analysisVariables.Stimuli_Data_Perc_Mean,...
        num_stimuli,triggerNames,analysisVariables.TF_REP,...
        analysisVariables.alphaReal,1,0);
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
            disp('DOES discriminate conditions')
            disp('p-value of condition effect')
            disp(p_PCA(Component,1))
        else
            disp('DOES NOT discriminate conditions')
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
    xlaborDor = ceil(begin_MS:round(end_MS/19):end_MS);
    xlim(handles.mainAxe,[xTickle(1) xTickle(end)])
    set(handles.mainAxe,'XTick',xTickle);
    set(handles.mainAxe,'XTickLabel',xlaborDor);
    handles.mainAxe.XLabel.String = 'Time (ms)';
    handles.mainAxe.YLabel.String = 'Factor Loadings';
    set(handles.mainAxe,'Box','off');
    handles.graphName.String = ['Factor loadings over time for: ' triggerNames{num_stimuli(1)} ' vs ' triggerNames{num_stimuli(2)}];
    set(handles.mainAxe,'XMinorTick','on')
    grid on
    hold off
    [hObject,handles] = plotMenuCheck(hObject,handles);
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function plot12Menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot12Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the mainAxe
cla(handles.mainAxe)
legend(handles.mainAxe,'off')
optVar = handles.log;
saveDir = optVar{1,2};
analysisVariables = load([saveDir filesep 'Analysis_StageOne_' handles.GeneralData.papaDir '.mat']);
sampleRate = handles.GeneralData.fs;
trialOpts = optVar{4,2};

trialTime = strfind(trialOpts,',T:');
trialLine = str2double(trialOpts(trialTime+3:end));
set(handles.mainAxe,'XTickLabelRotation',0);

% ------------ PeakDilation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of peak dilations


Peak = (max(analysisVariables.X_Perc_DataSelected'))';
[p_Peak,tablePeak,statsPeak] = anovan(Peak,[analysisVariables.COND analysisVariables.SUBJECTS],'display','off');

[hObject,handles] = plotMenuCheck(hObject,handles);
guidata(hObject,handles)
% Display of p-value of stimuli factor for peak dilation

if p_Peak (1,1) < analysisVariables.alphaReal
    figure;
    hold on
    multcompare(statsPeak);
    hold off
    display(tablePeak)
    msgbox('There is a significant difference between the peak dilations of the stimuli','Peak Dilation Test')
else
    msgbox('There is no difference in terms of peak dilation between stimuli','Peak Dilation Test')
end




% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --- Executes on mouse press over axes background.
function mainAxe_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to mainAxe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newColor = rand(1,3);


if isa(hObject,'matlab.graphics.primitive.Patch')
    % It's A PATCH!
    set(hObject,'FaceColor',newColor)
    %set(handles.mainAxe.Children(location).Color,newColor)
    
else
    % just a line
    set(hObject,'color',newColor)
end


% --------------------------------------------------------------------
function helpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to helpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function aboutMeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to aboutMeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isnumeric(handles.topDirPP)
    
    iconData = imread([handles.topDirPP filesep 'Functions' filesep 'GUI' filesep 'HelpGui' filesep 'eye.png']);
    
    
    Button=buttondlg('Created by Jamie Lubell 2017','About','Okay','Github',struct('Default','Okay','IconString','custom','IconData',iconData));
    
    switch Button
        
        case 'Github'
            url = 'https://github.com/Lubell/PupilPlot';
            web(url,'-browser')
    end
    
    
    
    
else
    disp('Missing directories.  Made by Jamie Lubell 2017 CC license')
end

% --------------------------------------------------------------------
function helpPageMenu_Callback(hObject, eventdata, handles)
% hObject    handle to helpPageMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isnumeric(handles.topDirPP)
    
    url = [handles.topDirPP filesep 'Functions' filesep 'GUI' filesep 'HelpGui'...
        filesep 'pupilplot documentation' filesep 'PupilPlot.html'];
    web(url)
    
else
    disp('Missing directories.  Made by Jamie Lubell 2017 CC license')
end
