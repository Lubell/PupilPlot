function [hObject,handles] = plotMenuCheck(hObject,handles)
% function for moving the checkmark around
% pass in the handles and current object.



% find if any plots are checked and uncheck them

for i = 1:12 % number of current plots
    switch i
        case 1
            if strcmpi(handles.plot1Menu.Checked,'on')
                handles.plot1Menu.Checked = 'off';
            end
        case 2
            if strcmpi(handles.plot2Menu.Checked,'on')
                handles.plot2Menu.Checked = 'off';
            end
        case 3
            if strcmpi(handles.plot3Menu.Checked,'on')
                handles.plot3Menu.Checked = 'off';
            end
        case 4
            if strcmpi(handles.plot4Menu.Checked,'on')
                handles.plot4Menu.Checked = 'off';
            end
        case 5
            if strcmpi(handles.plot5Menu.Checked,'on')
                handles.plot5Menu.Checked = 'off';
            end
        case 6
            if strcmpi(handles.plot6Menu.Checked,'on')
                handles.plot6Menu.Checked = 'off';
            end
        case 7
            if strcmpi(handles.plot7Menu.Checked,'on')
                handles.plot7Menu.Checked = 'off';
            end
        case 8
            if strcmpi(handles.plot8Menu.Checked,'on')
                handles.plot8Menu.Checked = 'off';
            end
        case 9
            if strcmpi(handles.plot9Menu.Checked,'on')
                handles.plot9Menu.Checked = 'off';
            end
        case 10
            if strcmpi(handles.plot10Menu.Checked,'on')
                handles.plot10Menu.Checked = 'off';
            end
        case 11
            if strcmpi(handles.plot11Menu.Checked,'on')
                handles.plot11Menu.Checked = 'off';
            end
        case 12
            if strcmpi(handles.plot12Menu.Checked,'on')
                handles.plot12Menu.Checked = 'off';
            end
    end
end
if isnumeric(hObject)
    hObject = 1;
else
    hObject.Checked = 'on';
end

