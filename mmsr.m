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

% csrObj = Csr.getInstance();
% [functions,variances,gamma] = csrObj.runEM(obj,u,y,K);


%% Generate Gamma:
gamma = zeros(K,N); %KxN matrix

idxMode1 = (modeTrain ==1);
gamma(1,idxMode1) = 1;

idxMode2 = (modeTrain == 2);
gamma(2,idxMode2) = 1;

figure;
plot(1:N,gamma,'-..')

%% Set up Init File
init.x_train = xTrain;
init.y_train = gammaTrain; % seprate it out in runTM

init.x_val = xVal;
init.y_val = gammaVal;

init.x_test = xTest;
init.y_test = gammaTest;

init.K = K;


tmObj = Tm.getInstance();


tmObj.initiateTm(initTm);

return
%%
tmObj.in
[transitions] = tmObj.runTM(gamma,K);