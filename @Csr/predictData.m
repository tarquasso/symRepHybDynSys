function yhat = predictData(obj,k,x)

dim = size(x,2);
n = size(x,1);

xsym = sym('x',[1 dim]);
yhat = zeros(n,1);

for i = 1:n
    yhat(i) = eval(subs(obj.f{k},xsym,x(i,:)));
end

end

