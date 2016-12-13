% Hyperelastic Material properties
% https://en.wikipedia.org/wiki/Hyperelastic_material
% https://en.wikipedia.org/wiki/Mooney%E2%80%93Rivlin_solid
% https://en.wikipedia.org/wiki/Neo-Hookean_solid

%% Data Parsing

if(false)
%% Rubber Data Case
[dataTrain,dataVal,dataTest] = loadSoftRubberData();

K = 2;
% dataTrain.tAll
u = [dataTrain.zAll,dataTrain.zdAll]';
y = dataTrain.zddAll';

% dataTrain.mode

else
  
%% Synthetic Data Case
[dataTrain,dataVal,dataTest] = loadHysteresisRelayData();
% [dataTrain,dataVal,dataTest] = loadContinuousHysteresisLoopData();

N = length(dataTrain.u);
K = dataTrain.K; %2
xTrain = dataTrain.u; % one dimension u values
yTrain = dataTrain.y;
modeTrain = dataTrain.m; %for comparision

xVal = dataVal.u; % one dimension u values
yVal = dataVal.y;
modeVal = dataVal.m; %for comparision

xTest = dataTest.u; % one dimension u values
yTest = dataTest.y;
modeTest = dataTest.m; %for comparision

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
gammaTrain = zeros(K,N); %KxN matrix
gammaTrain(1, (modeTrain == 1) ) = 1;
gammaTrain(2, (modeTrain == 2) ) = 1;

gammaVal = zeros(K,N); %KxN matrix
gammaVal(1, (modeVal == 1) ) = 1;
gammaVal(2, (modeVal == 2) ) = 1;

gammaTest = zeros(K,N); %KxN matrix
gammaTest(1, (modeTest == 1) ) = 1;
gammaTest(2, (modeTest == 2) ) = 1;

end
% 
% figure(1); clf;
% plot(1:N,gammaTrain,'-..')
% 
% figure(2); clf;
% plot(1:N,gammaVal,'-..')
% 
% figure(3); clf;
% plot(1:N,gammaTest,'-..')

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