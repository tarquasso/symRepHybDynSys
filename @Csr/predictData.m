function yhat = predictData(obj,k,x)

if strcmpi(k,'all')
    k = ':';
end

if strcmpi(x,'val') || isequal(x,obj.x_val)
    yhat = obj.ypred_val(:,k);
    return;
end

if strcmpi(x,'test') || isequal(x,obj.x_test)
    yhat = obj.ypred_test(:,k);
    return;
end

if strcmpi(x,'train') || isequal(x,obj.x_train)
    yhat = obj.ypred_train(:,k);
    return;
end

assert(~(ischar(k) && ~ischar(x)),'You need to set x = {test,train,val} when you use k = all');
dim = size(x,2);
xsym = sym('x',[1 dim]);
contained = symvar(obj.f{k});
dim_reduced = length(contained);
x_important = cell(dim_reduced,1);
for i=1:dim_reduced
    var = find(xsym == contained(i));
    x_important{i} = x(:,var);
end
g = matlabFunction(f);
yhat = g(x_important{:});

end