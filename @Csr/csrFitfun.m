function [fitness,gp] = csrFitfun(evalstr,gp)
% fitness for our TM single-gene usage gptips.

% extract x and y data from GP struct
x = gp.userdata.xtrain; % = n x dim
ytrain = gp.userdata.ytrain;  % = n x 1

% compute prediction
ypred = Csr.predictData(evalstr,x);

% fitness
gamma = Tm.getInstance.getWeightsTrain();
fitness = Tm.transitionFitness(gamma,ytrain,ypred);

end