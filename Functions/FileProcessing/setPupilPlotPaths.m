function [pathsSet] = setPupilPlotPaths(topDirLoc)
% this function sets the path for pupilplot
% the input variable should be the topDirLoc is the folder 'PupilPlot' 
% which contains the start_PupilPlot function and the folder 'Functions'

p = genpath(topDirLoc);

folders = {'Functions','Analysis','FileProcessing','GUI','Plotting','Preprocessing'};

successFolders = 0;

for i = 1:numel(folders)
    foundStr = strfind(p,folders{i});
    if ~isempty(foundStr)
        successFolders = successFolders +1;
    end
    
    
end

if ~isequal(successFolders,i)
    pathsSet = 0;
else
    addpath(p)
    pathsSet = 1;
end