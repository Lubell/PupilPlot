% Any use of this function must recognize and cite the source (Jackson &
% Sirois, 2009)

function Data=CleanLREye(nSubject, nLength, L_Data, R_Data, filter, display,fs)
nannersL = isnan(L_Data);
L_Data(nannersL)=0;

nannersL = isnan(R_Data);
R_Data(nannersL)=0;

L__Data=L_Data;
R__Data=R_Data;


x=linspace(0,nLength,nLength);

s=0.0;
ss=0.0;
k=0;

for i=1:nSubject
    s=0.0;
    ss=0.0;
    z=0.0;
    zz=0.0;
    sz=0.0;
    k=0;
    
    L_Data(i,:)=interpolate(nLength, L_Data(i,:));
    R_Data(i,:)=interpolate(nLength, R_Data(i,:));
    
    EYEL.data = L_Data(i,:);
    EYEL.srate = fs;
    
    
    EYER.data = R_Data(i,:);
    EYER.srate = fs;
    EYER.trials = 1;
    EYEL.trials = 1;
    EYER.pnts = nLength;
    EYEL.pnts = nLength;
    
    if filter>0                  %close the filter for now
        curve=L_Data(i,:);
        
        % Below this comment is older code for lowpass filter
        % curveL=lowPass(nLength, curve, filter);
        
        
        % Below this comment is new code for lowpass filter
        [EYEL, ~, ~] = eyefiltnew(EYEL,[],filter,[],0,[],0);
        curveL = EYEL.data;
        
        for j=1:nLength
            if L_Data(i,j)>0
                L_Data(i,j)=curveL(j);
            end
        end
        
        curve=R_Data(i,:);
        % curveR=lowPass(nLength, curve, filter);
        
        
        % Below this comment is new code for lowpass filter
        [EYER, ~, ~] = eyefiltnew(EYER,[],filter,[],0,[],0);
        curveR = EYER.data;
        
        for j=1:nLength
            if R_Data(i,j)>0
                R_Data(i,j)=curveR(j);
            end
        end
    end
    
    
    
    for j=1:nLength
        if L__Data(i,j)>0 & R__Data(i,j)>0
            s=s +L_Data(i,j);
            ss=ss +L_Data(i,j)* L_Data(i,j);
            
            z=z +R_Data(i,j);
            zz=zz +R_Data(i,j)* R_Data(i,j);
            sz=sz+ R_Data(i,j)* L_Data(i,j);
            k=k+1;
        end
    end
    
    if k==0
        disp(['Dropped subject ' num2str(i)]);
        continue
    end
    
    r1=ss-s*s/k;
    r2=zz-z*z/k;
    r3=sz-s*z/k;
    r=r3/sqrt(r1*r2);
    
    B_RL=r3/r1;
    B_LR=r3/r2;
    K_RL=z/k-B_RL*s/k;
    K_LR=z/k-B_LR*z/k;
    
    
    fMean= (s+z)/2/k;
    
    for j=1:nLength
        if r>0.3 & r<=1.0
            if L__Data(i,j)<0 & R__Data(i,j)>0
                L_Data(i,j)=B_LR* R_Data(i,j) +K_LR;
            end
            if R__Data(i,j)<0 & L__Data(i,j)>0
                R_Data(i,j)=B_RL* L_Data(i,j) +K_RL;
            end
        end
        
    end
    
    EYEL.data = L_Data(i,:);   
    EYER.data = R_Data(i,:);
   
    
   
    
    [EYEL, ~, ~] = eyefiltnew(EYEL,[],filter,[],0,[],0);
    [EYER, ~, ~] = eyefiltnew(EYER,[],filter,[],0,[],0);
    
    L_Data(i,:) = EYEL.data;
    R_Data(i,:) = EYER.data;
    % L_Data(i,:)=lowPass(nLength, L_Data(i,:), filter); %%%
    % R_Data(i,:)=lowPass(nLength, R_Data(i,:), filter); %%%
    
    
    for j=1:nLength
        Data(i,j)=(L_Data(i,j)+R_Data(i,j))/2;
    end
    if Data(i,nLength)<=0
        Data(i,nLength)=fMean;
    end
    
    y=linspace(0,0,nLength);
    for j=1:nLength
        y(j)=Data(i,j);
    end
    
    Data(i,:)=interpolate(nLength, Data(i,:));
    
    
    if filter>0
        for k=1:1
            for j=1:nLength
                curve(j)=Data(i,j);
            end
            
            EYE.data = curve;
            EYE.srate = fs;
            EYE.trials = 1;
            EYE.pnts = nLength;

            [EYE, ~, ~] = eyefiltnew(EYE,[],filter,[],0,[],0);
            curve =  EYE.data;
            % curve=lowPass(nLength, curve, filter); %%%
            
            for j=1:nLength
                Data(i,j)=curve(j);
            end
        end
    end
    
    a1=mod(mod(display,100),10);        %100
    a2=mod(display-100,10);             %10
    a3=mod(display,10);                 %1
    
    if display==111
        plot(x, L_Data(i,:),   x, R_Data(i,:),   x, Data(i,:))
        disp('Click the plot to move on to the next pt')
        waitforbuttonpress
    elseif display==1
        plot(x, Data(i,:))
        disp('Click the plot to move on to the next pt')
        waitforbuttonpress
    elseif display==110
        plot(x, L_Data(i,:),   x, R_Data(i,:))
        disp('Click the plot to move on to the next pt')
        waitforbuttonpress
    end
