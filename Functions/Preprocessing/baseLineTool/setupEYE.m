function [EYE,EEG,CURRENTSET,ALLEEG,tmpcom] = setupEYE(PathName,FileName,srate)



try
    load(['subFunc' filesep 'EYEdataEX.mat'])
    %addpath([blTdir filesep 'subFunc' filesep])
catch
    %helpdlg('Please Select baseLineTool Folder')
    blTdir = uigetdir('Please Select baseLineTool Folder');
    addpath(blTdir)
    addpath([blTdir filesep 'subFunc' filesep])
    load([blTdir filesep 'subFunc' filesep 'EYEdataEX.mat'])
end





if not(ischar(FileName))
    workingDir = dir([PathName filesep '*_IMP.mat']);
    
    try
        load([PathName filesep 'epoched_preproc.mat']);
    catch
       warndlg('First preprocess if you want to plot all patients')        
       return
    end
    channelNumber = blankEyeEx.chanlocs_three;
    data = zeros(num_participants,genData.AutoShort);
    for i = 1:length(workingDir)
       load([PathName filesep workingDir(i).name])
        data(i,:) = C_pupil(1:genData.AutoShort);
        ptName = workingDir(i).name;
        channelNumber(i).labels = ptName(1:end-8);
        channelNumber(i).type = 'EEG';
        channelNumber(i).urchan = i;
        channelNumber(i).sph_radius = 85;
        
        if isequal(length(C_pupil),genData.AutoShort)
            eyeTriggers = trig;
            leftPupil = Lpupil;
            CurGuy = 'All Subjects....';
        end
        clear Lpupil Rpupil C_pupil trig
    end
    EYE.chanlocs = channelNumber;
else
    oldFile = [PathName FileName];
    load(oldFile)
    
    if exist('C_pupil','var')
        data = [Lpupil;Rpupil;C_pupil];
        EYE.chanlocs = blankEyeEx.chanlocs_three;
        
    else
        data = [Lpupil;Rpupil];
        EYE.chanlocs = blankEyeEx.chanlocs;
    end
    
    eyeTriggers = trig;
    leftPupil = Lpupil;
    CurGuy = FileName;
end



EYE.event(1).latency =1;
EYE.event(1).type = eyeTriggers{1};
EYE.event(1).urevent = 1;
outCOunt = 2;


eVdata= zeros(1,2);
eVdata(1)=1;
for i = 2:length(eyeTriggers)
    if ~isequal(eyeTriggers{i},0)
        EYE.event(outCOunt).latency = i;
        EYE.event(outCOunt).type = eyeTriggers{i};
        EYE.event(outCOunt).urevent = outCOunt;
        eVdata(outCOunt)=i;
        outCOunt = outCOunt +1;
    end
end
cheatData = eVdata+1;
data(:,eVdata) = data(:,cheatData);

EYE.falseSamp = eVdata;
EYE.data = data;
EYE.nbchan = size(EYE.data,1);
EYE.trials = 1;
EYE.reject = blankEyeEx.reject;
EYE.srate = srate;
EYE.pnts = ceil(length(leftPupil))/EYE.srate;


EYE.xmin = 0;
EYE.xmax = EYE.pnts;
EYE.setname = CurGuy(1:end-4);

EYE.icawinv = [];
EYE.icaweights = [];
EYE.icasphere = [];
EYE.session = [];
EYE.urchanlocs = [];
EYE.icaact = [];



tmpcom = '[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );';
ALLEEG = EYE;
CURRENTSET = EYE;
EEG = EYE;
