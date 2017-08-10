function [F_Sign,F,xPercMeans,p_time,F_time,p_sign] = eyeAnalysisCompMobileAvg(varargin)


if size(varargin,2)==1
    %just an epoch file
else
    X_Perc_DataSelected = varargin{1};
    COND = varargin{2};
    SUBJECTS = varargin{3};
    alphaReal = varargin{4};
    num_participants_F = varargin{5};
    num_stimuli = size(num_participants_F,1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparison from one time to the next by mobile averages

observations = size (X_Perc_DataSelected,1); % Calculation of the mobile averages
times = size (X_Perc_DataSelected,2);
for i = 1:times-11
    for j = 1:observations
        xPercMeans(j,i) = mean (X_Perc_DataSelected(j,i:i+11));
    end
end

for time = 1:times-11 % two-way ANOVA time by time
    [p,tableTimes,~] = anovan(X_Perc_DataSelected(:,time),[COND SUBJECTS],'display','off');
    p_time(1,time) = tableTimes{2,7};
    p_time(2,time) = tableTimes{3,7};
    F_time(1,time) = tableTimes{2,6};
    F_time(2,time) = tableTimes{3,6};
    p_sign(1,time)=alphaReal;
end
ddf_1 = num_stimuli-1; % Calculation degrees of freedom
ddf_2 = num_participants_F(1,1)-1;
ddf_error = (size(X_Perc_DataSelected,1)-1)-ddf_1 - ddf_2;




F=finv(1-alphaReal,ddf_1,ddf_error);
%
F_Sign = zeros(1,size (X_Perc_DataSelected,2));

times = size (X_Perc_DataSelected,2);
for time = 1:times
    F_Sign(1,time) = F;
end