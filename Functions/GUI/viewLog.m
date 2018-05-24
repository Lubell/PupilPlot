function varargout = viewLog(varargin)
% VIEWLOG MATLAB code for viewLog.fig
%      VIEWLOG, by itself, creates a new VIEWLOG or raises the existing
%      singleton*.
%
%      H = VIEWLOG returns the handle to a new VIEWLOG or the handle to
%      the existing singleton*.
%
%      VIEWLOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWLOG.M with the given input arguments.
%
%      VIEWLOG('Property','Value',...) creates a new VIEWLOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewLog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewLog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewLog

% Last Modified by GUIDE v2.5 25-Jul-2017 17:21:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewLog_OpeningFcn, ...
                   'gui_OutputFcn',  @viewLog_OutputFcn, ...
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


% --- Executes just before viewLog is made visible.
function viewLog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewLog (see VARARGIN)

% Choose default command line output for viewLog
handles.output = hObject;

checkOutTable = varargin{1};
trialLength = checkOutTable{4,2}*1000;
baselineLength = checkOutTable{4,3}*1000;

checkOutTable{4,2} = ['Trial Time: ' num2str(trialLength(1)) ':' num2str(trialLength(2)) ' ms'];
checkOutTable{4,3} = ['Baseline Time: ' num2str(baselineLength(1)) ':' num2str(baselineLength(2)) ' ms'];

handles.chkTable.Data = checkOutTable;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes viewLog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = viewLog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
