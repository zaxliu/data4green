%% Extract Base Station Information from OpenCellID Dataset
%   Extract information about the base stations in some country. Since 
%   OpenCellID dataset is very big, direct csvread is not applicable,
%   use textscan for bulk row read instead.
%% Initialization
% File locations
fOCI = '../D4D/cell_towers.csv';    % Location of OpenCellID file
fOut = '../D4D/cell_Senegal.csv';   % Desired location of output file

% Processing parameters
MNC = 608;  % Contry code for desired country, 608 for Senegal
N = 100000; % Bulk read size

% Dataset format
firstLineFormat = '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s';  % Header line format
otherLineFormat = '%f %f %f %f %f %f %f %s %f %f %f %s %f %f %f %f %f %f';  % Data line format

%% Dataset processing
fid = fopen(fOCI);  % Open OCI dataset
fprintf(['Reading from file ' fOCI '\n']);
lineRead = textscan(fid,firstLineFormat,1,'delimiter', ',','EmptyValue', -Inf);  % Read header line (first line)
title = lineRead;
n = 0;              % Num of entries read
nFound = 0;         % Num of matched found
varWrite = [];      % To be written to the output file
tTotal = 0;
tBulk = 0;
while ~isempty(lineRead{1,1})   % If last read got anything, continue processing
    tic;
    fprintf('Now processing %d - %d... ',n+1,n+N);
    lineRead = textscan(fid,otherLineFormat,N,'delimiter', ',','EmptyValue', -Inf);
    idx = (lineRead{1,1} == 608);   % Which BS belongs to desired country
    if sum(idx) ~= 0                % If any BS belongs to desired country
        nFound = nFound + sum(idx);     % Accumulate
        fprintf('%d BS found! Total %d... ',sum(idx),nFound); % Tell good news
        % Append results to output variable
        varWrite((nFound-sum(idx)+1):nFound,1) = lineRead{1,1}(idx);
        varWrite((nFound-sum(idx)+1):nFound,2) = lineRead{1,2}(idx);
        varWrite((nFound-sum(idx)+1):nFound,3) = lineRead{1,4}(idx);
        varWrite((nFound-sum(idx)+1):nFound,4) = lineRead{1,5}(idx);
        varWrite((nFound-sum(idx)+1):nFound,5) = lineRead{1,6}(idx);
    else                           % Else tell the sad news
        fprintf('No BS found... '); 
    end;
    n = n+N;
    tBulk = toc;
    fprintf('Time elapsed: %.3f s\n', tBulk);
    tTotal = tTotal + tBulk;
end
csvwrite(fOut,varWrite);
fprintf(['Results have been written to file ' fOut '\n']);
fprintf('Total time elapsed is %.3f s\n', tTotal);