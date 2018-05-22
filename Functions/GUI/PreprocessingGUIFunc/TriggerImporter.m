function varargout = TriggerImporter(varargin)
% TRIGGERIMPORTER MATLAB code for TriggerImporter.fig
%      TRIGGERIMPORTER, by itself, creates a new TRIGGERIMPORTER or raises the existing
%      singleton*.
%
%      H = TRIGGERIMPORTER returns the handle to a new TRIGGERIMPORTER or the handle to
%      the existing singleton*.
%
%      TRIGGERIMPORTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRIGGERIMPORTER.M with the given input arguments.
%
%      TRIGGERIMPORTER('Property','Value',...) creates a new TRIGGERIMPORTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TriggerImporter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TriggerImporter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TriggerImporter

% Last Modified by GUIDE v2.5 08-Aug-2017 15:26:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TriggerImporter_OpeningFcn, ...
    'gui_OutputFcn',  @TriggerImporter_OutputFcn, ...
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


% --- Executes just before TriggerImporter is made visible.
function TriggerImporter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TriggerImporter (see VARARGIN)

% Choose default command line output for TriggerImporter
handles.output = hObject;
guidata(hObject, handles);
optVar = varargin{1,1};


workingD = optVar{1,2};
buildAnew = 0;
selection = varargin{1,2};




switch selection
    case 'Use trigger definitions and edit'
        load([workingD filesep 'trigger_definitions.mat'])
        for i = 1:length(ttStruct);
            if isequal(i,1)
                handles.con1.String = ttStruct(i).name;
            elseif isequal(i,2)
                handles.con2.String = ttStruct(i).name;
            elseif isequal(i,3)
                handles.con3.String = ttStruct(i).name;
            elseif isequal(i,4)
                handles.con4.String = ttStruct(i).name;
            elseif isequal(i,5)
                handles.con5.String = ttStruct(i).name;
            elseif isequal(i,6)
                handles.con6.String = ttStruct(i).name;
            elseif isequal(i,7)
                handles.con7.String = ttStruct(i).name;
            elseif isequal(i,8)
                handles.con8.String = ttStruct(i).name;
            end
            
            
        end
        
        
        handles.ExtraStuff.ttStruct = ttStruct;
        handles.uitable1.Data = dataFromTable;
        buildAnew = 1;
        
    case 'Use trigger definitions as is'
        load([workingD filesep 'trigger_definitions.mat'])
        
        save_ImportStats(optVar,ttStruct,dataFromTable,handles)
        warndlg('Already defined trigger definitions loaded')
        return
        
end


if ~buildAnew
    
    
    shortPT = optVar{5,2};
    %shortPT(1:15)=[];
    
    
    load([workingD filesep shortPT],'trig')
    indexRef = zeros(1,2);
    countAlong = 1;
    trigNames = cell(1,2);
    for i = 1:length(trig)
        if ~isequal(trig{i},0)
            trigNames{countAlong,1} = trig{i};
            trigNames{countAlong,2} = 'Ignore';
            indexRef(countAlong)=i;
            countAlong = countAlong+1;
        end
    end
    handles.indexRef = indexRef;
    handles.uitable1.Data = trigNames;
end

columnformat = {'char',{'Ignore' 'Trigger Event A' 'Trigger Event B' 'Trigger Event C' 'Trigger Event D' 'Trigger Event E'  'Trigger Event F'  'Trigger Event G'  'Trigger Event H'}};
handles.uitable1.ColumnFormat = columnformat;


currPath = path;
lookingForB = strfind(currPath,'/baselineTool/');

if not(isempty(lookingForB))
    optVar{7,3} = 1;
else
    optVar{7,3} = 0;
end

handles.ExtraStuff.optVar = optVar;
handles.ExtraStuff.built = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TriggerImporter wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TriggerImporter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isfield(handles,'output')
    varargout{1} = handles.output;
end

if isfield(handles,'abort')
    disp(handles.abort)
else
    disp('Trigger definition successful')
end
uiresume(handles.figure1);
delete(gcf)


% --- Executes on button press in doneWImport.
function doneWImport_Callback(hObject, eventdata, handles)
% hObject    handle to doneWImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
optVar = handles.ExtraStuff.optVar;

