function generateHysteresisRelay()
transitions = 66;
N = 2037+2059;
ufwd = linspace(-2,2,N/transitions); %generate sinusoid wave
ubwd = flip(ufwd);
u = repmat([ufwd,ubwd],1,transitions/2);
N = length(u);
m = zeros(size(u));
m(1) = 1;
y = zeros(size(u));
y(1) = modeTransition(u(1),1);
for i=2:N
m(i) = modeTransition(u(i),m(i-1));
y(i) = behaviour(u(i),m(i));  
end

figure(1); clf;
plot(u,y,'.')
hold on
plot(u,m,'ro')
transitions = sum(abs(diff(m)));

newFilename = 'hysteresisRelay_val.mat';
save(newFilename,'m','u','y');



u = randn(1,N)/50+u;
figure(2); clf;
plot(u,y,'.')
hold on
plot(u,m,'ro')

newFilename = 'hysteresisRelay_train.mat';
save(newFilename,'m','u','y');
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
