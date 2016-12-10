function ecsr_k = kAbsError(obj,ypred,yactual,weights)

ecsr_k = 0;

for i=1:size(ypred,1)
    ecsr_k = ecsr_k + weights(i)*norm(ypred - yactual);
end

end