condiBuild = handles.ExtraStuff.built;
if condiBuild
    ttStruct = handles.ExtraStuff.ttStruct;
    dataTable = handles.uitable1.Data;
    save_ImportStats(optVar,ttStruct,dataTable,handles)
else
    warndlg('You need to build the conditions first')
end




% --- Executes on button press in cancleTrigImport.
function cancleTrigImport_Callback(hObject, eventdata, handles)
% hObject    handle to cancleTrigImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sureSure = questdlg('Are you sure you want to leave without saving?','Yes','No');
switch sureSure
    case 'Yes'
        uiresume(handles.figure1);
    otherwise
        return
end





function save_ImportStats(optVar,ttStruct,dataTable,handles)


workingD = optVar{1,2};


primD = dir([workingD filesep '*_IMP.mat']);
f = waitbar(0,'Updating Triggers Definitions');

for sub = 1:length(primD)
    waitbar(sub/length(primD),f,['Updating Triggers: ' primD(sub).name]);
    load([workingD filesep primD(sub).name])
    for i = 1:length(ttStruct)
        curCon = ttStruct(i).events;
        for j = 1:length(curCon)
            for k = 1:length(trig)
                if ~isequal(trig{k},0) && strcmp(curCon{j},trig{k})
                    trig{k} = ttStruct(i).name;
                end
            end
        end
        
    end
    
    if exist('C_pupil','var')
        save([workingD filesep primD(sub).name],'Lpupil','Rpupil','trig','C_pupil')
    else 
        save([workingD filesep primD(sub).name],'Lpupil','Rpupil','trig')
    end
    
end




occurrances=cell(length(ttStruct),2);



for loopy = 1:size(occurrances,1)
    occurrances{loopy,1} = ttStruct(loopy).name;
    occurrances{loopy,2} = length(ttStruct(loopy).events);
end


dataFromTable = dataTable;



% cleanup data from table?
save([workingD filesep 'trigger_definitions.mat'],'ttStruct','occurrances','dataFromTable')
close(f)
uiresume(handles.figure1)



% --- Executes on selection change in condi1.
function condi1_Callback(hObject, eventdata, handles)
% hObject    handle to condi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns condi1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from condi1


% --- Executes during object creation, after setting all properties.
function condi1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to condi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tdef = handles.uitable1.Data;

tcountACell = cell(1,1);tcountBCell = cell(1,1);tcountCCell = cell(1,1);tcountDCell = cell(1,1);
tcountECell = cell(1,1);tcountFCell = cell(1,1);tcountGCell = cell(1,1);tcountHCell = cell(1,1);
tcountA = 1;tcountB = 1;tcountC = 1;tcountD = 1;
tcountE = 1;tcountF = 1;tcountG = 1;tcountH = 1;

for i = 1:size(tdef,1)
    defOfT = tdef{i,2};
    if strcmp(defOfT,'Trigger Event A')
        tcountACell{tcountA,:}=tdef{i,1};
        tcountA = tcountA+1;
    elseif strcmp(defOfT,'Trigger Event B')
        tcountBCell{tcountB,:}=tdef{i,1};
        tcountB = tcountB+1;
    elseif strcmp(defOfT,'Trigger Event C')
        tcountCCell{tcountC,:}=tdef{i,1};
        tcountC = tcountC+1;
    elseif strcmp(defOfT,'Trigger Event D')
        tcountDCell{tcountD,:}=tdef{i,1};
        tcountD = tcountD+1;
    elseif strcmp(defOfT,'Trigger Event E')
        tcountECell{tcountE,:}=tdef{i,1};
        tcountE = tcountE+1;
    elseif strcmp(defOfT,'Trigger Event F')
        tcountFCell{tcountF,:}=tdef{i,1};
        tcountF = tcountF+1;
    elseif strcmp(defOfT,'Trigger Event G')
        tcountGCell{tcountG,:}=tdef{i,1};
        tcountG = tcountG+1;
    elseif strcmp(defOfT,'Trigger Event H')
        tcountHCell{tcountH,:}=tdef{i,1};
        tcountH = tcountH+1;
    end
end

if tcountA >=2
    handles.condi1.String = tcountACell;
    guidata(hObject, handles);
    defaultAnswer = {handles.con1.String};
    newAname = inputdlg('Please give the Trigger Events of type A a group name:','Group Name',1,defaultAnswer);
    handles.con1.String=newAname{1};
    
    ttStruct.events = tcountACell;
    ttStruct.name=newAname{1};
