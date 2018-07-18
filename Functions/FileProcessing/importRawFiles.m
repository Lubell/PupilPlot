function [Message,Lpupil,Rpupil,lPi,rPi] = importRawFiles(filename,lPi,rPi,startRow, endRow)
% This is a function that should be able to handle .tsv .csv and .txt raw
% pupil data from either tobii or smi files.



[fPath,fName,fExt]=fileparts(filename);
fileID = fopen(filename,'r');
tline = fgetl(fileID);
tline = fgets(fileID);
fclose(fileID)