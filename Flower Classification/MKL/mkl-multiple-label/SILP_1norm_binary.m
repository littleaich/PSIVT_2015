function [gamma, alpha, bias, iter, trace] = SILP_1norm_binary (G, y, C, tolerance, trace_flag, trace_step)
% A function to use SILP to solve kernel learning in binary SVM with fixed C
% function [gamma, alpha, bias, iter, trace] = SILP_1norm_binary (G, y, C, tolerance, trace_flag, trace_step)
% Input
%   G: a cell array of kernel matrix
%   y: the class  label
%   C: regularization parameter
%   tolerance: the parameter to specify the stopping critier (default: 10^-5)
%   trace_flag: whether or not trace the output in each iteration (default: false)
%   trace_step: the step to trace (default: 10)
%
%Output
%   gamma: kernel coefficients vector
%   alpha: the dual vars in the resultant 1norm SVM
%   bias: bias of 1norm SVM
%   iter: number of iterations to achieve optimal
%   trace: the trace of output in different iterations
%
% Code is provided by Lei Tang, July 17th, 2007.

c1=1;
if nargin < 6
    trace_step = 10;
end

if nargin < 5
    trace_flag = false;
end

if (nargin < 4)
    tolerance = 0.00001;
end

p= length(G);
n= length(y);
trace.theta_trace = [];
trace.gamma_trace = [];
trace.obj = [];
%% kernel coefficients initialization
gamma = ones(p, 1)/p; % each column corresponds to one task.

%% initialize the LP problem set up.

num_var = 1+p;   % theta, gamma_1, gamma_2, ..., gamma_p
gamma_start = 1; % start from start+1 -> start+p

clear prob;
%% minimize theta_1 + ... + theta_k
prob.c = sparse(num_var,1);
prob.c(1) = 1;

% sum mu_i r_i = c1, sum gamma_i^t r_i = c2;
num_con = 1;
prob.blc = zeros(num_con,1);
prob.buc = zeros(num_con,1);

prob.blc(1) = c1;
prob.buc(1) = c1;

prob.a = sparse(num_con, num_var);
prob.a(1, gamma_start+1:gamma_start+p) = 1;

prob.blx = sparse(num_var,1);
prob.blx(1) = -inf;
prob.bux = [];  % no upper bound

original_theta = 0;
iter = 0;

while  iter < 1000
    iter = iter+1;
    kernel_opt = zeros(n, n);
    for j=1:p
        kernel_opt = kernel_opt+gamma(j)*G{j};
    end

    K1 = [(1:n)', kernel_opt];
    parameter = sprintf('-c %d -t 4', C);
    model = svmtrain(y, K1, parameter);
    clear K1 parameter;
    alpha = sparse(n,1);
    alpha(model.SVs) = model.sv_coef;  % get the alpha

    sum_alpha = abs(sum(alpha.*y)); %% calculate alpha* e notice that libsvm might swithc the label of +1/-1

    theta = sum_alpha - alpha'*kernel_opt*alpha/2; % calculate the violating theta

    if theta < original_theta+tolerance
        break;
    end
    % a row of S_alpha
    S_alpha = zeros(1,p);
    for j=1:p
        S_alpha (j) = sum_alpha - alpha'*G{j}*alpha/2;
    end

    num_con = num_con+1; % increase the number of linear constraints
    prob.a(num_con,1) = -1;
    prob.a(num_con,gamma_start+1: gamma_start+ p) = S_alpha;

    prob.buc(num_con) = 0;
    prob.blc(num_con) = -inf;
    
    
    [r_code,res] = mosekopt('minimize echo(0)',prob); 
    
    original_theta = res.sol.itr.xx(1);
    gamma = res.sol.itr.xx(2:p+1);   
    
    if (trace_flag==true && mod(iter, trace_step) ==0)
        trace.theta_trace =[ trace.theta_trace theta];
        trace.gamma_trace =[ trace.gamma_trace gamma];
        trace.obj = [trace.obj original_theta]; 
    end
end

kernel_opt = zeros(n, n);
for j=1:p
    kernel_opt = kernel_opt+gamma(j)*G{j};
end
    
K1 = [(1:n)', kernel_opt];
parameter = sprintf('-c %d -t 4', C);
model = svmtrain(y, K1, parameter);
clear K1 parameter;
alpha = sparse(n,1);
alpha(model.SVs) = model.sv_coef;  % get the alpha
bias = model.rho;
if model.Label(1) ==1
    bias = -bias;
end
alpha = abs(alpha);


