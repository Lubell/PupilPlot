function varargout = preprocGUI(varargin)
% PREPROCGUI MATLAB code for preprocGUI.fig
%      PREPROCGUI, by itself, creates a new PREPROCGUI or raises the existing
%      singleton*.
%
%      H = PREPROCGUI returns the handle to a new PREPROCGUI or the handle to
%      the existing singleton*.
%
%      PREPROCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPROCGUI.M with the given input arguments.
%
%      PREPROCGUI('Property','Value',...) creates a new PREPROCGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before preprocGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to preprocGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help preprocGUI

% Last Modified by GUIDE v2.5 23-May-2018 09:20:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @preprocGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @preprocGUI_OutputFcn, ...
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


% --- Executes just before preprocGUI is made visible.
function preprocGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to preprocGUI (see VARARGIN)

% Choose default command line output for preprocGUI
handles.output = hObject;


if isempty(varargin{1})
    return
end
checkOutTable = varargin{1};


if isequal(checkOutTable{4,1},1)
    
    % update ride along variables
    handles.cleanValues = {checkOutTable{3,1},checkOutTable{3,2},checkOutTable{3,3}};
    
    trialOpts = checkOutTable{4,2}*1000;
    baseLineOpts = checkOutTable{4,3}*1000;
    
    handles.baseLineTimes = {checkOutTable{4,1} trialOpts baseLineOpts};
        
    handles.fsValues = {checkOutTable{2,1},checkOutTable{2,2},checkOutTable{2,3}};
    
    % populate the windows with preExisting info
    handles.cleanSmthParam.String = num2str(checkOutTable{3,3});
    
     deBUGG = strfind(checkOutTable{3,2},'off');
    if isempty(deBUGG)
        display=1; % debug info (0 = off)
    else
        display=0;
    end
    
    
    handles.cleanDebug.Value =display;
    
    
    handles.epochSize.String  = num2str(trialOpts(1));
    handles.epochEnd.String =  num2str(trialOpts(2));
    handles.baseLineStart.String = num2str(baseLineOpts(1));
    handles.baseLineEND.String = num2str(baseLineOpts(2));
    trialLength = numel((trialOpts(1)):(trialOpts(2)))-1;
    handles.totalTrial.String = num2str(trialLength);
    
    handles.setSample.String= num2str(checkOutTable{2,3});
else
    % set the basic values
    handles.cleanValues = {1,'debug off',4};
    handles.baseLineTimes = {1,[0 0],[0 0],0};
    handles.fsValues = {0,0,0};
end


handles.log = checkOutTable;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes preprocGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = preprocGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.log;
varargout{2} = handles.closeType;
delete(hObject)


function cleanSmthParam_Callback(hObject, eventdata, handles)
% hObject    handle to cleanSmthParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cleanSmthParam as text
%        str2double(get(hObject,'String')) returns contents of cleanSmthParam as a double

cleanParam = str2double(get(hObject,'String'));

if ~isempty(cleanParam) && ~isequal(cleanParam,0)
    handles.cleanValues{1} = 1;
    handles.cleanValues{3} = cleanParam;
else
    handles.cleanValues{1} = 0;
    handles.cleanValues{2} = 'no clean';
    handles.cleanValues{3} = 'x';
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function cleanSmthParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cleanSmthParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cleanDebug.
function cleanDebug_Callback(hObject, eventdata, handles)
% hObject    handle to cleanDebug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cleanDebug
onORoff = get(hObject,'Value');

if onORoff
   handles.cleanValues{2} = 'debug on'; 
else
    handles.cleanValues{2} = 'debug off'; 
end

guidata(hObject,handles)



function epochSize_Callback(hObject, eventdata, handles)
% hObject    handle to epochSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epochSize as text
%        str2double(get(hObject,'String')) returns contents of epochSize as a double

answer = str2double(get(hObject,'String'));

if ~isempty(answer)
    handles.baseLineTimes{1,2}(1,1) = answer;
    guidata(hObject, handles);
    % grab the epochEnd value if it is 
    epochEndVal = str2double(handles.epochEnd.String);
    if ~isempty(epochEndVal) || ~isequal(epochEndVal,0)
        handles.totalTrial.String = numel(str2double(handles.epochSize.String):str2double(handles.epochEnd.String))-1;
    end
    
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function epochSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function epochEnd_Callback(hObject, eventdata, handles)
% hObject    handle to epochEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epochEnd as text
%        str2double(get(hObject,'String')) returns contents of epochEnd as a double
answer = str2double(get(hObject,'String'));

if ~isempty(answer)
    handles.baseLineTimes{1,2}(1,2) = answer;
    guidata(hObject, handles);
    % grab the epochEnd value if it is 
    epochStartVal = str2double(handles.epochSize.String);
    if ~isempty(epochStartVal)
        handles.totalTrial.String = numel(str2double(handles.epochSize.String):str2double(handles.epochEnd.String))-1;
    end
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function epochEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function baseLineStart_Callback(hObject, eventdata, handles)
% hObject    handle to baseLineStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baseLineStart as text
%        str2double(get(hObject,'String')) returns contents of baseLineStart as a double

