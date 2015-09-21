function [pred, score] = predictscores(G_te, Y_te, Y_tr, model)
% Compute the prediction scores based on the learned model
% The instances with positive scores should be classified as positive (+1), otherwise negative (-1);
% Input: 
    
% Output: 
    
      
  mu = model.mu;
  gamma = model.gamma;
  alpha = model.alpha;
  bias = model.bias;

  [n,k] = size(Y_te);
  p = length(G_te);
  weight = calculate_weight(mu, gamma, k);
 
  score = zeros(n,k);
  for i=1:k
    G=0;
    
    for j=1:p
        G=G+G_te{j}*weight(j,i);
    end
    score(:,i) = G*(Y_tr(:,i).*alpha(:,i))+repmat(bias(i), n, 1);
  end
  clear G_te G;
  
  pred = sign(score);