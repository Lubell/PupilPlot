function [success] = preProcessPupilSegment(varargin)

%% need to make something here to handle varargin

% if only one thing is passed in, then it is the path to the folder that
% contains epoch_preproc.mat file and preprocSettings.mat.
% If two or more things are passed in then it is individual variables.

if size(varargin,2)>=2
    % necessary variables passed in
    optVar = varargin{1};
    genData = varargin{2};
    trigOffSet = varargin{3};
    interestLine= varargin{4};
    baseLine= varargin{5};
    
else
    pathIMPFolder = varargin{1};
    if strcmp(pathIMPFolder(end),filesep)
        pathIMPFolder(end) = [];
    end
    load([pathIMPFolder filesep 'epoch_preproc.mat'])
    load([pathIMPFolder filesep 'preprocSettings.mat'])
end

workingD = optVar{1,2};
%% Building preprocessing struct

samplesEye = dir([workingD filesep '*_IMP.mat']);

% load the first subject
subEyeVal = load([workingD filesep samplesEye(1).name]);

% Start building a struct with subject 1
eyeData.Rpupil = subEyeVal.Rpupil;
eyeData.Lpupil = subEyeVal.Lpupil;
trig = subEyeVal.trig;
eyeData.cleanPupil = subEyeVal.C_pupil;

for i = 1:length(trig)
    if isequal(trig{i},0)
        trig{i} = 'zero';
    end
end
eyeData.trig = trig;
clear('subEyeVal')


num_participants = length(samplesEye);

for i=2:num_participants
    subEyeVal = load([workingD filesep samplesEye(i).name]);
    eyeData(i).Rpupil = subEyeVal.Rpupil;
    eyeData(i).Lpupil = subEyeVal.Lpupil;
    eyeData(i).cleanPupil = subEyeVal.C_pupil;
    trig = subEyeVal.trig;
    
    for k = 1:length(trig)
        if isequal(trig{k},0)
            trig{k} = 'zero';
        end
    end
    eyeData(i).trig = trig;
    clear('subEyeVal')
end



%% Break the cleaned pupil values into baseline group and trial groups
Stimi_names = genData.triggerNames;


% find all instances trial KIND 1 for each pt
actualOccur = Stimi_names(:,2);
occurancesStim = length(actualOccur);
num_total_trigs = 0;
for i = 1:occurancesStim
    num_total_trigs = num_total_trigs + actualOccur{i};
end

triggerNames = Stimi_names(:,1);


disp('Segmenting into trials...');


StimulationsAll = zeros(num_participants,interestLine+baseLine,num_total_trigs); % getting uncorrected trial plot for comparing

for i = 1:num_participants
    outerTestLoop = 1;
    for qt = 1:occurancesStim
        currentStimKind = triggerNames{qt};
        currentTrigArray = eyeData(i).trig;
        allQT = strcmp(currentTrigArray,currentStimKind);
        
        if isequal(trigOffSet,0)
            % trigger is located at the end of the baseline period
            indexQT = find(allQT);
            
        else
            % need to adjust where we grab from.
            indexQT = find(allQT)+trigOffSet;
        end
        
        currentEye = eyeData(i).cleanPupil;
        
        if (indexQT(end)+interestLine)>length(currentEye)+1
            errorTimeMsg = ['Trial length too long (Subject#: ' num2str(i) '), samples = ' num2str(length(currentEye)) ' and tried to grab sample: ' num2str(indexQT(end)+interestLine)];
            error(errorTimeMsg)
        elseif indexQT(1)-baseLine<=0
            errorTimeMsg = ['Baseline period too long, trigger @ sample ' num2str(indexQT(1)) ' and tried to grab sample: ' num2str((indexQT(1)-2)-baseLine+1)];
            error(errorTimeMsg)
        end
        
        
        for j = 1:sum(allQT)
            eyeData(i).Kind(j).typeT(qt).trial = currentEye(indexQT(j):indexQT(j)+interestLine-1);
            eyeData(i).Kind(j).typeB(qt).trial = currentEye(indexQT(j)-baseLine:indexQT(j)-1);
            %eyeData(i).Kind(j).typeT(qt).instancesType = length(indexQT);
            eyeData(i).Kind(j).trialName(qt).type = currentStimKind;
            eyeData(i).Kind(j).correctedMM(qt).type = eyeData(i).Kind(j).typeT(qt).trial - mean(eyeData(i).Kind(j).typeB(qt).trial);
            eyeData(i).Kind(j).correctedPrec(qt).type = eyeData(i).Kind(j).typeT(qt).trial - mean(eyeData(i).Kind(j).typeB(qt).trial)...
                ./mean(eyeData(i).Kind(j).typeB(qt).trial) * 100;
            eyeData(i).Kind(j).whereAm(qt).type =[i j qt];
            
            StimulationsAll(i,:,outerTestLoop) = [currentEye(indexQT(j)-baseLine:indexQT(j)-1) currentEye(indexQT(j):indexQT(j)+interestLine-1)];
            outerTestLoop = outerTestLoop + 1;
        end
        
    end
end




%% Make a single eye dirty structure for plotting later
Ldirt = struct('Lpupil', {eyeData(1:num_participants).Lpupil});
dirtyMatrix = zeros(num_participants,genData.AutoShort);
for i = 1:num_participants
    currentDirt = Ldirt(i).Lpupil;
    dirtyMatrix(i,:) = currentDirt(1:genData.AutoShort);
end





success.L_Eye = dirtyMatrix;
success.StimAll = StimulationsAll;
success.eyeData = struct('Kind', {eyeData(1:num_participants).Kind});

