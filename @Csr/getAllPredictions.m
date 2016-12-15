function ypred = getAllPredictions(x)

if strcmpi(x,'val') || isequal(x,obj.x_val)
    ypred = obj.ypred_val;
    return;
end

if strcmpi(x,'test') || isequal(x,obj.x_test)
    ypred = obj.ypred_test;
    return;
end

if strcmpi(x,'train') || isequal(x,obj.x_train)
    ypred = obj.ypred_train;
    return;
end

end

