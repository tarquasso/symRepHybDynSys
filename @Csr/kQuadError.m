function ecsr_k = kQuadError(obj,ypred,yactual,weights)

ecsr_k = weights * ( (ypred - yactual).^2) ;

end

