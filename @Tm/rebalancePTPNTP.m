function rebalancePTPNTP(obj,k)

%ytrain is actually gamma

obj.ptp_train(k,:) = obj.y_train(k,1:end-1) .* (1 - obj.y_train(k,2:end));
obj.ptp_val(k,:) = obj.y_val(k,1:end-1) .* (1 - obj.y_val(k,2:end));

obj.ntp_train(k,:) = obj.y_train(k,1:end-1) - obj.ptp_train(k,:);
obj.ntp_val(k,:) = obj.y_val(k,1:end-1) - obj.ptp_val(k,:);

%sum each for 1:N-1m which is the length of them
ptpSum_train = sum(obj.ptp_train(k,:));
ptpSum_val = sum(obj.ptp_val(k,:));

ntpSum_train = sum(obj.ntp_train(k,:));
ntpSum_val = sum(obj.ntp_val(k,:));

obj.ntpTilde_train(k,:) = obj.ntp_train(k,:) * ptpSum_train/ntpSum_train;
obj.ntpTilde_val(k,:) = obj.ntp_val(k,:) * ptpSum_val/ntpSum_val;

obj.gammaTilde_train(k,:) = obj.ptp_train(k,:) + obj.ntpTilde_train(k,:);
obj.gammaTilde_val(k,:) = obj.ptp_val(k,:) + obj.ntpTilde_val(k,:);

end