function varargout = fstimInvest(varargin)
% FSTIMINVEST MATLAB code for fstimInvest.fig
%      FSTIMINVEST, by itself, creates a new FSTIMINVEST or raises the existing
%      singleton*.
%
%      H = FSTIMINVEST returns the handle to a new FSTIMINVEST or the handle to
%      the existing singleton*.
%
%      FSTIMINVEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FSTIMINVEST.M with the given input arguments.
%
%      FSTIMINVEST('Property','Value',...) creates a new FSTIMINVEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fstimInvest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fstimInvest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fstimInvest

% Last Modified by GUIDE v2.5 23-Mar-2017 09:05:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fstimInvest_OpeningFcn, ...
                   'gui_OutputFcn',  @fstimInvest_OutputFcn, ...
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


% --- Executes just before fstimInvest is made visible.
function fstimInvest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fstimInvest (see VARARGIN)

% Choose default command line output for fstimInvest
handles.output = hObject;
if isfield(handles,'twiceT')
    top_var = handles.twiceT;
else

    top_var=varargin{1,1};
end

fstim_var= top_var{1,1};
F_Sign = top_var{1,2};
xData = top_var{1,3};
firstPlot = top_var{1,4};

handles.meData = xData;



if isequal(firstPlot,0);

handles.output.UserData = .5;
bMessage = sprintf('Enter the sample number\nthat marks the beginning\nof the significant period:');
eMessage = sprintf('Enter the sample number\nthat marks the end of\nthe significant period:');
handles.text3.String=bMessage;
handles.text4.String=eMessage;


plot(handles.fStim,fstim_var(1,:));
hold on;

h = findobj(handles.fStim,'Type','line');
set(h(1),'Color','k','LineWidth',2);

plot(handles.fStim,F_Sign(1,:));
h1 = findobj(handles.fStim,'Type','line');
set(h1(1),'Color','r','LineWidth',2);
legend('F',['sign. ' num2str(top_var{1,7})]);
%set(gca,'XTick',0:12:139);
%set(gca,'XTickLabel',0:200:2317);
handles.fStim.XLabel.String ='Samples';
handles.fStim.YLabel.String ='p-value';
set(handles.fStim,'Box','off', 'FontSize',10);
% 'Extant',[0 0 0.223 0.05],
%title('F of stimuli factor over time','FontSize',14);

handles.twiceT = top_var;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fstimInvest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fstimInvest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in doneView.
function doneView_Callback(hObject, eventdata, handles)
% hObject    handle to doneView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if isequal(handles.twiceT{1,4},0)
    
    bsamp = handles.bSamp.String;
    esamp = handles.eSamp.String;
    
    
    cla(handles.fStim)
    legend(handles.fStim,'off')
    set(handles.fStim,'xlimMode', 'auto')
    set(handles.fStim,'ylimMode', 'auto')
    
    
    beg_signperiod_time = str2double(bsamp);
    
    
    end_signperiod_time = str2double(esamp);
    beg_signperiod_sample = beg_signperiod_time;
    beg_signperiod_sample = round (beg_signperiod_sample);
    
    end_signperiod_sample = end_signperiod_time;
    end_signperiod_sample = round (end_signperiod_sample);
    
    X_Perc_DataSelected = handles.meData;
    handles.pca.bTime = beg_signperiod_time;
    handles.pca.eTime = end_signperiod_time;
    warning('off')
    [COEFF,SCORE,latent,~] = princomp(X_Perc_DataSelected(:,beg_signperiod_sample:end_signperiod_sample));
    SamplesSign = end_signperiod_sample-beg_signperiod_sample;
    warning('on')
    CumVar=cumsum(latent)./sum(latent)*100; %Accounted variance extraction
    Var (1,1) = CumVar(1,1);
    for i = 2:SamplesSign
        Var (i,1) = CumVar(i,1) - CumVar(i-1,1);
    end
    
    nb_variables = SamplesSign; % Factor loadings calculation
    for Variable = 1 : nb_variables
        for time = 1 : SamplesSign
            Factor_Loadings (Variable,time) = (COEFF(time,Variable)*sqrt(latent(Variable,1)));
        end
    end
    
    % eigenvalues plot
    plot (handles.fStim,latent(1:5,1));
    hold on
    set(handles.fStim,'XTick',0:1:5);
    set(handles.fStim,'XTickLabel',0:1:5);
    handles.fStim.XLabel.String ='Component number';
    handles.fStim.YLabel.String ='Eigenvalue';
    
    set(handles.fStim,'Box','off', 'FontSize',10);
    %title('Eigenvalues plot','FontSize',14);
    eMessage = sprintf('\nHow many components do\nyou want to retain?');
    
    handles.text3.Visible = 'off';
    handles.bSamp.Visible = 'off';
    handles.eSamp.String = '';
    handles.text4.String=eMessage;
    handles.twiceT{1,4} = 1;
    handles.pca.Score = SCORE;
    handles.pca.Factor_Loadings = Factor_Loadings;
    handles.pca.sampSign = SamplesSign;
    hold off
    guidata(hObject, handles);
else
    SCORE=handles.pca.Score;
    Factor_Loadings = handles.pca.Factor_Loadings;
    beg_signperiod_time =handles.pca.bTime;
    end_signperiod_time =handles.pca.eTime;
    observations = size (handles.meData,1);
    SamplesSign = handles.pca.sampSign;
    COND = handles.twiceT{1,5};
    SUBJECTS= handles.twiceT{1,6};
    nb_Components_Selected = str2double(handles.eSamp.String);
    
    ComponentSelected_Scores = zeros (observations,nb_Components_Selected);
    for Component = 1 :nb_Components_Selected % Extraction of scores of meaningful components
        for obs = 1 : observations
            ComponentSelected_Scores (obs,Component) = SCORE (obs,Component);
        end
    end
    
    for Component = 1 : nb_Components_Selected % Extraction of meaningful components factor loadings
        for time = 1 : SamplesSign-1
            ComponentsSelected_Loadings (Component,time) = Factor_Loadings (Component ,time);
        end
    end
    
    for Component = 1 : nb_Components_Selected
        p_PCA(Component,1:2) = anovan (ComponentSelected_Scores (:,Component),[COND SUBJECTS],'display','off');
    end
    
    
    
    
    PCA_time.p = p_PCA;
    PCA_time.nb = nb_Components_Selected;
    PCA_time.CSL = ComponentsSelected_Loadings;
    PCA_time.sampSign = SamplesSign;
    PCA_time.beg = beg_signperiod_time;
    PCA_time.end = end_signperiod_time;
    
    
    %
    % putout=cell(2,1);
    % putout{1}=bsamp;
    % putout{2}=esamp;
    
    handles.output.UserData = PCA_time;
    guidata(hObject, handles);
    fstimInvest_OutputFcn(hObject, eventdata, handles);
end




function bSamp_Callback(hObject, eventdata, handles)
% hObject    handle to bSamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bSamp as text
%        str2double(get(hObject,'String')) returns contents of bSamp as a double


% --- Executes during object creation, after setting all properties.
function bSamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bSamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eSamp_Callback(hObject, eventdata, handles)
% hObject    handle to eSamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eSamp as text
%        str2double(get(hObject,'String')) returns contents of eSamp as a double


% --- Executes during object creation, after setting all properties.
function eSamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eSamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
