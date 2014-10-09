%% Extract Senegal Base Stations (MNC = 608)
fid = fopen('cell_towers.csv');
fileOut = 'cell_Senegal.csv';
firstLineFormat = '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s';
otherLineFormat = '%f %f %f %f %f %f %f %s %f %f %f %s %f %f %f %f %f %f';
lineRead= textscan(fid,firstLineFormat,1,'delimiter', ',','EmptyValue', -Inf);
title = lineRead;
N = 100000;
n = 0;
nFound = 0;
varWrite = [];
while ~isempty(lineRead{1,1})
    fprintf('Now processing %d - %d...',n+1,n+N);
    lineRead = textscan(fid,otherLineFormat,N,'delimiter', ',','EmptyValue', -Inf);
    idx = (lineRead{1,1} == 608);
    if sum(idx) ~= 0
        nFound = nFound + sum(idx);
        fprintf('%d BS found! Total %d.\n',sum(idx),nFound);
        varWrite((nFound-sum(idx)+1):nFound,1) = lineRead{1,1}(idx);
        varWrite((nFound-sum(idx)+1):nFound,2) = lineRead{1,2}(idx);
        varWrite((nFound-sum(idx)+1):nFound,3) = lineRead{1,4}(idx);
        varWrite((nFound-sum(idx)+1):nFound,4) = lineRead{1,5}(idx);
        varWrite((nFound-sum(idx)+1):nFound,5) = lineRead{1,6}(idx);
    else
        fprintf('No BS found!\n');
    end;
    n = n+N;
end
csvwrite(fileOut,varWrite);