function ypred = predictDataTM(predictor,x,index)

% assume we call predictData with a gp struct
% then we need to provide the index for which model in the population we
% want to predict (that's why we check for nargin == 3).
if isa(predictor,'struct') && nargin == 3
    evalstr = tree2evalstr(predictor.pop{index},predictor);
    
% elsewise we can call it with a symbolic function object, but then we
% cannot give an index, which model we should use. The appropriate sym
% object must be checked for beforehand when calling it.
elseif isa(predictor,'sym') && nargin == 2
    evalstr{1} = f;
    
% In this case we already provide the cell array containing the function
% char-array. This arises when we do the call to 'tree2evalstr' before
% giving it to predictDataTM
elseif isa(predictor,'cell') && nargin == 2
    evalstr = predictor;
    
else
    error('Check how to call predictData correctly');
end

dim = size(x,2);
n = size(x,1);

for d = 1:dim
    string = ['x' num2str(d) ' = x(:,' num2str(d) ');'];
    eval(string);
end

% preallocate and use (:) to ensure we populate the whole vector
% consider the case where evalstr{1} is only a constant. Output will be a
% scalar. With this operation, we ensure that this scalar is mapped to all
% of the ypred vector.
ypred = zeros(n,1);
ypred(:) = eval(evalstr{1});

end