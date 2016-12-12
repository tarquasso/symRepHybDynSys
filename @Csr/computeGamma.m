function gamma = computeGamma(obj,k,var,x,y)
% compute gammas for one k and all data points n as row vector

n = size(y,1);

gamma = zeros(1,n); % row vector
yhat = zeros(n,obj.K);
for i = 1:n
    %Denominator
    normalization = 0;
    for kk = 1:obj.K
        yhat(i,kk) = obj.predictData(kk,x(i,:));
        normalization = normalization + normpdf(y(i),yhat(i,kk),var(kk)); %evaluate PDF 
    end
    
    %Numerator/Denominator:
    gamma(i) = normpdf(y(i),yhat(i,k),var(k))/normalization;
end

end