answer = str2double(get(hObject,'String'));

if ~isempty(answer)
    handles.baseLineTimes{1,3}(1,1) = answer;
end
 guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function baseLineStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baseLineStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function baseLineEnd_Callback(hObject, eventdata, handles)
% hObject    handle to baseLineEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baseLineEnd as text
%        str2double(get(hObject,'String')) returns contents of baseLineEnd as a double
answer = str2double(get(hObject,'String'));

if ~isempty(answer)
    handles.baseLineTimes{1,3}(1,2) = answer;
end
 guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function baseLineEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baseLineEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function totalTrial_Callback(hObject, eventdata, handles)
% hObject    handle to totalTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function totalTrial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to totalTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function setSample_Callback(hObject, eventdata, handles)
% hObject    handle to setSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setSample as text
%        str2double(get(hObject,'String')) returns contents of setSample as a double


answer = str2double(get(hObject,'String'));

if ~isempty(answer)
    handles.fsValues = {1,'Sampling Rate',answer};
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function setSample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in doneOptSet.
function doneOptSet_Callback(hObject, eventdata, handles)
% hObject    handle to doneOptSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% convert to seconds for consitancy

checkOutTable = handles.log;
fs = handles.fsValues;



% grab the cleaning values
cleanParam = handles.cleanValues;


checkOutTable{3,1} = cleanParam{1};
checkOutTable{3,2} = cleanParam{2};
checkOutTable{3,3} = cleanParam{3};

% grab the baseline values
blT = handles.baseLineTimes;


trialTStart = blT{1,2}(1,1)/1000;
trialTEnd = blT{1,2}(1,2)/1000;

baseLineTStart = blT{1,3}(1,1)/1000;
baseLineTEnd = blT{1,3}(1,2)/1000;



checkOutTable{4,1} = blT{1};
checkOutTable{4,2} = [trialTStart trialTEnd];
checkOutTable{4,3} = [baseLineTStart baseLineTEnd];

% sample rate set
checkOutTable{2,1} = fs{1};
checkOutTable{2,2} = fs{2};
checkOutTable{2,3} = fs{3};




handles.log = checkOutTable;
handles.closeType = 1;
guidata(hObject,handles)
uiresume(handles.figure1)



% --- Executes on button press in clearOptBoxes.
function clearOptBoxes_Callback(hObject, eventdata, handles)
% hObject    handle to clearOptBoxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.cleanSmthParam.String = '4';

handles.epochSize.String  = '0';
handles.epochEnd.String = '0';
handles.baseLineStart.String = '0';
handles.baseLineEND.String = '0';

handles.setSample.String= '';
handles.cleanDebug.Value = 0;

% set the basic values back to zero
handles.cleanValues = {1,'debug off',4};
handles.baseLineTimes = {1,{0,0},{0,0},0};
handles.fs = {0,0,0};



guidata(hObject,handles)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Construct a questdlg with three options
choice = questdlg('Close without saving?', ...
    'Close Request', ...
    'Exit-no save','Exit-save','Cancel','Cancel');
% Handle response
switch choice
    case 'Exit-no save'
        handles.closeType = 0;
        guidata(hObject,handles)
        uiresume(handles.figure1)
    case 'Exit-save'
        checkOutTable = handles.log;
        fs = handles.fsValues;
        
        % grab the cleaning values
        cleanParam = handles.cleanValues;
        
        
        checkOutTable{3,1} = cleanParam{1};
        checkOutTable{3,2} = cleanParam{2};
        checkOutTable{3,3} = cleanParam{3};
        
        % grab the baseline values
        blT = handles.baseLineTimes;
        
        
        trialTStart = blT{1,2}(1,1)/1000;
        trialTEnd = blT{1,2}(1,2)/1000;
        
        baseLineTStart = blT{1,3}(1,1)/1000;
        baseLineTEnd = blT{1,3}(1,2)/1000;
        
        
        
        checkOutTable{4,1} = blT{1};
       checkOutTable{4,2} = [trialTStart trialTEnd];
       checkOutTable{4,3} = [baseLineTStart baseLineTEnd];
        
        
        % sample rate set
        checkOutTable{2,1} = fs{1};
        checkOutTable{2,2} = fs{2};
        checkOutTable{2,3} = fs{3};
        
        
        
        handles.log = checkOutTable;
        handles.closeType = 1;
        guidata(hObject,handles)
        uiresume(handles.figure1)
    case 'Cancel'
        return
end




% --- Executes on button press in helpButton.
function helpButton_Callback(hObject, eventdata, handles)
% hObject    handle to helpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
