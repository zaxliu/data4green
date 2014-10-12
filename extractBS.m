%% Extract Base Station Information from OpenCellID Dataset
%   Extract information of the base stations in some country. Since 
%   OpenCellID dataset is very big, direct csvread is not applicable,
%   use textscan to read multiple rows in bulk instead.
%% Initialization
% File locations
fOCI = '../D4D/cell_towers.csv';    % Location of OpenCellID file
fOut = '../D4D/cell_Senegal.csv';   % Desired location of output file

% Processing parameters
MCC = 608;  % Contry code for desired country, 608 for Senegal
N = 100000; % Bulk read size

% Read/write format
firstRowFormat = '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s';  % Header row format
otherRowFormat = '%f %f %f %f %f %f %f %s %f %f %f %s %f %f %f %f %f %f';  % Data row format
outputColumn = [1,2,4,5,6]; % MCC, MNC, CellID, Longitude, Latitude
outputFormat = '%d,%d,%d,%f,%f\n';

% Temporary variables
n = 0;              % Num of entries read
nFound = 0;         % Num of matched found
rowsRead = {'dummy'};
tTotal = 0;
tBulk = 0;

%% Dataset processing
fidOCI = fopen(fOCI);      % Open OCI dataset
fidOut = fopen(fOut,'w');  % Open output file for write
fprintf(['Reading from file ' fOCI '\n']);
fprintf(['Writing to file ' fOut '\n']);

title = textscan(fidOCI,firstRowFormat,1,'delimiter', ',','EmptyValue', -Inf);  % Read header row (first row)
tic;
rowsRead = textscan(fidOCI,otherRowFormat,N,'delimiter', ',','EmptyValue', -Inf); % Read a row
while ~isempty(rowsRead{1,1})   % If last read got anything, continue processing
    fprintf('Now processing rows %d - %d... ',n+1,n+N);    
    idx = (rowsRead{1,1} == MCC);   % Index BSs that belong to the desired country
    if sum(idx) ~= 0                % If any BS belongs to the desired country
        nFound = nFound + sum(idx);     % Accumulate counter
        fprintf('%d BS found! Total %d... ',sum(idx),nFound); % Tell good news
        % Append results to output variable
        varWrite = cell(length(rowsRead{1}),length(outputColumn));      % To be written to the output file
        for idxC = 1:length(outputColumn)
            varWrite(:,idxC) = mat2cell(rowsRead{outputColumn(idxC)},ones(length(rowsRead{1}),1));
        end
        varWrite = varWrite(idx,:);
        for idxR = 1:size(varWrite,1)
            fprintf(fidOut,outputFormat,varWrite{idxR,:});
        end
    else                           % Else tell the sad news
        fprintf('No BS found... '); 
    end;
    n = n+N;
    tBulk = toc;
    fprintf('Time elapsed: %.3f s\n', tBulk);
    tTotal = tTotal + tBulk;
    tic;
    rowsRead = textscan(fidOCI,otherRowFormat,N,'delimiter', ',','EmptyValue', -Inf); % Read next row
end
% csvwrite(fOut,varWrite);
fprintf(['Results have been written to file ' fOut '\n']);
fprintf('Total time elapsed is %.3f s\n', tTotal);
fclose('all');