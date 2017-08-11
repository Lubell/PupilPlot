function [OUT,desc] = sampleTimes(sampleRate,val2con,typeIN,typeOut)
% Convert an integer to either a sample number, ms, or sec

fs = sampleRate;

switch typeIN
    case 'samp'
        % val2con is a sample number
        
        if strcmpi(typeOut,'sec')
            % we're convert val2con to sec
            OUT = val2con/fs;
            desc = 'seconds';
        else
            % we're convert val2con to ms
            OUT = (val2con/fs)*1000;
            desc = 'milliseconds';
        end
        
    case 'ms'
        % val2con is a ms number that we're converting to samples
        desc = 'samples';
        OUT = (val2con/1000)*fs;
        
    case 'sec'
        % val2con is a sec number that we're converting to samples
        OUT = val2con*fs;
        desc = 'samples';
end