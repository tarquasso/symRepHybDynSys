function parsingSimDatProject()

global generatePlot

dataSetFolder = 'set1';
subset = 'A';
dataSetName = [dataSetFolder,subset];
name = 'syntheticPaddleData';
filename = [dataSetFolder,'/',name];
filenameWithExtension = [filename,'.mat'];
load(filenameWithExtension);

[pathstr,name,ext] = fileparts(filenameWithExtension);
newFilename = [filename,'_preprocessed.mat'];

angleDeg = 36; % tilt of incline in degrees
mdisc = 0.131; %kg mass of disc
spread=0.29;


discRadius = 0.044230;

generatePlot = true;

%Truncate data (remove last just contact part)
tf = 2.135;
tf = 1.765;
idxUsed = find(t < tf);
%number of samples
numberOfSamples = length(idxUsed);
timeStepsTrimmed = t(idxUsed);
xTrimmed = x(:,idxUsed);

zTouch = discRadius; %touchpoint is measured based on the center of the disc


%% Plot the data Before Defining
if(generatePlot)
  
  touchPoint = discRadius;
  staticSpringStrectchingPoint = discRadius;
  
  yLabels = { 'angle theta[rad]',...
    'horizontal coordinate x [m]',...
    'height coordinate z [m]'};
  titleLabels = {'Sim Data Theta',...
    'Sim Data X',...
    'Sim Data Z'};
  for i = 1:3 %only plot z axis
    figure(i); clf;
    plot(timeStepsTrimmed,xTrimmed(i+1,:),'-.ob');
    hold on; xlabel('time [s]');
    if(i == 3) %for z axis
      plot(timeStepsTrimmed(1,[1,end]),[touchPoint,touchPoint],'g','LineWidth',2)
      plot(timeStepsTrimmed(1,[1,end]),[staticSpringStrectchingPoint,staticSpringStrectchingPoint],'y','LineWidth',2)
    end
    
    ylabel(yLabels{i}); title(titleLabels{i})
  end
end

% %Adjust Time Range and remove one error
% indicesExperiment = find( timeStepsOrig > expStartTime & ...
%   timeStepsOrig < expEndTime & ...
%   (timeStepsOrig < errStartTime |...
%   timeStepsOrig > errEndTime));
%
% % adding first and last element to it - needed for data fitting
% indicesExperiment = [indicesExperiment(1)-1;indicesExperiment;indicesExperiment(end)+1];

%extract time and subtract start value
timeSteps = timeStepsTrimmed-timeStepsTrimmed(1);
%
%% Plot the data After Defining
if(generatePlot)
  yLabels2 = { 'angle theta[rad]',...
    'horizontal coordinate x [m]',...
    'height coordinate z [m]'};
  titleLabels2 = {'Sim Data Theta',...
    'Sim Data X',...
    'Sim Data Z'};
  
  for i = 1:3
    figure(i+10); clf;
    plot(timeSteps,xTrimmed(i+1,:),'-.or','LineWidth',0.6); hold on; xlabel('time [s]');
    ylabel(yLabels2{i}); title(titleLabels2{i})
    if(i == 3) %for z axis
      plot(timeSteps([1,end]),[zTouch,zTouch],'g','LineWidth',2)
    end
    title([titleLabels2{i},' (',dataSetName,')'])
    options.Format = 'eps';
    hgexport(gcf,['plots/',dataSetName,'_',titleLabels2{i},'.eps'],options);
  end

end

%% Get acceleration

dt = gradient(timeSteps);
dt1 = diff(timeSteps);
dt1 = [dt1(1),dt1];
figure(87); clf;
plot(dt1,'r.')
hold on
plot(dt,'b.')
title('delta time')

