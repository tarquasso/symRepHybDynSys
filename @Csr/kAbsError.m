function ecsr_k = kAbsError(obj,ypred,yactual,weights)

ecsr_k = weights*abs(ypred - yactual);

end

