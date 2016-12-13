function fitness = transitionFitness(ypred,yactual,gammatilde)

err = yactual(2:end) - logsig(ypred(1:end-1)); % calculate error based on validation - prediction
fitness = sum(-gammatilde .* (err.^2));

sumGammaTilde = sum(gammatilde);
fitness = fitness/sumGammaTilde; %denominator operation of eq. 18, normalizes

end