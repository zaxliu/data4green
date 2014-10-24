for day = 1:31
    callDurationDay = callDuration(:,:,(1:24)+(day-1)*24);
    callNumDay = callNum(:,:,(1:24)+(day-1)*24);
    if day < 10
        dayStr = ['0' num2str(day)];
    else
        dayStr = num2str(day);
    end
    save(['CallDuration_2013-01-' dayStr '.mat'],'callDurationDay');
    save(['CallNum_2013-01-' dayStr '.mat'],'callNumDay');
    fprintf(['2013-01-' dayStr '\n']);
end