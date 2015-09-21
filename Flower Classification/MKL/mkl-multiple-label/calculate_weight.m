function [ weight ] = calculate_weight(mu, gamma, k)
%%% calculate the weight of kernels for each task    
  
if size(mu,1) == 1
    weight = gamma;
elseif size(gamma,1) ==1
    weight = repmat(mu,1,k);
else
    weight = repmat(mu,1,k)+gamma;
end
