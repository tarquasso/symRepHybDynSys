function generateContinuousHysteresisLoop()

%Number of Modes:
K = 2;
name = 'continuousHysteresisLoop';
%% Generate Validation Set
transitions = 40; %number of transitions

N = 2051+2045; %number of smaples

ufwd = linspace(-1,1,N/transitions); %generate equally spaced data set
ubwd = flip(ufwd); % flip the data set
u = repmat([ufwd,ubwd],1,transitions/2);

N = length(u);
m = zeros(1,N+1);
m(1) = 1;
y = zeros(size(u));

for i=1:N
y(i) = behaviour(u(i),m(i));  
m(i+1) = modeTransition(u(i),m(i));
end
m=m(1,1:end-1);

transitionsTest = sum(abs(diff(m)));
assert(transitionsTest == transitions,'not the amount of designed transitions');

figure(1); clf;
plot(u,y,'.')
hold on
plot(u,m,'ro')
title('Training Data')

newFilename = [name,'_val.mat'];
save(newFilename,'m','u','y','K');

%% Generate Training Data: Add noise to u values
multi = 1/100;
rng(1)
u = multi*randn(1,N)+u;
figure(2); clf;
plot(u,y,'.')
hold on
plot(u,m,'ro')
title('Validation Data')

newFilename = [name,'_train.mat'];
save(newFilename,'m','u','y','K');

%% Generate Test data: u values in different range
transitions = 34;
N = 4100;

ufwd = linspace(-1.0,1.0,N/transitions); %generate sinusoid wave
ubwd = flip(ufwd);
u = repmat([ufwd,ubwd],1,transitions/2);

N = length(u);
m = zeros(1,N+1);
m(1) = 1;
y = zeros(size(u));

for i=1:N
y(i) = behaviour(u(i),m(i));  
m(i+1) = modeTransition(u(i),m(i));
end
m=m(1,1:end-1);

figure(3); clf;
plot(u,y,'.')
hold on
plot(u,m,'ko')
title('Test Data')
transitionsTest = sum(abs(diff(m)));
assert(transitionsTest == transitions,'not the amount of designed transitions');


newFilename = [name,'_test.mat'];
save(newFilename,'m','u','y','K');

end

function newmode = modeTransition(u,mode)
if(mode == 1)
  if(u > 0.98)
    newmode = 2;
  else
    newmode = 1;
  end
else %mode == 2
  if(u < -0.98)
    newmode = 1;
  else
    newmode = 2;
  end
end
end

function [ynew] = behaviour(u,mode)
if(mode == 1)
    ynew = 0.5*u^2+u-0.5;
else %mode == 2
    ynew = -0.5*u^2+u+0.5;
end
end
