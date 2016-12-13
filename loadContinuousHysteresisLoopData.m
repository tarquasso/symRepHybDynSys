function [dataTrain,dataVal,dataTest] = loadContinuousHysteresisLoopData()
location = 'Data/ContinuousHysteresisLoop/';
name = 'continuousHysteresisLoop';
filename = [location,'/',name];

% Training Data Set has noise added on the u values
newFilenameCombined = [filename,'_train.mat'];
dataTrain = load(newFilenameCombined);

% Validation Data Set has no noise added on the u values
newFilenameCombined = [filename,'_val.mat'];
dataVal = load(newFilenameCombined);

% Test Data Set has u values in the range from -1.5 to 1.5
newFilenameCombined = [filename,'_test.mat'];
dataTest = load(newFilenameCombined);

end