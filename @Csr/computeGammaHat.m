function gamma = computeGammaHat(obj,k,var,x,y,yhatk)
% compute gammahat for one k and all data points n as row vector
% We hereby replace the function for k with the current new possibilty for 
% computing the gammas
n = size(y,1);

gamma = zeros(1,n); % row vector
yhat = zeros(n,obj.K);
for i = 1:n
    normalization = 0;
    for kk = 1:obj.K
        if kk == k
            yhat(i,kk) = yhatk(i);
        else
            yhat(i,kk) = obj.predictData(kk,x(i,:));
        end
        normalization = normalization + normpdf(y(i),yhat(i,kk),var(kk));
    end
    gamma(i) = normpdf(y(i),yhat(i,k),var(k))/normalization;
end

end

