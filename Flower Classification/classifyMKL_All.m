% ======================================================================= %
% Name: classifyMKL_All.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This file calculates the classification accuracy for
% combined features (HSV, SIFT, MSD-SIFT and HOG) on Oxford-102 flower 
% dataset (PSIVT_2015) using multiple kernel learning approach downloaded 
% from this link http://leitang.net/code/mkl-multiple-label/README.txt
% All the similarity matrices must be calculated and saved before executing
% this file to get the combined recognition accuracy.
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc;
restoredefaultpath;
echo off;

image_version = 'Images_Min_500';
%image_version = 'Images_Org_Min_500';
kernel_mkl = 'same'; % 'same','share','independent'
%percent_kernel_share = 0.3; % only for kernel_mkl = 'share' option

count_feat = 0;
dataPath = ['../../Databases/Oxford/Features/',image_version,'/']; % inPath

% ========================= SURF Parameters ============================= %
% disp('SURF data extraction started ...');
% featName = 'surf';
% surfSize = 128;
% blockSize = 5;
% scale = 1.6; 
% spacing = 5;
% K = 3000;
% 
% featName = [featName,num2str(surfSize),'_',num2str(blockSize),'_sc_', ...
%     num2str(scale),'_spc_',num2str(spacing)];
% 
% load([dataPath,'SimMat_',num2str(K),'_',featName,'.mat']);
% 
% count_feat = count_feat + 1;
% G_tr{count_feat} = simMat{1};
% G_te{count_feat} = simMat{2};
% clear simMat;
% ======================================================================= %

% ========================= HSV Parameters ============================== %
disp('HSV data extraction started ...');
IGNORE_LOCATION = true;
K = 900; % change
featName = 'hsv'; % change
blockSize = 3;

featName = [featName,'_',num2str(blockSize),'x',num2str(blockSize)];

load([dataPath,'SimMat_',num2str(K),'_',featName,'.mat']);

count_feat = count_feat + 1;
G_tr{count_feat} = simMat{1};
G_te{count_feat} = simMat{2};
clear simMat;
% ======================================================================= %

% ======================== HOG2D Parameters ============================= %
disp('HOG2D data extraction started ...');
featName = 'hog2D';
cellSize = 8; % default
blockSize = 2; % default
numBins = 9; % default
blockLap = 0;
K = 1500;

featName = [featName,'_',num2str(cellSize),'x',num2str(cellSize),'_', ...
    num2str(blockSize),'x',num2str(blockSize),'_bin_',num2str(numBins)];

load([dataPath,'SimMat_',num2str(K),'_',featName,'.mat']);
% load([dataPath,'Data_',num2str(K),'_',featName,'.mat']);
% clear trainData testData;

count_feat = count_feat + 1;
G_tr{count_feat} = simMat{1};
G_te{count_feat} = simMat{2};
clear simMat;
% ======================================================================= %

% ========================= SIFT Parameters ============================= %
disp('SIFT data extraction started ...');
featName = 'sift';
radius = 5; % for internal sift
spacing = 5; % both internal and boundary sift
K = 3000;

featName = [featName,'_rad_',num2str(radius),'_spc_',num2str(spacing)];

load([dataPath,'SimMat_',num2str(K),'_',featName,'.mat']);
% load([dataPath,'Data_',num2str(K),'_',featName,'.mat']);
% clear trainData testData;

count_feat = count_feat + 1;
G_tr{count_feat} = simMat{1};
G_te{count_feat} = simMat{2};
clear simMat;
% ======================================================================= %

% ======================== MsdSIFT Parameters =========================== %
disp('MsdSIFT data extraction started ...');
featName = 'msdsift';
stepSize = 5; 
mag = 6;
K = 3000;

featName = [featName,'_step_',num2str(stepSize),'_mag_',num2str(mag)];

load([dataPath,'SimMat_',num2str(K),'_',featName,'.mat']);

count_feat = count_feat + 1;
G_tr{count_feat} = simMat{1};
G_te{count_feat} = simMat{2};
clear simMat;
% ======================================================================= %

% ======================= RootSIFT Parameters =========================== %
% disp('RootSIFT data extraction started ...');
% featName = 'rootsift';
% radius = 5; % for internal sift
% spacing = 5; % both internal and boundary sift
% K = 3000;
% 
% featName = [featName,'_rad_',num2str(radius),'_spc_',num2str(spacing)];
% 
% dataPath = '../../Databases/Oxford_17/Features/Images_Min_500/'; % inPath
% 
% load([dataPath,'Data_',num2str(K),'_',featName,'.mat']);
% 
% % similarity matrix formation
% count_feat = count_feat + 1;
% tmp = double(pdist2_dollar(trainData,trainData,'chisq'));
% tmp = tmp/max(tmp(:));
% tmp = 1-tmp;
% G_tr{count_feat} = tmp;
% tmp = double(pdist2_dollar(testData,trainData,'chisq'));
% tmp = tmp/max(tmp(:));
% tmp = 1-tmp;
% G_te{count_feat} = tmp;
% clear tmp trainData testData;
% ======================================================================= %

disp('============= Feature-Data Extraction Completed ==================');

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

% add paths for multiple kernel learning
addpath(genpath('MKL/libsvm-3.20/'));
addpath(genpath('MKL/mosek/'));
addpath(genpath('MKL/mkl-multiple-label/'));

% ===================== Multiple Kernel Learning ======================== %
if strcmp(kernel_mkl,'same')
    % Selecting the SAME Kernel Accross different Labels
    clear param;
    % force mosek output information, comment the following line if require no output
    param.mosek=1; 
    param.C = 10;  % set the SVM trade-off parameter
    model = SILP_1norm_same(G_tr, Y_tr, param);
 %   model.mu = [0.42; 0.16; 0.42];
    disp('the kernel weights are');
    disp(model.mu);

elseif strcmp(kernel_mkl,'share')
    % Allow the labels to share the kernels PARTIALly
    clear param
    % force mosek output information, comment the following line if require no output
    param.mosek=1; 

    param.C = 10;
    param.c1 = percent_kernel_share; % share 50% of kernels = 0.5
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