end



function ft=lowPass(M, curve, Fr)
k=0;
N=2;

Omiga=tan(3.1416/Fr);
c=1.0 +2.0*cos(3.1416*(2*k+1)/2.0/N)*Omiga + Omiga*Omiga;

a0=Omiga*Omiga/c;
a2=a0;
a1=2*a0;
b1=-2*(Omiga*Omiga-1.0)/c;
b2=-(1.0-2.0*cos(3.1416*(2*k+1)/2.0/N)*Omiga+Omiga*Omiga)/c;

ft= curve;
curveT=curve;

for i=3:M-1
    curveT(i)=a0*ft(i) +a1*ft(i-1) +a2*ft(i-2)+  b1*curveT(i-1)+ b2*curveT(i-2);
end
% Hd = designfilt('lowpassfir', 'PassbandFrequency', 4, 'StopbandFrequency', 4.1, 'PassbandRipple', 1, 'StopbandAttenuation', 60, 'SampleRate', 50);
% curveT(3:M-1) = pchip(3:M-1,curve(3:M-1),3:M-1);

for i=M-2:-1:3
    ft(i)=a0*curveT(i) +a1*curveT(i+1) +a2*curveT(i+2)+  b1*ft(i+1)+ b2*ft(i+2);
end


function tData=interpolate(nLength, tData)
nStart=0;
nEnd=0;
fStart=0;
fEnd=0;
s=0.0;
k=0;
for j=1:nLength
    if tData(j)>0
        s=s+tData(j);
        k=k+1;
    end
end
if k>0
    fMean=s/k;
else
    fMean=s;
end
for j=1:nLength
    if tData(j)<=0
        if j<=4
            fStart=fMean;
            nStart=j;
        else
            fStart=(tData(j-1)+tData(j-2)+tData(j-3))/3;
            nStart=j;
        end
        
        fEnd=fMean;
        nEnd=nLength;
        for u=j:nLength-2
            if tData(u)>0 & tData(u+1)>0 & tData(u+2)>0
                fEnd=(tData(u)+tData(u+1)+tData(u+2))/3;
                nEnd=u;
                break
            end
        end
        if nEnd==nStart
            tData(j)=fStart;
        else
            for u=nStart:nEnd
                tData(u)=fStart         +(fEnd-fStart)/(nEnd-nStart)*(u-nStart);
            end
            
        end
        
    end
    j=nEnd;
end

