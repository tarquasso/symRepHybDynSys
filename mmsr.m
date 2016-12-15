% Hyperelastic Material properties
% https://en.wikipedia.org/wiki/Hyperelastic_material
% https://en.wikipedia.org/wiki/Mooney%E2%80%93Rivlin_solid
% https://en.wikipedia.org/wiki/Neo-Hookean_solid

% clear all, close all, clc

addpath('gptips2')
t.TimeZone = 'America/New_York';

% Data Parsing

if(true)
% Rubber Data Case
[dataTrain,dataVal,dataTest] = loadSoftRubberData();

K = 2;
% dataTrain.tAll

%NTrain = length(dataTrain.zAll);
%xTrain = [dataTrain.zAll];%,dataTrain.zdAll];
%yTrain = dataTrain.zddAll;
%modeTrain = dataTrain.mode; % 1 is in the air, 2 is in contact

%NVal = length(dataVal.zAll);
%xVal = [dataVal.zAll];%,dataVal.zdAll];
%yVal = dataVal.zddAll;
%modeVal = dataVal.mode; % 1 is in the air, 2 is in contact

%NTest = length(dataTest.zAll);
%xTest = [dataTest.zAll];%,dataTest.zdAll];
%yTest = dataTest.zddAll;
%modeTest = dataTest.mode; % 1 is in the air, 2 is in contact

xTrain = [dataTrain.zAll,dataTrain.zdAll];
yTrain = dataTrain.zddAll;
mTrain = dataTrain.mode; % 1 is in the air, 2 is in contact

xTest = [dataTest.zAll,dataTest.zdAll];
yTest = dataTest.zddAll;
mTest = dataTest.mode; % 1 is in the air, 2 is in contact

xVal = [dataVal.zAll,dataVal.zdAll];
yVal = dataVal.zddAll;
mVal = dataVal.mode; % 1 is in the air, 2 is in contact

NTrain = length(yTrain);
NTest  = length(yTest);
NVal = length(yVal);

else
  
% Synthetic Data Case
%[dataTrain,dataVal,dataTest] = loadHysteresisRelayData();
% [dataTrain,dataVal,dataTest] = loadHysteresisRelayShortData();
 [dataTrain,dataVal,dataTest] = loadContinuousHysteresisLoopData();

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

%% Generate Gamma:
gammaTrain = zeros(NTrain,K); %KxN matrix
gammaTrain((modeTrain == 1),1) = 1;
gammaTrain((modeTrain == 2),2) = 1;

gammaVal = zeros(NVal,K); %KxN matrix
gammaVal((modeVal == 1),1) = 1;
gammaVal((modeVal == 2),2) = 1;

gammaTest = zeros(NTest,K); %KxN matrix
gammaTest((modeTest == 1),1) = 1;
gammaTest((modeTest == 2),2) = 1;

%% CSR


%% Set up Init File
initCsr.x_train = xTrain;
initCsr.y_train = yTrain; % seprate it out in runTM

initCsr.x_val = xVal;
initCsr.y_val = yVal;

initCsr.x_test = xTest;
initCsr.y_test = yTest;

initCsr.K = K;

% make them deviate a little bit
initCsr.gammaTrain = gammaTrain + 0.2*rand(NTrain,k);
initCsr.gammaVal = gammaVal + 0.2*rand(NVal,k);
initCsr.gammaTest = gammaTest + 0.2*rand(NTrain,k);

  
csrObj = Csr.getInstance();
csrObj.initiateCsr(initCsr);

[functions,variances] = csrObj.runEM();

% one hot encoding of modes
%[~,gammaTrain] = max(csrObj.gamma_train,[],1);
%[~,gammaVal] = max(csrObj.gamma_val,[],1);
%[~,gammaTest] = max(csrObj.gamma_test,[],1);
%gammaTrain = gammaTrain';
%gammaVal = gammaVal';
%gammaTest = gammaTest';

csrObj.f{1}
csrObj.f{2}




%%
figure(1); clf;
plot(1:NTrain,gammaTrain','-..')
title('Gama Train')

figure(2); clf;
plot(1:NVal,gammaVal','-..')
title('Gama Validation')

figure(3); clf;
plot(1:NTest,gammaTest','-..')
title('Gama Test')
%

if(false)
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

%% Evaluate the outputs
k=1;
ksub=2;
f_1_2 = tmObj.getAlgebraicFunction(k,ksub)
transTrain_1_2 = tmObj.getPredictedTransitionsTrain(k,ksub);
transVal_1_2 = tmObj.getPredictedTransitionsVal(k,ksub);
transTest_1_2 = tmObj.getPredictedTransitionsTest(k,ksub);

k=2;
ksub=1;
f_2_1 = tmObj.getAlgebraicFunction(k,ksub)
transTrain_2_1 = tmObj.getPredictedTransitionsTrain(k,ksub);
transVal_2_1 = tmObj.getPredictedTransitionsVal(k,ksub);
transTest_2_1 = tmObj.getPredictedTransitionsTest(k,ksub);

end