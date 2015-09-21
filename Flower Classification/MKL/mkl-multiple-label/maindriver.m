load USPS.mat

%%% prepare the kernel set for training
clear G_tr G_te;
k = length(G);  % number of base kernels
for i=1:k
    G_tr{i} = G{i}(indexTr, indexTr);
    G_te{i} = G{i}(indexTe, indexTr);
end
Y_tr = Y(indexTr, :);
Y_te = Y(indexTe, :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Selecting the SAME Kernel Accross different Labels %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear param;

% force mosek output information, comment the following line if require no output
param.mosek=1; 
param.C = 10;  % set the SVM trade-off parameter
model = SILP_1norm_same(G_tr, Y_tr, param);
disp('the kernel weights are');
disp(model.mu);

[pred, score] = predictscores(G_te, Y_te, Y_tr, model);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Allow the labels to share the kernels PARTIALly %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear param
% force mosek output information, comment the following line if require no output
param.mosek=1; 

param.C = 10;
param.c1 = 0.5; % share 50% of kernels
model = SILP_1norm_partial(G_tr, Y_tr, param);
disp('the Shared kernel weights are');
disp(model.mu);
disp('the specific kernel weights are');
disp(model.gamma);

[pred, score] = predictscores(G_te, Y_te, Y_tr, model);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Selecting  Kernels INDEPENDENTly Accross different Labels %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear param;

param.C = 10;  % set the SVM trade-off parameter
model = SILP_1norm_independent(G_tr, Y_tr, param);
disp('the kernel weights are');
disp(model.gamma);

[pred, score] = predictscores(G_te, Y_te, Y_tr, model);


disp('Program runs successfully!!');

