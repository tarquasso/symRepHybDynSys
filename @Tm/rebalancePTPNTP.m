function rebalancePTPNTP(obj,k)
%for 1:N-1
indices = 1:(obj.N-1);
obj.ptp(k,:) = obj.gamma(k,indices) .* (1 - obj.gamma(k,indices+1));
obj.ntp(k,:) = obj.gamma(k,indices) - obj.ptp(k,:);

%sum each for 1:N-1m which is the length of them
ptpSum = sum(obj.ptp(k,:));
ntpSum = sum(obj.ntp(k,:));

obj.ntpTilde(k,:) = obj.ntp(k,:) * ptpSum/ntpSum;

obj.gammaTilde(k,:) = obj.ptp(k,:) + obj.ntpTilde(k,:);

end