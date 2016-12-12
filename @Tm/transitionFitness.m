function eTm_k = transitionFitness(obj,ypred,yactual,gammatilde)

err = ypred(2:N) - logsig(yactual); % calculate error based on validation - prediction
eTm_k = sum(-gammatilde .* (err.^2));

sumGammaTilde = sum(gammatilde);
eTm_k = eTm_k./sumGammaTilde; %denominator operation of eq. 18, normalizes

end