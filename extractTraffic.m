%% Read and Save Monthly Call/MSG Traffic Data
%  The original data is saved in CSV files, this script read out these data
%  into matlab matrices and save them as .mat file.
%  Note: As the call matrix is large, be sure to have more than 20GB memory
%  to run this script

%% Initialization
dataFile = '../D4D/SET1/SET1V_01.csv'; % CSV data file
saveFile = '../D4D/SET1/SET1V_01.mat'; % .mat matrix file
rowFormat = '%s %f %f %f %f';          % Header row format
N = 200000;                            % Buld read size
nBS = 1666;                            % Total num of base stations
timeSpan = 24*31;                      % Dataset time span in hours (tested for one month)
% Temp variables
callNum= zeros(nBS,nBS,timeSpan);
callDuration = zeros(nBS,nBS,timeSpan);
numRowRead = N;
totalT = 0;

%% Processing
fid = fopen(dataFile);
tic;
% do-while loop
rowsRead = textscan(fid,rowFormat,N,'delimiter', ',','EmptyValue', -Inf);
while(~isempty(rowsRead{1,1}))       
    time = rowsRead{1}; src = rowsRead{2}; dest = rowsRead{3}; numCalls = rowsRead{4}; totalDuration = rowsRead{5};
    timeIndex = cellfun(@(date) round(datenum(date,'yyyy-mm-dd HH')*24) - 17645639,time); % Time index starting from 2013-01-01
    callNum(src+nBS.*(dest-1)+nBS^2*(timeIndex-1)) = numCalls;
    callDuration(src+nBS.*(dest-1)+nBS^2*(timeIndex-1)) = totalDuration;
    clc;
    fprintf('%d rows read, date of last entry %s\n',numRowRead,time{end});
    t = toc;
    totalT = totalT + t;
    fprintf('Bulk time: %.3fs. Total time: %.3fs\n',t,totalT);
    tic;
    rowsRead = textscan(fid,rowFormat,N,'delimiter', ',','EmptyValue', -Inf);
    numRowRead = numRowRead + N;
end
fclose('all');
%% Save data
fprintf('Saving call data...\n');
save(saveFile,'callDuration','callNum');