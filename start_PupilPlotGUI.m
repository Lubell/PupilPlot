function start_PupilPlotGUI(varargin)
% This is the main function for opening the gui
% Examples:
%   >>start_PupilPlotGUI
%    Simply starts the PupilPlotGUI
%   >>start_PupilPlotGUI('nogui')
%    Sets the paths for PupilPlot: functions can be used without the gui

cd(fileparts(which(mfilename)));
currentLocation = pwd;
pathSetLocation = [currentLocation filesep 'Functions' filesep 'FileProcessing'];
try
addpath(pathSetLocation)
catch
   warndlg('Couldn''t find all the folders needed, which means I can''t run','Fatal Error')
    return 
end
 % set the paths
successPath = setPupilPlotPaths(currentLocation);

if ~successPath
    warndlg('Couldn''t find all the folders needed, which means I can''t run','Fatal Error')
    return
end

if isempty(varargin)
   
    pupilPlotGUI
end