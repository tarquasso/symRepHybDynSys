function [dataTrain,dataVal] = loadHysteresisRelayData()
location = 'Data/HysteresisRelay/';
name = 'hysteresisRelay';
filename = [location,'/',name];
newFilenameCombined = [filename,'_train.mat'];
dataTrain = load(newFilenameCombined);

newFilenameCombined = [filename,'_val.mat'];
dataVal = load(newFilenameCombined);

end