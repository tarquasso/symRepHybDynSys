% Hyperelastic Material properties
% https://en.wikipedia.org/wiki/Hyperelastic_material
% https://en.wikipedia.org/wiki/Mooney%E2%80%93Rivlin_solid
% https://en.wikipedia.org/wiki/Neo-Hookean_solid

[dataTrain,dataVal,dataTest] = loadHysteresisRelayData();
% [dataTrain,dataVal,dataTest] = loadContinuousHysteresisLoopData();
% [dataTrain,dataVal,dataTest] = loadSoftRubberData();

K = 2;
csrObj = Csr();
[functions,variances,gamma] = runEM(obj,u,y,K);
[transitions] = runTM(gamma,K);