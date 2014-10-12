%% Recover True Cell Location
%  The location in D4D dataset is noisy. Use location from OpenCellID
%  dataset to recover true cell location
%% Initialization
fD4D = '../D4D/SITE_ARR_LONLAT.CSV';    % Location of D4D file
fOCI = '../D4D/cell_Senegal.csv';       % Location of extracted OCI file
N = 1666;                               % Num of cells in D4D file
% Result variables
siteMNC = zeros(N,1);
siteCellID = zeros(N,1);
siteLonReal = zeros(N,1);
siteLatReal = zeros(N,1);
siteDis = inf*ones(N,1);
%% Processing
% Read cellID, longitude, and latitude fro D4D file (Omitting header row)
siteD4DID = csvread(fD4D,1,0,[1,0,N,0]);
siteLonN = csvread(fD4D,1,2,[1,2,N,2]);
siteLatN = csvread(fD4D,1,3,[1,3,N,3]);
% Read data from OCI dataset
dataRead = csvread(fOCI);
M = size(dataRead,1);   % Num of cells in extracted OCI file
% Sweep through all cell in OCI to find the closest location
for m = 1:M  % Take a OCI cell    
    % Read location of m-th cell in OCI dataset
    tmpLon = dataRead(m,4);
    tmpLat = dataRead(m,5);
    fprintf('Currently # %d OCI cell.\nLongitude: %5f, Latitude: %4f\n',m,tmpLon,tmpLat);
    % Distance to all D4D cells
    tmpDis = sqrt((siteLonN-tmpLon).^2+(siteLatN-tmpLat).^2);
    % Find the closest match D4D cell
    [minDis,minIndex] = min(tmpDis);
    % Refresh corresponding info if it's closer match
    if(minDis < siteDis(minIndex))
        siteMNC(minIndex) = dataRead(m,2);
        siteCellID(minIndex) = dataRead(m,3);
        siteLonReal(minIndex) = tmpLon;
        siteLatReal(minIndex) = tmpLat;
        siteDis(minIndex) = tmpDis(minIndex);
        fprintf('# %d D4D cell refreshed\n',minIndex);
    else
        fprintf('No D4D cell refreshed\n');
    end
end

% Problem log
% 1. unique siteCellID < 1666, no match for some cells?
