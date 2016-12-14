function  gammatilde_k = getGammaTildeVal(obj,k)

% if no k is provided, return for current k:
if nargin < 2
    k = obj.k_current;
end

%return gamma for given k
gammatilde_k = obj.gammaTilde_val(:,k);

end

