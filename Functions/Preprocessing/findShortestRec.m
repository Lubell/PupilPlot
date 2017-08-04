function [shortStuff,longStuff] = findShortestRec(optVar)




workingD = optVar{1,2};

samplesEye = dir([workingD filesep '*_IMP.mat']);
shortestGuy=500000000000000000;
longestGuy=1;

% Find the shortest record length
for i = 1:length(samplesEye)
    
    load([workingD filesep samplesEye(i).name])
    
    
    %find shortest clip
    
    LShort = max(size(Lpupil));
    RShort = max(size(Rpupil));
    
    if LShort<RShort
        if LShort<shortestGuy
            shortestGuy=LShort;
            responsiblePT = i;
        end
    else
        if RShort<shortestGuy
            shortestGuy=RShort;
            responsiblePT = i;
        end
    end
    
    
     if LShort>RShort
        if LShort>longestGuy
            longestGuy=LShort;
            responsiblePTL = i;
        end
    else
        if RShort>longestGuy
            longestGuy=RShort;
            responsiblePTL = i;
        end
    end
    
    
    
end

optVar{5,1} = 1;
optVar{5,2} = samplesEye(responsiblePT).name;
optVar{5,3} = shortestGuy;
longStuff = {longestGuy, samplesEye(responsiblePTL).name};
shortStuff = optVar;