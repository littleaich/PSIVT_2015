% ======================================================================= %
% Name: classifyMKL.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the sixth as well as the last file to extract and 
% test HSV color descriptors from Oxford-102 flower dataset (PSIVT_2015). 
% It tests the accuracy of the system using only HSV color features and 
% multiple kernel learning approach downloaded from this link
% http://leitang.net/code/mkl-multiple-label/README.txt
% The file hierarchy for HSV color features 
% extraction and testing using multiple kernel learning (Oxford-102 
% dataset, PSIVT_2015) is listed as follows: (1) extractColorDescriptors.m,
% (2) makeDesMat.m, (3) makeVisualCodebook_LD.m, (4) makeFeaMat.m, 
% (5) makeSimMat.m, (6) classifyMKL.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc;
restoredefaultpath;

%image_version = 'Images_Segmented_Adjusted';
image_version = 'Images_Min_500';
%image_version = 'Images';
%image_version = 'Images_Org_Min_500';
kernel_mkl = 'same'; % 'same','share','independent'
IGNORE_LOCATION = true;
K = 900; % change
featName = 'hsv'; % change
blockSize = 3;
featName = [featName,'_',num2str(blockSize),'x',num2str(blockSize)];

dataPath = ['../../Databases/Oxford/Features/',image_version,'/']; % inPath

load([dataPath,'SimMat_',num2str(K),'_',featName,'.mat']);

G_tr{1} = simMat{1};
G_te{1} = simMat{2};
G_tr{2} = G_tr{1};
G_te{2} = G_te{1};
clear simMat;

% add paths for multiple kernel learning
addpath(genpath('MKL/libsvm-3.20/'));
addpath(genpath('MKL/mosek/'));
addpath(genpath('MKL/mkl-multiple-label/'));

% label matrix formation
numTrain = length(trainLabel);
numTest = length(testLabel);
numCls = numel(unique(trainLabel));
Y_tr = -1*ones(numTrain,numCls);
Y_te = -1*ones(numTest,numCls);

for i = 1:numTrain
    Y_tr(i,trainLabel(i)) = 1;
end

for i = 1:numTest
    Y_te(i,testLabel(i)) = 1;
end

% similarity matrix formation
% tmpSimMat = pdist(trainData,'cosine'); % cosine dissimilarity
% tmpSimMat = 1 - squareform(tmpSimMat); % sim_cos = 1 - dissim_cos
% G_tr{1} = double(tmpSimMat);
% clear tmpSimMat;
% tmpSimMat = pdist2(testData,trainData,'cosine');
% tmpSimMat = 1-tmpSimMat;
% G_te{1} = double(tmpSimMat);
% clear tmpSimMat;

% ===================== Multiple Kernel Learning ======================== %
if strcmp(kernel_mkl,'same')
    % Selecting the SAME Kernel Accross different Labels
    clear param;
    % force mosek output information, comment the following line if require no output
    param.mosek=1; 
    param.C = 10;  % set the SVM trade-off parameter
    model = SILP_1norm_same(G_tr, Y_tr, param);
    disp('the kernel weights are');
    disp(model.mu);

elseif strcmp(kernel_mkl,'share')
    % Allow the labels to share the kernels PARTIALly
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

elseif strcmp(kernel_mkl,'independent')
    % Selecting  Kernels INDEPENDENTly Accross different Labels
    clear param;

    param.C = 10;  % set the SVM trade-off parameter
    model = SILP_1norm_independent(G_tr, Y_tr, param);
    disp('the kernel weights are');
    disp(model.gamma);

end

[pred, score] = predictscores(G_te, Y_te, Y_tr, model);
[~,y] = max(score,[],2);
acc = (length(y)-numel(find(y-testLabel)))/length(testLabel)*100;
disp(acc);

clear all; close all;