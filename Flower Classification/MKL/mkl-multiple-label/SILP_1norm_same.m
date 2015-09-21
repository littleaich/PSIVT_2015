function [model, trace] = SILP_1norm_same(G, Y, param)
% [model, trace] = SILP_1norm_same(G, Y, param) 
% select the SAME kernel for all the tasks
%
% [model, trace] = SILP_1norm_partial(G, Y, param)
% Input:    G: an array of kernel matrix
%           Y: the +1/-1 class label for each task
% param:    C: the trade-off parameter of SVM
%           tolerance: the parameter to determine the stopping criteria
% model:    mu: shared kernel coefficient
%           alpha: the dual variables of SVM
%           bias: the bias term of SVM
%           mu_trace: if trace is true, the mu_trace is returned
%           iter:  number of iterations to get the final solution
%           res: the solution
%
% Code is provided by Lei Tang, July 29th, 2009.
%

C = param.C;

if ~isfield(param, 'mosek')
    param.mosek = 0; % hide mosek ouptput
end

if isfield(param, 'trace_flag')
  trace_flag = param.trace_flag;
else
  trace_flag = false;
end

if isfield(param, 'trace_step')
  trace_step = param.trace_step;
else
  trace_step = 10;
end

if isfield(param, 'tolerance')
  tolerance = param.tolerance;
else
  tolerance = 10^-5;
end

trace.mu_trace = [];
trace.theta_trace = [];
trace.theta_compute = [];
trace.theta_sum_trace = [];
trace.obj = [];


%%% number of instances and number of tasks
[n,k] = size(Y);

% number of kernels
p = length(G);


%%% kernel coefficients initialization
mu = ones(p,1)/p;

%%% initialize the LP problem set up.

num_var = k+p;  % theta_1, ... theta_k, mu_1,... mu_p,
theta_start = 0;
mu_start = k;
num_theta = k;
num_mu = p;


clear prob;
%%% minimize theta_1 + ... + theta_k
prob.c = sparse(num_var,1);
prob.c(1:k) = 1;

% sum mu_i r_i = c1, sum gamma_i^t r_i = c2;
num_con = 1;
prob.blc = zeros(num_con,1);
prob.buc = zeros(num_con,1);

prob.blc(1) = 1;
prob.buc(1) = 1;


prob.a = sparse(num_con, num_var);
prob.a(1, mu_start+1:mu_start+p) = 1;


prob.blx = sparse(num_var,1);
prob.blx(1:num_theta) = -inf;
prob.bux = [];  % no upper bound

sum_theta = 0;
stop = false;
iter = 0;

%%%
while (stop ~= true && iter < 1000)
    iter  = iter + 1;
    %%% calculate the kernel combination for all tasks
    clear K1 parameter;
    kernel_opt = zeros(n,n);
    for j=1:p
        kernel_opt = kernel_opt+G{j}*mu(j);
    end
    K1 = [(1:n)', kernel_opt];
    parameter = sprintf('-c %d -t 4', C);  % the parameter for libsvm to use predefined kernel matrix
    theta = zeros(k,1);
    
    for i=1:k
        % solve SVM with fixed coefficients for each task, get alpha^t
        
        model = svmtrain(Y(:,i), K1, parameter);
        
        alpha = sparse(n,1);
        alpha(model.SVs) = model.sv_coef;  % get the alpha

        sum_alpha = abs(sum(alpha.*Y(:,i))); %%% calculate alpha* e notice that libsvm might switch the label of +1/-1

        theta(i) = sum_alpha - alpha'*kernel_opt*alpha/2;

        % a row of S_alpha
        S_alpha = zeros(1,p);
        for j=1:p
            S_alpha (j) = sum_alpha - alpha'*G{j}*alpha/2;
        end

        % add the linear constraints
        num_con = num_con+1; % increase the number of linear constraints
        prob.a(num_con,theta_start+i) = -1;
        prob.a(num_con,mu_start+1: mu_start+ num_mu) = S_alpha;

        prob.buc(num_con) = 0;
        prob.blc(num_con) = -inf;
    end

    %sum(theta)
    
    %%% check whether we obtain a larger sum_t theta_t
    if sum(theta) < sum_theta + tolerance
        break;
    end
    

    %%% solve the LP problem using mosek
    if param.mosek==0
        [r_code,res] = mosekopt('minimize echo(0)',prob); 
    else
        [r_code,res] = mosekopt('minimize',prob); 
    end
    
    % obtain the weights
    sum_theta = sum(res.sol.itr.xx(1:k)); % the objective value
    mu = res.sol.itr.xx(mu_start+1: mu_start+num_mu);
    if (trace_flag == true && mod(iter, trace_step)==0)
        trace.mu_trace = [trace.mu_trace mu];
        trace.theta_trace = [trace.theta_trace theta];
        trace.theta_compute = [trace.theta_compute res.sol.itr.xx(1:k)];
        trace.theta_sum_trace = [trace.theta_sum_trace sum(theta)];
        trace.obj  = [trace.obj sum_theta];
    end
    %%%
end

%%% calcluate alpha, bias given fixed kernel matrix
alpha_to_return = sparse(n,k);
bias_to_return = zeros(k,1);

kernel_opt = zeros(n,n);
for j=1:p
    kernel_opt = kernel_opt+G{j}*mu(j);
end

for i=1:k
    % solve SVM with fixed coefficients for each task, get alpha^t
    K1 = [(1:n)', kernel_opt];
    parameter = sprintf('-c %d -t 4', C);
    model = svmtrain(Y(:,i), K1, parameter);
    clear K1 parameter;
    alpha = sparse(n,1);
    alpha(model.SVs) = model.sv_coef;  % get the alpha
    bias = model.rho;
    if model.Label(1) == 1
        bias = -bias;  % in libsvm, y=wx-b. 
    end
    alpha_to_return(:,i) = abs(alpha);
    bias_to_return(i) = bias;
end

clear model;
model.gamma = 0;
model.mu = mu;
model.alpha = alpha_to_return;
model.bias = bias_to_return;
model.iter = iter;
