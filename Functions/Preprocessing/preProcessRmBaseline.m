function [varargout] = preProcessRmBaseline(eyeData,Stimulations_All)
% Remove Baseline
% pass in the eyedata struct




disp('Removing Baseline...');
Stimulations_Ref = zeros(num_participants,interestLine,num_stimulations);

for participant = 1:num_participants % Calculating reference value from baselineSEC-baseLineMS
    for stimulus = 1 : num_stimulations
        for i = 1:max(size(eyeData(1).Kind))
            Stimulations_Ref(participant, i, stimulus) = eyeData(i).Kind(i).typeT(stimulus).trial;
        end
    end
end

Stimulations_Data_Corr

Stimulations_Data_UnCorr

Stimulations_Data_Perc


for participant = 1:num_participants % Corrected data (mm)
    for stimulus = 1 : num_stimulations
        for i = 1:interestLine
            Stimulations_Data_Corr (participant,i,stimulus) = eyeData(participant).Kind(participant).
            Stimulations_All (participant, trigOff+i,stimulus) - Stimulations_Ref_Mean (participant ,stimulus);
            Stimulations_Data_UnCorr(participant,i,stimulus) = Stimulations_All(participant, trigOff+i,stimulus);
        end
    end
end

for participant = 1:num_participants % Corrected data (%)
    for stimulus = 1 : num_stimulations
        for i = 1:interestLine
            Stimulations_Data_Perc (participant,i,stimulus) = (Stimulations_All (participant, trigOff+i,stimulus)-Stimulations_Ref_Mean (participant ,stimulus)) ./ Stimulations_Ref_Mean (participant ,stimulus) * 100;
        end
    end
end






Stimulations_Data_Corr_mm = Stimulations_Data_Corr;
clear('L_Stimulations','L_Before_pupils','L_After_pupils','R_Stimulations','R_Before_pupils','R_After_pupils','Stimulations_Ref','Target','answer','directory','display','dlg_title','eye_data','file_prefixes','foo_data', 'foo_index','foo_pre' ,'foo_str', 'fr','nLength'); % Cleaning of the work space
