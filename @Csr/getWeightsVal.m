function  gamma_k = getWeightsVal(obj,k)

if nargin < 2
    k = obj.k_current;
end

if strcmpi('all',k)
    k =  ':';
end

gamma_k = obj.gamma_val(k,:);

end

