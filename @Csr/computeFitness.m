function fitness = computeFitness(weights,y,ypred)
%calculate weighted, mean logarithmic error
fitness = ( weights*log(1+abs(y - ypred)) ) / sum(weights);

end

