% Hyperelastic Material properties
% https://en.wikipedia.org/wiki/Hyperelastic_material
% https://en.wikipedia.org/wiki/Mooney%E2%80%93Rivlin_solid
% https://en.wikipedia.org/wiki/Neo-Hookean_solid

addpath('gptips2')
t.TimeZone = 'America/New_York';

%% Data Parsing

if(false)
%% Rubber Data Case
[dataTrain,dataVal,dataTest] = loadSoftRubberData();

K = 2;
% dataTrain.tAll
xTrain = [dataTrain.zAll,dataTrain.zdAll];
yTrain = dataTrain.zddAll;
mTrain = dataTrain.mode; % 1 is in the air, 2 is in contact

else
  
%% Synthetic Data Case
% [dataTrain,dataVal,dataTest] = loadHysteresisRelayData();
[dataTrain,dataVal,dataTest] = loadHysteresisRelayShortData();
% [dataTrain,dataVal,dataTest] = loadContinuousHysteresisLoopData();

NTrain = length(dataTrain.u);
K = dataTrain.K; %2
xTrain = dataTrain.u'; % one dimension u values
yTrain = dataTrain.y';
modeTrain = dataTrain.m'; %for comparision

NVal = length(dataVal.u);
xVal = dataVal.u'; % one dimension u values
yVal = dataVal.y';
modeVal = dataVal.m'; %for comparision

NTest = length(dataTest.u);
xTest = dataTest.u'; % one dimension u values
yTest = dataTest.y';
modeTest = dataTest.m'; %for comparision

end

%% CSR

if(false)

%% Set up Init File
initCsr.x_train = xTrain;
initCsr.y_train = yTrain; % seprate it out in runTM

initCsr.x_val = xVal;
initCsr.y_val = yVal;

initCsr.x_test = xTest;
initCsr.y_test = yTest;

initCsr.K = K;
  
csrObj = Csr.getInstance();
csrObj.initiateCsr(initCsr);

% [functions,variances] = csrObj.runEM();

gammaTrain = csrObj.gamma_train;
gammaVal = csrObj.gamma_val;
gammaTest = csrObj.gamma_test;    

else
  
%% Generate Gamma:
gammaTrain = zeros(NTrain,K); %KxN matrix
gammaTrain((modeTrain == 1),1) = 1;
gammaTrain((modeTrain == 2),2) = 1;

gammaVal = zeros(K,NVal); %KxN matrix
gammaVal((modeVal == 1),1) = 1;
gammaVal((modeVal == 2),2) = 1;

gammaTest = zeros(K,NTest); %KxN matrix
gammaTest((modeTest == 1),1) = 1;
gammaTest((modeTest == 2),2) = 1;

end

figure(1); clf;
plot(1:NTrain,gammaTrain,'-..')
title('Gama Train')

figure(2); clf;
plot(1:NVal,gammaVal,'-..')
title('Gama Validation')

figure(3); clf;
plot(1:NTest,gammaTest,'-..')
title('Gama Test')

%% Set up Init File
initTm.x_train = xTrain;
initTm.y_train = gammaTrain; % seprate it out in runTM

initTm.x_val = xVal;
initTm.y_val = gammaVal;

initTm.x_test = xTest;
initTm.y_test = gammaTest;

initTm.K = K;

tmObj = Tm.getInstance();

tmObj.initiateTm(initTm);

%% Run the TM Algorithm
tmObj.runTM();

%% Evaluate the output
k=1;
ksub=2;
f_1_2 = tmObj.getAlgebraicFunction(obj,k,ksub);
transTrain_1_2 = getPredictedTransitionsTrain(obj,k,ksub);
transVal_1_2 = getPredictedTransitionsVal(obj,k,ksub);
transTest_1_2 = getPredictedTransitionsTest(obj,k,ksub);

k=2;
ksub=1;
f_2_1 = tmObj.getAlgebraicFunction(obj,k,ksub);
transTrain_2_1 = getPredictedTransitionsTrain(obj,k,ksub);
transVal_2_1 = getPredictedTransitionsVal(obj,k,ksub);
transTest_2_1 = getPredictedTransitionsTest(obj,k,ksub);