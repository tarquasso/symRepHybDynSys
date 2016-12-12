% top level file for transition modelling
% input:
%   weights gamma
%   the number of subfunctions - K
% output: 
%   transitions for each mode - t_k-k'

function [transitions,var] = runTM(tmObj,gamma,K)

% making sure we don't run the TM algorithm multiple times at the same time
errorMsg = 'You cannot initialize the TM-algorithm twice! Aborting';
assert(tmObj.runningTM == false,errorMsg);
tmObj.runningTM = true;


% for each mode k in K modes :
for k = 1:tmObj.K
    obj.k_current = k;
    % for each different mode k′ in K − 1 modes :
    % rebalance the PTP and NTP weights (Equation 13-16)
    % tm_solutions = symbolic_regression(Equation 17, Equation 18)
    % for each solution in tm_solutions :
       % compute AIC score using transition fitness (Equation 8)
    % set transition t k→k ′ (u n ) to solution with lowest AIC score in tm_solutions
%return transitions t k→k ′ (u n )


% algorithm finished
tmObj.runningTM = false;

end