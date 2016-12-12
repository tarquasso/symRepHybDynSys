function initiateCsr(obj,init)

obj.x_train = init.x_train;
obj.y_train = init.y_train;
obj.x_val   = init.x_val;
obj.y_val   = init.y_val;
obj.x_test  = init.x_test;
obj.y_test  = init.y_test;

obj.K = init.K;
obj.k_current = [];

obj.f = cell(obj.K,1);
obj.var_train = zeros(obj.K,1);
obj.var_test = obj.var_train;
obj.var_val = obj.var_train;

obj.gamma_train = [];
obj.gamma_test = [];
obj.gamma_val = [];

n_train = size(obj.x_train,1);
n_test  = size(obj.x_test,1);
n_val = size(obj.x_val,1);
obj.ypred_train = zeros(n_train,obj.K);
obj.ypred_test = zeros(n_test,obj.K);
obj.ypred_val = zeros(n_val,obj.K);

obj.runningEM = false;
obj.initiated = true;

end

