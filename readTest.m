siteID = csvread('SITE_ARR_LONLAT.CSV',1,0,[1,0,1666,0]);
siteLonN = csvread('SITE_ARR_LONLAT.CSV',1,2,[1,2,1666,2]);
siteLatN = csvread('SITE_ARR_LONLAT.CSV',1,3,[1,3,1666,3]);
N = length(siteID);
siteMNC = zeros(N,1); siteCellID = zeros(N,1);
siteLonR = zeros(N,1); siteLatR = zeros(N,1); siteDis = inf*ones(N,1);
%Find closest Site
dataRead = csvread('cell_Senegal.csv');
M = size(dataRead,1);
for m = 1:M
    tmpLon = dataRead(m,4);     tmpLat = dataRead(m,5);
    tmpDis = sqrt((siteLonN-tmpLon).^2+(siteLatN-tmpLat).^2);
    flag = (tmpDis<siteDis);
    siteMNC(flag) = dataRead(m,2);siteCellID(flag) = dataRead(m,3);
    siteLonR(flag) = tmpLon; siteLatR(flag) = tmpLat; siteDis(flag) = tmpDis(flag);
    clc;
    fprintf('%d\n',m);
    fprintf('%d\n',sum(flag));
    fprintf('%5f,%4f',tmpLon,tmpLat);
    m = m+1;
end
