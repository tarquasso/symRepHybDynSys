function initiateCsr(obj,init)

obj.x_train = init.x_train;
obj.y_train = init.y_train;
obj.x_val   = init.x_val;
obj.y_val   = init.y_val;
obj.x_test  = init.x_test;
obj.y_test  = init.y_test;

obj.K = init.K;
obj.k_current = [];
obj.gamma_train = [];
obj.gamma_test = [];
obj.gamma_val = [];

obj.f = [];
obj.var_train = [];
obj.var_test  = [];
obj.var_val = [];

obj.runningEM = false;
obj.initiated = true;

end

