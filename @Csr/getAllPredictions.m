function ypred = getAllPredictions(x,k)

% y = n x k

if nargin < 2
    k = ':';
end

if strcmpi(x,'val') || isequal(x,obj.x_val)
    ypred = obj.ypred_val(:,k);
    return;
end

if strcmpi(x,'test') || isequal(x,obj.x_test)
    ypred = obj.ypred_test(:,k);
    return;
end

if strcmpi(x,'train') || isequal(x,obj.x_train)
    ypred = obj.ypred_train(:,k);
    return;
end

end

