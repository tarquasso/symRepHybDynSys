function generateHysteresisRelay()

K = 2;
name = 'hysteresisRelayShort';

%% Generate Validation Set
transitions = 2;
N = 10;

ufwd = linspace(-2,2,N/transitions); %generate equally spaced data set
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
transitions = 2;
N = 10;

ufwd = linspace(-1.5,1.5,N/transitions); %generate sinusoid wave
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
  if(u > 0.5)
    newmode = 2;
  else
    newmode = 1;
  end
else %mode == 2
  if(u < -0.5)
    newmode = 1;
  else
    newmode = 2;
  end
end
end

function [ynew] = behaviour(u,mode)
if(mode == 1)
    ynew = 1;
else %mode == 2
    ynew = -1;
end
end
