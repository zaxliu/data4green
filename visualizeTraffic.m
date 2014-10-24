for I = 1:1666
    % Specify BS
    % [~,I] = max(sum(sum(callDurationDay,1),3));
    % Inbounding sum
    inSum = squeeze(sum(callDurationDay(:,I,:),1));
    % Outbounding sum
    outSum = squeeze(sum(callDurationDay(I,:,:),2));
    % Plot
    plot(1:24,inSum,'bo-',1:24,outSum,'ro-',1:24,inSum+outSum,'k.-');
    % Pause
    pause;
end