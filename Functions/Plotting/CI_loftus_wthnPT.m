function [ciAbove,ciBelow]=CI_loftus_wthnPT(num_stimuli,X_Corr_DataSelected,num_participants_F,X_Corr_DataSelected_Means,zScore)

subjectbyConditionAvg = mean(X_Corr_DataSelected,2);

normalizedAvg_TemptTwo = zeros(size(X_Corr_DataSelected,1),size(X_Corr_DataSelected,2));
condiSwitch = 0:num_participants_F(1,1):length(subjectbyConditionAvg);
condiSwitch(1) = [];
meanCase = 1;
num_pt=length(num_participants_F);
grandAverage = zeros(num_pt,1);
line_start = 1;
for stimulus = num_stimuli
   
   grandAverage(stimulus)= mean(mean(X_Corr_DataSelected(line_start:line_start+num_participants_F(stimulus,1)-1,:),2));
   line_start = line_start + num_participants_F(stimulus,1);
end

for i = 1:size(X_Corr_DataSelected,1)
    for j = 1:size(X_Corr_DataSelected,2)
        normalizedAvg_TemptTwo(i,j)=X_Corr_DataSelected(i,j)-subjectbyConditionAvg(i)+grandAverage(meanCase,:);
    end
    if isequal(i,condiSwitch(meanCase))
        meanCase = meanCase+1;
    end
end


sdDev = zeros(num_pt,size(X_Corr_DataSelected,2));
ciAbove = zeros(num_pt,size(X_Corr_DataSelected,2));
ciBelow = zeros(num_pt,size(X_Corr_DataSelected,2));
line_start = 1; % Calculation of Confidence Intervals
for stimulus = num_stimuli
sdDev(stimulus,:)=(zScore * std(normalizedAvg_TemptTwo (line_start:line_start+num_participants_F(stimulus,1)-1,:))./ sqrt (size(normalizedAvg_TemptTwo (line_start:line_start+num_participants_F(stimulus,1)-1,:),1)));
ciAbove(stimulus,:) = X_Corr_DataSelected_Means (stimulus,:) + sdDev (stimulus,:);
ciBelow(stimulus,:) = X_Corr_DataSelected_Means (stimulus,:) - sdDev (stimulus,:);
line_start = line_start + num_participants_F(stimulus,1);
end



%% In Case anyone wants to check, this is for an 8 condition exp with 21 subjects and this is how step by step I derived the CI values
% 
% 
% 
% 
% condtion_1 = X_Corr_DataSelected(1:21,:);
% condtion_2 = X_Corr_DataSelected(22:42,:);
% condtion_3= X_Corr_DataSelected(43:63,:);
% condtion_4= X_Corr_DataSelected(64:84,:);
% condtion_5= X_Corr_DataSelected(85:105,:);
% condtion_6= X_Corr_DataSelected(106:126,:);
% condtion_7= X_Corr_DataSelected(127:147,:);
% condtion_8= X_Corr_DataSelected(148:168,:);
% 
% 
% subAverage_1 = mean(condtion_1,2);
% subAverage_2= mean(condtion_2,2);
% subAverage_3= mean(condtion_3,2);
% subAverage_4= mean(condtion_4,2);
% subAverage_5= mean(condtion_5,2);
% subAverage_6= mean(condtion_6,2);
% subAverage_7= mean(condtion_7,2);
% subAverage_8= mean(condtion_8,2);
% 
% grandAverage_1 = mean(subAverage_1);
% grandAverage_2 = mean(subAverage_2);
% grandAverage_3 = mean(subAverage_3);
% grandAverage_4 = mean(subAverage_4);
% grandAverage_5 = mean(subAverage_5);
% grandAverage_6 = mean(subAverage_6);
% grandAverage_7 = mean(subAverage_7);
% grandAverage_8 = mean(subAverage_8);
% 
% 
% 
% 
% normalizedAvg_1 = condtion_1 - repmat(subAverage_1,1,288) + grandAverage_1;
% normalizedAvg_2= condtion_2 - repmat(subAverage_2,1,288) + grandAverage_2;
% normalizedAvg_3= condtion_3 - repmat(subAverage_3,1,288) + grandAverage_3;
% normalizedAvg_4= condtion_4 - repmat(subAverage_4,1,288) + grandAverage_4;
% normalizedAvg_5= condtion_5 - repmat(subAverage_5,1,288) + grandAverage_5;
% normalizedAvg_6= condtion_6 - repmat(subAverage_6,1,288) + grandAverage_6;
% normalizedAvg_7= condtion_7 - repmat(subAverage_7,1,288) + grandAverage_7;
% normalizedAvg_8= condtion_8 - repmat(subAverage_8,1,288) + grandAverage_8;
% 
% 
% 
% standDev_1 = std(normalizedAvg_1)./sqrt(21);
% standDev_2 = std(normalizedAvg_2)./sqrt(21);
% standDev_3 = std(normalizedAvg_3)./sqrt(21);
% standDev_4 = std(normalizedAvg_4)./sqrt(21);
% standDev_5 = std(normalizedAvg_5)./sqrt(21);
% standDev_6 = std(normalizedAvg_6)./sqrt(21);
% standDev_7 = std(normalizedAvg_7)./sqrt(21);
% standDev_8 = std(normalizedAvg_8)./sqrt(21);
% 
% standError_1 = standDev_1.*1.96;
% standError_2 = 1.96 * standDev_2;
% standError_3 = 1.96 * standDev_3;
% standError_4 = 1.96 * standDev_4;
% standError_5 = 1.96 * standDev_5;
% standError_6 = 1.96 * standDev_6;
% standError_7 = 1.96 * standDev_7;
% standError_8 = 1.96 * standDev_8;
% 
% 
% ciAbove(1:8,:)=[X_Corr_DataSelected_Means(1,:)+standError_1;...
%                 X_Corr_DataSelected_Means(2,:)+standError_2;...
%                 X_Corr_DataSelected_Means(3,:)+standError_3;...
%                 X_Corr_DataSelected_Means(4,:)+standError_4;...
%                 X_Corr_DataSelected_Means(5,:)+standError_5;...
%                 X_Corr_DataSelected_Means(6,:)+standError_6;...
%                 X_Corr_DataSelected_Means(7,:)+standError_7;...
%                 X_Corr_DataSelected_Means(8,:)+standError_8];
% 
% 
% 
% ciBelow(1:8,:)=[X_Corr_DataSelected_Means(1,:)-standError_1;...
%                 X_Corr_DataSelected_Means(2,:)-standError_2;...
%                 X_Corr_DataSelected_Means(3,:)-standError_3;...
%                 X_Corr_DataSelected_Means(4,:)-standError_4;...
%                 X_Corr_DataSelected_Means(5,:)-standError_5;...
%                 X_Corr_DataSelected_Means(6,:)-standError_6;...
%                 X_Corr_DataSelected_Means(7,:)-standError_7;...
%                 X_Corr_DataSelected_Means(8,:)-standError_8];
% 
