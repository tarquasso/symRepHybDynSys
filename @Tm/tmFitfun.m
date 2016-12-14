function [fitness,gp] = tmFitfun(evalstr,gp)
% fitness for our TM single-gene usage gptips.

%extract x and y data from GP struct
x = gp.userdata.xtrain; % = n x dim
ytrain = gp.userdata.ytrain;  % = n x 1

dim = size(x,2);

for d = 1:dim
    string = ['x' num2str(d) ' = x(:,' num2str(d) ');'];
    eval(string);
end

%evaluate the tree (assuming only 1 gene is suppled in this case)
eval(['ypred=' evalstr{1} ';']);

%fitness
gammatilde = Tm.getInstance.getGammaTildeTrain();
fitness = Tm.getInstance.transitionFitness(ypred,ytrain,gammatilde);

end