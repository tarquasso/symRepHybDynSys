% top level file for transition modelling
% input:
%   weights gamma
%   the number of subfunctions - K
% output: 
%   transitions for each mode - t_k-k'

function [transitions,var] = runTM(obj)

% making sure we don't run the EM algorithm without initialization
errorMsg = 'You cannot start the EM-algorithm without initialization! Aborting';
assert(obj.initiated == true,errorMsg);

% making sure we don't run the TM algorithm multiple times at the same time
errorMsg = 'You cannot initialize the TM-algorithm twice! Aborting';
assert(obj.runningTM == false,errorMsg);
obj.runningTM = true;

allKs = 1:obj.K;
% for each mode k in K modes :
for k = allKs
  obj.k_current = k;
  
  % for each different mode k′ in K − 1 modes :
  subsetOfKs = allKs(allKs~=k);
  for ksub = subsetOfKs
    % rebalance the PTP and NTP weights (Equation 13-16)
    obj.rebalancePTPNTP(ksub);
    % tm_solutions = symbolic_regression(Equation 17, Equation 18)
    % for each solution in tm_solutions :
    % compute AIC score using transition fitness (Equation 8)
    % set transition t k→k ′ (u n ) to solution with lowest AIC score in tm_solutions
  end
  
  %return transitions t k→k ′ (u n )
end

% algorithm finished
obj.runningTM = false;
obj.initiated = false;


end