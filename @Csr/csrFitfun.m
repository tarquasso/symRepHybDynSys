function [fitness,gp] = csrFitfun(evalstr,gp)
% fitness for our CSR single-gene usage gptips.

% extract x and y data from GP struct
x = gp.userdata.xtrain; % = n x dim
ytrain = gp.userdata.ytrain;  % = n x 1

% compute prediction
ypred = Csr.predictData(evalstr,x);

% fitness
gamma = Csr.getInstance.getWeightsTrain();
fitness = Csr.computeFitness(gamma,ytrain,ypred);

end