%xdTrimmed = gradient(xTrimmed)./dt;
xdTrimmed = gradient(xTrimmed)./dt;
xdTrimmed1 = diff(xTrimmed,1,2);
xdTrimmed1 = [xdTrimmed1(:,1),xdTrimmed1];
xdTrimmed1 = xdTrimmed1./dt;
if(generatePlot)
figure(88); clf;
plot(xTrimmed(5,:),'r.')
hold on
plot(xdTrimmed(2,:),'b.')
plot(xdTrimmed1(2,:),'g.')
legend('original','gradient')
figure(89); clf;
plot((xTrimmed(1,:)-1)*300,'r-.*')
hold on
plot(xdTrimmed(5,:),'b-.o')
plot(xdTrimmed1(5,:),'g-.+')
legend('mode','gradient','diff')
title('comparing diff with gradient')
end
%% Extract each contact and each no_contact phase

%% Separate flight and contact
modeNC = 1;
modeIC = 2;
idxNC = find (xTrimmed(1,:) == modeNC);
idxIC = find (xTrimmed(1,:) == modeIC);

timeStepsSplitNC = timeSteps(idxNC);
timeStepsSplitIC = timeSteps(idxIC);
xTrimmedNC = xTrimmed(:,idxNC);
xTrimmedIC = xTrimmed(:,idxIC);


if(generatePlot)
  %Add a line to the z coordinate
  figure(21); clf; hold on
  plot(timeSteps,xTrimmed(4,:),'g','LineWidth',1.0);
  plot(timeStepsSplitNC,xTrimmedNC(4,:),'b.','LineWidth',2.0)
  plot(timeSteps([1,end]),[zTouch,zTouch],'g','LineWidth',2)
  plot(timeStepsSplitIC,xTrimmedIC(4,:),'r.','LineWidth',2.0)
  xlabel('time [s]')
  %axis([-inf inf minHeight maxHeight])
  title(['Height z - Unseparated (',dataSetName,')'])
  typeofPlot = 'z';
  options.Format = 'eps';
  hgexport(gcf,['plots/',dataSetName,'_',typeofPlot,'.eps'],options);
end

%%
if(generatePlot)
  
  figure(22); clf; hold on
  plot(timeStepsSplitNC,xTrimmedNC(4,:),'g.','LineWidth',3.0)
  plot(timeSteps(1,[1,end]),[zTouch,zTouch],'g','LineWidth',1.5)
  plot(timeStepsSplitIC,xTrimmedIC(4,:),'r.','LineWidth',3.0)
  %axis([-inf inf minHeight maxHeight])
  title(['Height z - Separated (',dataSetName,')'])
  xlabel('time [s]')
  ylabel('z')
  
  figure(23);clf; hold on;
  xlabel('time [s]')
  ylabel('zd')
  title(['Velocity zd',' (',dataSetName,')'])
  
  figure(24);clf; hold on;
  xlabel('time [s]')
  ylabel('zdd')
  title(['Acceleration zdd',' (',dataSetName,')'])
  
  
  figure(32); clf; hold on
  plot(timeStepsSplitNC,xTrimmedNC(2,:),'g.','LineWidth',3.0)
  plot(timeStepsSplitIC,xTrimmedIC(2,:),'r.','LineWidth',3.0)
  %axis([-inf inf minHeight maxHeight])
  title(['Theta - Separated (',dataSetName,')'])
  xlabel('time [s]')
  ylabel('Angle theta')
  
  figure(33);clf; hold on;
  xlabel('time [s]')
  ylabel('thetad')
  title(['Angular Velocity thetad',' (',dataSetName,')'])
  
  figure(34);clf; hold on;
  xlabel('time [s]')
  ylabel('thetadd')
  title(['Angular Acceleration thetadd',' (',dataSetName,')'])
  
  figure(42); clf; hold on
  plot(timeStepsSplitNC,xTrimmedNC(3,:),'g.','LineWidth',3.0)
  plot(timeStepsSplitIC,xTrimmedIC(3,:),'r.','LineWidth',3.0)
  %axis([-inf inf minHeight maxHeight])
  title(['X - Separated (',dataSetName,')'])
  xlabel('time [s]')
  ylabel('Pos x')
  
  figure(43);clf; hold on;
  xlabel('time [s]')
  ylabel('xd')
  title(['Velocity xd',' (',dataSetName,')'])
  
  figure(44);clf; hold on;
  xlabel('time [s]')
  ylabel('xdd')
  title(['Acceleration xdd',' (',dataSetName,')'])
