function initiateTm(obj,init)
      
% All Data Sets with multiple K in the Gamma (in y)
obj.x_train = init.x_train;
obj.y_train = init.y_train;
obj.x_val   = init.x_val;
obj.y_val   = init.y_val;
obj.x_test  = init.x_test;
obj.y_test  = init.y_test;

obj.K = init.K;

% do not touch
obj.k_current = [];
obj.ksub_current = [];

obj.f = cell(obj.K,obj.K); %transition functions KxK, diagonal terms do not matter

n_train = length(obj.x_train);
n_test  = length(obj.x_test);
n_val = length(obj.x_val);

% Weight Balance
obj.ptp_train = zeros(obj.K,n_train-1); %one element shorter
obj.ptp_val = zeros(obj.K,n_val-1); %one element shorter

obj.ntp_train = zeros(obj.K,n_train-1); %one element shorter
obj.ntp_val = zeros(obj.K,n_val-1); %one element shorter

obj.ntpTilde_train = zeros(obj.K,n_train-1); %one element shorter
obj.ntpTilde_val = zeros(obj.K,n_val-1); %one element shorter

obj.gammaTilde_train = zeros(obj.K,n_train-1);%one element shorter
obj.gammaTilde_val = zeros(obj.K,n_val-1);%one element shorter

% Outputs
obj.ypred_train = zeros(obj.K,obj.K,n_train);
obj.ypred_test = zeros(obj.K,obj.K,n_test);
obj.ypred_val = zeros(obj.K,obj.K,n_val);

obj.runningTM = false;
obj.initiated = true;

end

