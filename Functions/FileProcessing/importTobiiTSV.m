function [Message,Lpupil,Rpupil] = importTobiiTSV(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [PUPILLEFT,PUPILRIGHT,EVENT,DESCRIPTOR] = IMPORTFILE(FILENAME) Reads
%   data from text file FILENAME for the default selection.
%
%   [PUPILLEFT,PUPILRIGHT,EVENT,DESCRIPTOR] = IMPORTFILE(FILENAME,
%   STARTROW, ENDROW) Reads data from rows STARTROW through ENDROW of text
%   file FILENAME.
%
% Example:
%   [PupilLeft,PupilRight,Event,Descriptor] = importfile('10.tsv',1, 10745);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/08/04 15:16:47

%% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%s%*s%*s%*s%*s%*s%*s%s%*s%*s%*s%*s%s%*s%*s%*s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [1,2]);
rawCellColumns = raw(:, [3,4]);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
Lpupil = cell2mat(rawNumericColumns(:, 1));
Rpupil = cell2mat(rawNumericColumns(:, 2));
Event = rawCellColumns(:, 1);
Descriptor = rawCellColumns(:, 2);



% find blanks

for i = 1:length(Lpupil)
    if isnan(Lpupil(i))
        % remove blanks
        Lpupil(i)=-1;
    end
    if isnan(Rpupil(i))
        % remove blanks
        Rpupil(i)=-1;
    end
    
    if strcmpi(Descriptor{i},'descriptor')
        beginLines = i;
    end
    
end


% remove leading Lines
Lpupil(1:beginLines)=[];
Rpupil(1:beginLines)=[];

Event(1:beginLines)=[];
Descriptor(1:beginLines)=[];



Message = cell(length(Descriptor),1);
for i = 1:length(Event)
    if ~strcmp(Event{i},'')
        Message{i}= [Event{i} ': ' Descriptor{i}];
    else
        Message{i}='';
    end
end




Lpupil = Lpupil';
Rpupil = Rpupil';

for j = 1:length(Message)
 % remove raw values from Message
    tempMess = Message{j};
    
    if strcmp(tempMess,'')
        Message{j} = 0;
    else
        valFound = strfind(tempMess,'alidation');
        calFound = strfind(tempMess,'alibration');
        if  ~isempty(valFound) || ~isempty(calFound) 
            Message{j} = 'Calibration';
        end
    end

end


