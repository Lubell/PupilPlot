function [ANOVA_data,binNumber] = anova_Plot(varargin)
% extract data for ANOVA

% choose number of bins to display pupil change Should be determined by
% length of epoch

if isequal(length(varargin),7)
    interestLineSamples = varargin{1};
    %interestLineMS = varargin{2};
    num_parts = varargin{3};
    num_stimuli = varargin{4};
    Stimuli_Data_Corr_Mean = varargin{5};
    binNumber = varargin{6};
    fs = varargin{7};

else
    interestLineSamples = varargin{1};
    interestLineMS = varargin{2};
    num_parts = varargin{3};
    num_stimuli = varargin{4};
    Stimuli_Data_Corr_Mean = varargin{5};
    fs = varargin{6};

    
    
promptforDLG = ['The length of your trials is ' num2str(interestLineMS),...
    ' ms how many bins would you like group the data into?'];
binNimber =  inputdlg(promptforDLG,'Bin number',1,{'5'});


binNumber = str2double(binNimber{1});
end


numberOfStimuli = numel(num_stimuli);

if isequal(binNumber,1)
    % if just one show an average of all trial type
    ANOVA_data = zeros(numberOfStimuli,binNumber);
    countSubj = 1;
    for i = num_stimuli
        
        condition =  mean(Stimuli_Data_Corr_Mean(:,:,i));
        ANOVA_data(countSubj)= mean(condition);
        countSubj = countSubj+1;
    end
    
else
    
    slots = 1:interestLineSamples/binNumber:interestLineSamples;
    ANOVA_data = zeros(num_parts,binNumber*numberOfStimuli);
    countDown = numberOfStimuli-1;
    oneHundredMS = sampleTimes(fs,100,'ms');
    warning off
    for i = num_stimuli
        
        for j = 1:num_parts
            condition =  Stimuli_Data_Corr_Mean(j,:,i);
            for k = numberOfStimuli:numberOfStimuli:binNumber*numberOfStimuli % possibly bin number * stimuli number
                manTwo = k/numberOfStimuli;
                med2Be = condition(slots(manTwo):slots(manTwo)+oneHundredMS);
                ANOVA_data(j,k-countDown) = median(med2Be);
                
            end
            
        end
        countDown = countDown-1;
    end
    warning on
end