end

typeNC = 'NoSplit';
minDataPointsNC = 5;
[numOfSetsNC,timeStepsSplitNC,xTrimmedSplitNC,xdTrimmedSplitNC] = extractSetsSim(idxNC,timeSteps,xTrimmed,xdTrimmed,minDataPointsNC,typeNC);

typeIC = 'NoSplit';
minDataPointsIC = 5;
[numOfSetsIC,timeStepsSplitIC,xTrimmedSplitIC,xdTrimmedSplitIC] = extractSetsSim(idxIC,timeSteps,xTrimmed,xdTrimmed,minDataPointsIC,typeIC);


[timeStepsNC,thetaNC,thetadNC,thetaddNC,xNC,xdNC,xddNC,zNC,zdNC,zddNC] = ...
  extractIndividualStates(numOfSetsNC,timeStepsSplitNC, xTrimmedSplitNC,xdTrimmedSplitNC);

[timeStepsIC,thetaIC,thetadIC,thetaddIC,xIC,xdIC,xddIC,zIC,zdIC,zddIC] = ...
  extractIndividualStates(numOfSetsIC,timeStepsSplitIC, xTrimmedSplitIC,xdTrimmedSplitIC);

 save(newFilename,'angleDeg','mdisc','spread','zTouch',...
   'timeStepsNC','thetaNC','thetadNC','thetaddNC','xNC','xdNC','xddNC','zNC','zdNC','zddNC',...
   'timeStepsIC','thetaIC','thetadIC','thetaddIC','xIC','xdIC','xddIC','zIC','zdIC','zddIC');

end

function [numOfSetsNew,timeStepsSplit,xTrimmedSplit,xdTrimmedSplit] = extractSetsSim(idxMode,timeSteps, xTrimmed,xdTrimmed,minDataPoints,type)
global generatePlot
%% Define points when in contact and points when not in contact
boolTransitions = diff(idxMode)> 1;
%last step shortens it by one value, so for the start points, add 1 logical in front:
boolTransitionsStarts = [true,boolTransitions];
idxStart =  idxMode(boolTransitionsStarts);
boolTransitionsEnds = [boolTransitions,true];
idxEnd = idxMode(boolTransitionsEnds);

numOfSets = length(idxEnd);%sum(boolTransitionsStarts);

if(strcmp(type,'Split')) % no contact
  
  idxStartNew = [];
  idxEndNew = [];
  for l = 1:numOfSets
    idxCheck = (idxStart(l)):(idxEnd(l));
    zDataRelevant = xTrimmed(idxCheck,4);
    
    [~,I] = max(zDataRelevant);
    
    if(I==1)
      idxEndNew = [idxEndNew,idxEnd(l)];
      idxStartNew = [idxStartNew,idxStart(l)];
    else
      idxEndNew = [idxEndNew,idxCheck(I),idxEnd(l)];
      idxStartNew = [idxStartNew,idxStart(l),idxCheck(I)];
      
    end
  end
  
else
  idxStartNew = idxStart;
  idxEndNew = idxEnd;
end

%Remove last sets if contain to little data:
keepGoing = true;
while(keepGoing)
  if (idxEndNew(end)-idxStartNew(end)<minDataPoints) %+1 so it accounts for the apex point we do not account for
    %remove the last data set:
    idxStartNew = idxStartNew(1:end-1);
    idxEndNew = idxEndNew(1:end-1);
  else
    keepGoing = false;
  end
end

numOfSetsNew = length(idxEndNew);%sum(boolTransitionsStarts);

idxExtended = cell(numOfSetsNew,1);
timeStepsSplit = cell(numOfSetsNew,1);
xTrimmedSplit = cell(numOfSetsNew,1);
xdTrimmedSplit = cell(numOfSetsNew,1);


