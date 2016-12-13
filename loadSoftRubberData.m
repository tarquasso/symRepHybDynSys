function [dataTrain,dataVal,dataTest] = loadSoftRubberData()

location = 'Data/capturedData real rubber/';
dataSetFolder = 'set5';

name = '16-May-2015 20_46_41';
filename = [location,dataSetFolder,'/',name];
% subset = 'A';
% dataSetName = [dataSetFolder,subset];
newFilenameCombined = [filename,'_preprocessedcombined.mat'];
dataTrain = load(newFilenameCombined);

name = '16-May-2015 20_48_35';
filename = [location,dataSetFolder,'/',name];
% subset = 'C';
% dataSetName = [dataSetFolder,subset];
newFilenameCombined = [filename,'_preprocessedcombined.mat'];
dataVal = load(newFilenameCombined);


name = '16-May-2015 20_47_41';
filename = [location,dataSetFolder,'/',name];
% subset = 'C';
% dataSetName = [dataSetFolder,subset];
newFilenameCombined = [filename,'_preprocessedcombined.mat'];
dataTest = load(newFilenameCombined);
end