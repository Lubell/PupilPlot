function [fdaComplete,t_fd,crit_t_val,numTails] = performFDAfunc(Stimuli_Data_Corr_Mean,compareIndexes,interestLineSamples,alphaUP,localMan)

% first we'll compute 
numTails = 0;
num_parts = size(Stimuli_Data_Corr_Mean,1);
num_condition = size(Stimuli_Data_Corr_Mean,3);
fda_conditionOne = zeros(1,interestLineSamples);
fda_conditionTwo = zeros(1,interestLineSamples);
for i = 1:num_parts % for each participant, create mean data for each condition, separately
    fda_conditionOne(i,:) = squeeze(Stimuli_Data_Corr_Mean(i,:,compareIndexes(1)))';
    fda_conditionTwo(i,:) = squeeze(Stimuli_Data_Corr_Mean(i,:,compareIndexes(2)))';
end


differences = fda_conditionTwo-fda_conditionOne; % we'll do a t test comparing them... so the focus is on the difference between each, for each participant
% differences = fda_conditionOne-fda_conditionTwo; % Need to figure this
% out.  Does it even matter which is subtract from the other?


basis = create_bspline_basis([1 interestLineSamples],10,4); % b-spline basis object
y=1:interestLineSamples;
fd_data_1_1 = data2fd(differences',y', basis); % transform data into b-splines



fdaComplete = mean(fd_data_1_1); % mean difference

data_mat = eval_fd(fd_data_1_1, 1:interestLineSamples)'; % data in raw form
data_mat_squared = data_mat.^2; % squared data

S_D = sqrt((sum(data_mat_squared)-((sum(data_mat).^2)./num_parts))./(num_parts - 1)); % standard deviation of the difference
SE = S_D./sqrt(num_parts); % standard error of the difference

t_fd = (eval_fd(fdaComplete,1:interestLineSamples)./SE')'; % t ration

ci = 1-alphaUP; n = num_parts; 
tcrit2 = tinv((ci/2),n-1); 
tcrit1 = tinv(ci,n-1);



if isequal(localMan,1)
    hwTails = questdlg('How many tailed test would you like to use?','Tailed t-test',...
        'One','Two','Two');
    if strcmp(hwTails,'One')
        crit_t_val = tcrit1;
        numTails = 3;
    else
        crit_t_val = tcrit2;
        numTails = 4;
    end
    
elseif localMan>1
    if isequal(localMan,3)
        crit_t_val = tcrit1;
    else
        crit_t_val = tcrit2;
    end
    
    
else
    crit_t_val = 0;
end

