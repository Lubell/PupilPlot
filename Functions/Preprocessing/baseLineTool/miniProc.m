function [EYE] = miniProc(varargin)

if isempty(varargin)
    
    
    epochFirst = questdlg(['Please make sure that you''ve preprocessed your data first ',...
        'if you are going to use this tool for anything beside just ',...
        'viewing the data.',...
        ' Plot all patients or just one?'],'BaseLine Q','All','One','All');
    
    
    srate = inputdlg('What is the sampling rate of the date?','SRATE');
    srate = srate{1};
    srate= str2double(srate);
    switch epochFirst
        case 'All'
            PathName = uigetdir('Select the SMI file');
            FileName = 0;
        otherwise
            [FileName,PathName] = uigetfile('*IMP*','Select the SMI file');
    end
    
    
    
    [EYE,~,~,~,~] = setupEYE(PathName,FileName,srate);
    
    
    pop_Eyeplot(EYE,1,1,1)
    % uiwait
    restDate = EYE.data;
    
    restDate(:,EYE.falseSamp) = 0; % put the zeros back in that are used to note when timestamps occur
    EYE.data = restDate;
    checkingAtype = 0;
    % add rejected points to EYE struct
    if exist('TMPREJ','var') && not(isempty(TMPREJ))
        EYE.tmpRej = TMPREJ;
        clear restDate srate ans TMPREJ
        % periods were chosen perhaps by mistake, or perhaps on purpose
        % first ask if for real and recommend against it
        realBLmodify = questdlg(['I''ve noted that you selected some samples and want to make sure you want to continue and replace these values',...
            ' with values from another trial']);
        checkingAtype = [epochFirst '.' realBLmodify];
    elseif not(exist('TMPREJ','var'))
        clear restDate srate ans
    else
        clear restDate srate ans TMPREJ
    end
    
    EYE.checkingAtype = checkingAtype;
    
    
else
    optVar = varargin{1};
    srate = optVar{7,2};
    if isequal(srate,0)
        srate = inputdlg('What is the sampling rate of the date?','SRATE');
        srate = srate{1};
        srate= str2double(srate);
    end
    
    PathName = [optVar{1,2} filesep];
    FileName = optVar{7,1};
    
    
    [EYE,~,~,~,~] = setupEYE(PathName,FileName,srate);


    pop_Eyeplot(EYE,1,1,0)

end

