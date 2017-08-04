function [handlesOut] = importSMIRun(handles)
% handles    structure with handles and user data (see GUIDATA)
% organizes files
importCheckStruct = handles.GeneralData;

if isfield(importCheckStruct,'importFolder')
    
    fprintf(1, 'Begin Import Functions.\n');
    % Hint: get(hObject,'Value') returns toggle state of importSMIRun
    renameTHEfiles = 0;
    
    renameOption = handles.GeneralData.usePriorDir;
    
    
    checkOutTable = handles.log;
    importFolder = handles.GeneralData.importFolder;
    
    if isequal(renameOption,0)
        % no new name and import required
        files2import= handles.GeneralData.importTxt;
        workingDirectory = uigetdir(importFolder,'Select Directory to Import into');
        for i = 1:length(files2import)
            disp(['Importing file: ' files2import{i}])
            [~,~,ext] = fileparts([importFolder filesep files2import{i}]);
            if strcmpi(ext,'.tsv')
                [trig,Lpupil,Rpupil] = importTobiiTSV([importFolder filesep files2import{i}]);
            else
                [trig,Lpupil,Rpupil] = importSMITXT([importFolder filesep files2import{i}]);
                
            end
            oldName = files2import{i};
            oldName = oldName(1:end-4);
            save([workingDirectory filesep oldName '_IMP.mat'],'Lpupil','Rpupil','trig')
        end
        
        
        checkOutTable{1,1} = 1;
        checkOutTable{1,2} = workingDirectory;
    
    else
        % no new name and just setting dir
        
        
        checkOutTable{1,1} = 1;
        checkOutTable{1,2} = importFolder;
    end
    graphName = sprintf('Files Loaded');
    handles.graphName.String = graphName;
    
    handles.log = checkOutTable;
    % Update handles structure
    fprintf(1, 'Finished with Import Functions.\n');
    handlesOut = handles;
else
    warndlg('First Select A Folder to Import using "File>Load>Folder" Panel')
    return
    
end
