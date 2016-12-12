function yhat = predictData(obj,k,x)


if strcmpi(k,'all')
    k = ':';
end

if strcmpi(x,'val')
    yhat = obj.ypred_val(k,:);
    return;
end

if strcmpi(x,'test')
    yhat = obj.ypred_test(k,:);
    return;
end

if strcmpi(x,'train')
    yhat = obj.ypred_train(k,:);
    return;
end


dim = size(x,2);
n = size(x,1);

xsym = sym('x',[1 dim]);
yhat = zeros(n,1);

for i = 1:n
    yhat(i) = eval(subs(obj.f{k},xsym,x(i,:)));
end

end
