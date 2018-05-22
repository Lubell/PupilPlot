function cleanWrapper(varargin)
% if you're using this as a command line tool make sure to pass in two
% variables otherwise the function will assume that the single variable is
% a path and try to load it.


if size(varargin,2)>=2
    % necessary variables passed in
    optVar = varargin{1};
    genData = varargin{2};
else
    pathIMPFolder = varargin{1};
    if strcmp(pathIMPFolder(end),filesep)
        pathIMPFolder(end) = [];
    end
    load([pathIMPFolder filesep 'preprocSettings.mat'])
end


workingD = optVar{1,2};


%% clean patient 1x1

if isequal(optVar{3,1},1)
    fr = optVar{3,3}; % smoothing parameter
    deBUGG = strfind(optVar{3,2},'off');
    if isempty(deBUGG)
        display=1; % debug info (0 = off)
    else
        display=0;
    end
    
    
    samplesEye = dir([workingD filesep '*_IMP.mat']);
    
    % load the first subject
    subEyeVal = load([workingD filesep samplesEye(1).name]);
    
    % Start building a struct with subject 1
    eyeData.Rpupil = subEyeVal.Rpupil;
    eyeData.Lpupil = subEyeVal.Lpupil;
    
    
    num_participants = length(samplesEye);
    
    for i=2:num_participants
        subEyeVal = load([workingD filesep samplesEye(i).name]);
        eyeData(i).Rpupil = subEyeVal.Rpupil;
        eyeData(i).Lpupil = subEyeVal.Lpupil;
        clear('subEyeVal')
    end
    
    
    
    
    
    disp('Cleaning pupils...');
    
    nSamples = max(size(eyeData(1).Lpupil));
    L = eyeData(1).Lpupil;
    R = eyeData(1).Rpupil;
    eyeData(1).cleanPupil = CleanLREye(1,nSamples,L,R,fr,display,genData.fs);
    disp(['Cleaned ' samplesEye(1).name])
    
else
    disp('Making right pupil dominate...')
    eyeData(1).cleanPupil = eyeData(1).Rpupil;
end


for i = 2:num_participants
    nSamples = max(size(eyeData(i).Lpupil));
    if isequal(optVar{3,1},1)
        eyeData(i).cleanPupil = CleanLREye(1,nSamples,eyeData(i).Lpupil,eyeData(i).Rpupil,fr, display,genData.fs);
    else
        eyeData(i).cleanPupil = eyeData(i).Rpupil;
    end
    disp(['Cleaned ' samplesEye(i).name])
end




% Append clean pupilvalues back into _IMP
for i = 1:num_participants
    C_pupil = eyeData(i).cleanPupil;
    save([workingD filesep samplesEye(i).name],'C_pupil','-append')
end
