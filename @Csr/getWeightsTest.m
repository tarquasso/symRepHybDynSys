function  gamma_k = getWeightsTest(obj,k)

if nargin < 2
    k = obj.k_current;
end

if strcmpi('all',k)
    k =  ':';
end

gamma_k = obj.gamma_test(k,:);

end