for j = 1:numOfSetsNew
  idxExtended{j} = idxStartNew(j):idxEndNew(j);
  timeStepsSplit{j} = timeSteps(idxExtended{j});
  xTrimmedSplit{j} = xTrimmed(:,idxExtended{j});
  xdTrimmedSplit{j} = xdTrimmed(:,idxExtended{j});
  
  if(generatePlot)
    figure(22);
    plot(timeStepsSplit{j}(1),xTrimmedSplit{j}(4,1),'m*','LineWidth',4.5)
    plot(timeStepsSplit{j}(end),xTrimmedSplit{j}(4,end),'k*','LineWidth',4.5)
  end
end

end

function [timeStepsMode,thetaMode,thetadMode,thetaddMode,...
  xMode,xdMode,xddMode,zMode,zdMode,zddMode] = ...
  extractIndividualStates(numOfSetsMode,timeStepsSplitMode, xTrimmedSplitMode,xdTrimmedSplitMode)
global generatePlot

timeStepsMode = cell(numOfSetsMode,1);

dtMode = cell(numOfSetsMode,1);

thetaMode= cell(numOfSetsMode,1);
thetadMode = cell(numOfSetsMode,1);
thetaddMode = cell(numOfSetsMode,1);

xMode= cell(numOfSetsMode,1);
xdMode = cell(numOfSetsMode,1);
xddMode = cell(numOfSetsMode,1);

zMode= cell(numOfSetsMode,1);
zdMode = cell(numOfSetsMode,1);
zddMode = cell(numOfSetsMode,1);

for j = 1: numOfSetsMode
  timeStepsMode{j} = timeStepsSplitMode{j}';
  % dtMode{j} = gradient(timeStepsSplitMode{j}');
  
  thetaMode{j} = xTrimmedSplitMode{j}(2,:)';
  thetadMode{j} = xTrimmedSplitMode{j}(5,:)';
  thetaddMode{j} = xdTrimmedSplitMode{j}(5,:)';
  % thetaddMode{j} = gradient(xTrimmedSplitMode{j}(5,1:end)')./dtMode{j};
  
  xMode{j} = xTrimmedSplitMode{j}(3,:)';
  xdMode{j} = xTrimmedSplitMode{j}(6,:)';
  xddMode{j} = xdTrimmedSplitMode{j}(6,:)';
  % xddMode{j} = gradient(xTrimmedSplitMode{j}(6,:)')./dtMode{j};
  
  zMode{j} = xTrimmedSplitMode{j}(4,:)';
  zdMode{j} = xTrimmedSplitMode{j}(7,:)';
  zddMode{j} = xdTrimmedSplitMode{j}(7,:)';
  % zddMode{j} = gradient(xTrimmedSplitMode{j}(7,:)')./dtMode{j};
  
  if(generatePlot)
    figure(22);
    p1 = plot(timeStepsSplitMode{j}',zMode{j},'-.ob');
    p1(1).LineWidth = 1;
    
    figure(23)
    p2 = plot(timeStepsSplitMode{j}',zdMode{j},'-.ob');
    p2(1).LineWidth = 1;
    
    figure(24)
    p3 = plot(timeStepsSplitMode{j}',zddMode{j},'-.ob');
    p3(1).LineWidth = 1;
    
    figure(32);
    p1 = plot(timeStepsSplitMode{j}',thetaMode{j},'-.ob');
    p1(1).LineWidth = 1;
    
    figure(33)
    p2 = plot(timeStepsSplitMode{j}',thetadMode{j},'-.ob');
    p2(1).LineWidth = 1;
    
    figure(34)
    p3 = plot(timeStepsSplitMode{j}',thetaddMode{j},'-.ob');
    p3(1).LineWidth = 1;
    
    figure(42);
    p1 = plot(timeStepsSplitMode{j}',xMode{j},'-.ob');
    p1(1).LineWidth = 1;
    
    figure(43)
    p2 = plot(timeStepsSplitMode{j}',xdMode{j},'-.ob');
    p2(1).LineWidth = 1;
    
    figure(44)
    p3 = plot(timeStepsSplitMode{j}',xddMode{j},'-.ob');
    p3(1).LineWidth = 1;
  end
end
end
