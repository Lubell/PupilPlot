function [Message,Lpupil,Rpupil,lPi,rPi,mID,mEV] = importTobiiCSV(filename,lPi,rPi,mID,mEV,startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   This function requires the data to be in a specific format in order for
%   it to work.  Firstly it must be a csv (comma seperated vector) of data.
%   This can be done using excel or Tobii's own export function.  The first
%   row of the csv file needs to be the variable names for the data there
%   within.  Timestamp and Pupil are reserved words for this program,
% Example:
%
%    See also TEXTSCAN.


%% Initialize variables.
% Use the variable Caterina to find startRow

[~,~,fExt] = fileparts(filename);

if ~strcmp(fExt,'.csv')
    Message = 0;
    Lpupil= 0;
    Rpupil= 0;
    lPi= 0;
    rPi = 0;
    warndlg('File must be a .csv file','Error')
    return
end

delimiter = ',';
if nargin<=5
    startRow = 1;
    endRow = inf;
end

%% Format for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: text (%s)
%   column11: text (%s)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
% For more information, see the TEXTSCAN documentation.
% formatSpec = '%f%f%f%f%f%f%f%f%f%s%s%f%f%f%[^\n\r]';
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
try
    dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
catch
    formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
    dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', true, 'EndOfLine', '\r\n');
end
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
dataArray([1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14]) = cellfun(@(x) num2cell(x), dataArray([1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14]), 'UniformOutput', false);
dataArray([10, 11]) = cellfun(@(x) mat2cell(x, ones(length(x), 1)), dataArray([10, 11]), 'UniformOutput', false);
dataArray = [dataArray{1:end-1}];

pupildata = importfile(filename,1,1);

% Event Value
% Event


if isempty(lPi) && isempty(rPi)
    
    % Use the variable Caterina to find the 
    
    for colT = 1:length(pupildata)
        colName = pupildata(colT);
        
        if strcmpi(colName,'Pupil diameter left')
            lPi = colT;
        elseif strcmpi(colName,'Pupil diameter right')
            rPi = colT;
        end
    end
    
    if isempty(lPi) || isempty(rPi)
%         prompt = {'Enter Column # for Left Pupil:','Enter Column # for Right Pupil:'};
%         dlg_title = 'Input Pupil Columns';
%         num_lines = 1;
%         def = {'1','2'};
%         answer = inputdlg(prompt,dlg_title,num_lines,def);
        
        [s,v] = listdlg('PromptString','Select Left and Right Pupil Variables: ','SelectionMode','mulitple',...
            'ListString',pupildata,'ListSize',[250 300]);
        
        if ~isequal(v,1) || numel(s)~=2
            Message = 0;
            Lpupil= 0;
            Rpupil= 0;
            lPi= 0;
            rPi = 0;
            return
        end
        
        
        
        if ~contains(pupildata(s(1)),'ight')
            
            
            lPi = s(1);
            rPi = s(2);
            
        else
            lPi = s(2);
            rPi = s(1);
        end
            
    end
    
    
end


if isempty(mID) && isempty(mEV)
    [s,v] = listdlg('PromptString','Select Event Variables (max 2 variables): ','SelectionMode','mulitple',...
        'ListString',pupildata,'ListSize',[250 300]);
    
    if ~isequal(v,1) || numel(s)>2
        Message = 0;
        Lpupil= 0;
        Rpupil= 0;
        lPi= 0;
        rPi = 0;
        return
    elseif isequal(numel(s),1)
        mID = s(1);
        mEV = [];
    else
        
        mID = s(1);
        mEV = s(2);
    end
    
    
    
end


% loose the first line
Lpupil = dataArray(:, lPi);
Rpupil = dataArray(:, rPi);

Lpupil(1) = [];
Rpupil(1) = [];


if isempty(mEV)
    Message_ID = dataArray(:,mID);
    Message_Event = dataArray(:,mID);
else
    Message_ID = dataArray(:,mID);
    Message_Event = dataArray(:,mEV);
end

% drop first line
Message_Event(1) = [];
Message_ID(1) = [];

correctLineUp =0;
for i = 1:length(Message_Event)
   if contains(Message_Event{i},'Start','IgnoreCase',true)
       correctLineUp =1;
       break
   end
end

if correctLineUp && ~isempty(mEV)
    tvar = Message_Event;
    Message_Event = Message_ID;
    Message_ID = tvar;
    clear tvar
end

% convert into matrixes
clipR = zeros(1,length(Rpupil));
clipL = zeros(1,length(Lpupil));

for j = 1:length(clipR)
    clipR(j) = str2double(Rpupil(j));
    clipL(j) = str2double(Lpupil(j));
end


baseBlank_R = isnan(clipR);
baseBlank_L = isnan(clipL);

% zero out blanks
clipL(baseBlank_L)=0;
clipR(baseBlank_R)=0;


tempMessEv = zeros(1,length(Message_Event));
tempMessId = zeros(1,length(Message_ID));

for j = 1:length(Message_Event)
    tempMessEv(j) = str2double(Message_Event(j));
    tempMessId(j) = str2double(Message_ID(j));
end

baseBlank_R = isnan(tempMessEv);
baseBlank_L = isnan(tempMessId);

% zero out blanks
Message_Event(~baseBlank_L)="0";
Message_ID(~baseBlank_R)="0";

Message = cell(length(Message_Event),1);
Message_Index = ones(length(Message_Event),1);

for j = 1:length(Message_Event)
    % remove raw values from Message
    
    
    if strcmp(Message_ID{j},'') || ~isnan(str2double(Message_ID(j)))
        Message{j} = 0;
    else
        if ~isempty(mEV)
            Message{j} = Message_ID{j};
            Message_Index(j) = 0;
        else
            Message{j} = strcat(Message_ID{j},'_',Message_Event{j});
            Message_Index(j) = 0;
        end
    end
    
end



Lpupil = clipL(logical(Message_Index));
Rpupil = clipR(logical(Message_Index));


function pupildata = importfile(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2018/07/12 15:38:58

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 1;
    endRow = 1;
end

%% Format for each line of text:
%   column1: text (%s)
%	column2: text (%s)
%   column3: text (%s)
%	column4: text (%s)
%   column5: text (%s)
%	column6: text (%s)
%   column7: text (%s)
%	column8: text (%s)
%   column9: text (%s)
%	column10: text (%s)
%   column11: text (%s)
%	column12: text (%s)
%   column13: text (%s)
%	column14: text (%s)
% For more information, see the TEXTSCAN documentation.
%formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
pupildata = [dataArray{1:end-1}];