end

if tcountB >=2
    handles.listbox2.String = tcountBCell;
    guidata(hObject, handles);
    defaultAnswer = {handles.con2.String};
    newBname = inputdlg('Please give the Trigger Events of type A a group name:','Group Name',1,defaultAnswer);
    handles.con2.String=newBname{1};
    
    ttStruct(2).events = tcountBCell;
    ttStruct(2).name=newBname{1};
end

if tcountC >=2
    handles.listbox3.String = tcountCCell;
    guidata(hObject, handles);
    defaultAnswer = {handles.con3.String};
    newCname = inputdlg('Please give the Trigger Events of type A a group name:','Group Name',1,defaultAnswer);
    handles.con3.String=newCname{1};
    
    ttStruct(3).events = tcountCCell;
    ttStruct(3).name=newCname{1};
end

if tcountD >=2
    handles.listbox7.String = tcountDCell;
    guidata(hObject, handles);
    defaultAnswer = {handles.con4.String};
    newDname = inputdlg('Please give the Trigger Events of type A a group name:','Group Name',1,defaultAnswer);
    handles.con4.String=newDname{1};
    
    ttStruct(4).events = tcountDCell;
    ttStruct(4).name=newDname{1};
end

if tcountE >=2
    handles.listbox4.String = tcountECell;
    guidata(hObject, handles);
    defaultAnswer = {handles.con5.String};
    newEname = inputdlg('Please give the Trigger Events of type A a group name:','Group Name',1,defaultAnswer);
    handles.con5.String=newEname{1};
    
    ttStruct(5).events = tcountECell;
    ttStruct(5).name=newEname{1};
end

if tcountF >=2
    handles.listbox5.String = tcountFCell;
    guidata(hObject, handles);
    defaultAnswer = {handles.con6.String};
    newFname = inputdlg('Please give the Trigger Events of type A a group name:','Group Name',1,defaultAnswer);
    handles.con6.String=newFname{1};
    ttStruct(6).events = tcountFCell;
    ttStruct(6).name=newFname{1};
end

if tcountG >=2
    handles.listbox6.String = tcountGCell;
    guidata(hObject, handles);
    defaultAnswer = {handles.con7.String};
    newGname = inputdlg('Please give the Trigger Events of type A a group name:','Group Name',1,defaultAnswer);
    handles.con7.String=newGname{1};
    ttStruct(7).events = tcountGCell;
    ttStruct(7).name=newGname{1};
end
if tcountH >=2
    handles.listbox8.String = tcountHCell;
    guidata(hObject, handles);
    defaultAnswer = {handles.con8.String};
    newHname = inputdlg('Please give the Trigger Events of type A a group name:','Group Name',1,defaultAnswer);
    handles.con8.String=newHname{1};
    ttStruct(8).events = tcountHCell;
    ttStruct(8).name=newHname{1};
end

handles.ExtraStuff.built = 1;
handles.ExtraStuff.ttStruct = ttStruct;
guidata(hObject, handles);





% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox6.
function listbox6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox6


% --- Executes during object creation, after setting all properties.
function listbox6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox7.
function listbox7_Callback(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox7


% --- Executes during object creation, after setting all properties.
function listbox7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox8.
function listbox8_Callback(hObject, eventdata, handles)
% hObject    handle to listbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox8


% --- Executes during object creation, after setting all properties.
function listbox8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in blineTool.
function blineTool_Callback(hObject, eventdata, handles)
% hObject    handle to blineTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

optVar = handles.ExtraStuff.optVar;

if isequal(optVar{7,3},0)
   okayWith=questdlg('If you have downloaded the baselineTool package press okay and in the next step you''ll be asked to add it to the path.  If not press no or cancel.','No baseline Tool');
   
   switch okayWith
       case 'Yes'
            FolderName = uigetdir;
            addpath(genpath(FolderName))
            miniProc(optVar);
       otherwise
   end
else
    miniProc(optVar);
   
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection = questdlg('Close Wihout Saving?','Warning', ...
    'Yes','No','Yes');
switch selection
    case 'Yes'
        % delete(hObject);
        handles.abort = 'Trigger definition aborted';
        guidata(hObject, handles);
        uiresume(handles.figure1);
    case 'No'
        return
end
