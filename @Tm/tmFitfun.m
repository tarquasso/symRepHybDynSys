function [fitness,gp] = tmFitfun(evalstr,gp)
% fitness for our TM single-gene usage gptips.

% extract x and y data from GP struct
x = gp.userdata.xtrain; % = n x dim
ytrain = gp.userdata.ytrain;  % = n x 1

% compute prediction
ypred = Tm.predictDataTM(evalstr,x);

% fitness
gammatilde = Tm.getInstance.getGammaTildeTrain();
fitness = Tm.transitionFitness(ypred,ytrain,gammatilde);

end