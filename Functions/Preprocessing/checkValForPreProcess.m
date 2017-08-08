function [handlesOut] = checkValForPreProcess(handles)
% hObject    handle to checkVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkVal


checkOutTable = handles.log;

checkValues = checkOutTable(:,1);


for i = 1:length(checkValues)
    
    switch i
        case 1
            disp(['Folder with Files: ' checkOutTable{i,2}])
        case 2
            % check sampling rate
            
            if isequal(1,checkValues{i})
                if isequal(0,checkOutTable{i,3})
                    warndlg('Sampling rate cannot be 0','Sample 0')
                    handles.GeneralData.preProcOkay = 0;
                    handlesOut = handles;
                    return
                else
                    disp(['Sampling Rate: ' checkOutTable{i,3}])
                end
                
            else
                warndlg('Please set the sampling rate','Set Sample Rate')
            end
            
        case 3
            if isequal(1,checkValues{i})
                if isequal(0,checkOutTable{i,3})
                    disp('No cleaning requested')
                else
                    disp(['Cleaning parameter: ' num2str(checkOutTable{i,3})])
                end
            else
                disp('No cleaning requested')
            end
            
        case 4
            if isequal(0,checkValues{i})
                disp('Please set baseline options')
                handles.GeneralData.preProcOkay = 0;
                handlesOut = handles;
                return
            end
        case 6 % trigger
            
            triggerTable = handles.triggerInfo;
            trigBlank = strcmp(triggerTable,'');
            
            triggerTable(trigBlank(:,1),:) = [];
            handles.GeneralData.triggerNames = triggerTable;
            
            if isequal(checkValues{i},1)
                tName = handles.GeneralData.triggerNames;
                
                if isequal(tName,triggerTable)
                    grabTNames = 1;
                    disp('Using Selected Trigggers')
                else
                    disp('!!Change or addition to triggers has been noted and added!!')
                    grabTNames = 1;
                end
            else
                genData = handles.GeneralData;
                if ~isfield(genData,'triggerNames')
                    disp('Please run the Trigger importer')
                    handles.GeneralData.preProcOkay = 0;
                    handlesOut = handles;
                    return
                end
                
                tName = handles.GeneralData.triggerNames;
                % find total trial number
                countTrial = 0;
                for trialC = 1:size(tName,1)
                    countTrial = countTrial+tName{trialC,2};
                end
                checkOutTable{6,1} = 1;
                checkOutTable{6,3} = ['Trial Num: ' num2str(countTrial)];
                handles.checkOutTable.Data = checkOutTable;
                grabTNames = 1;
            end
            if grabTNames && ~isempty(triggerTable)
                checkOutTable{6,2} = [triggerTable{1} ' etc...'];
                handles.checkOutTable.Data = checkOutTable;
                handles.GeneralData.triggerNames = triggerTable;
            else
                disp('Please import triggers first')
                handles.GeneralData.preProcOkay = 0;
                handlesOut = handles;
                return
            end
    end
end


handles.GeneralData.preProcOkay = 1;
handlesOut = handles;
