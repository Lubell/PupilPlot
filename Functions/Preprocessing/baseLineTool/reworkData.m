function [fixedSamp] = reworkData(EYE)
% Major REWRITE NEEDED
% We can use the epoched data in pop_Eyeplot!
% Much easier for reworking the data.
% TBD






% In order to integrate this what currently exists, The results of this
% function will be to create a new file called baseline_redef.mat in the
% folder where files have already been imported.  When calling the
% preprocess functions there well be a check for baseline_redef.mat and if
% so, then it will know to use values from the baseline_redef.mat for
% certain epochs.  This means that after calling this function and making
% some selections (no selections = no change) there will be some questions
% asked and those will determine actions during preprocess.


switch checkingAtype
    case 'All.Yes'
        epochFirst = warndlg('Rather than modifying the imported files this tool will make a new folder','FYI','modal');
        uiwait(epochFirst)
    case 'One.Yes'
        
        
        
    otherwise
        disp('Finished with Baseline tool')
        
end