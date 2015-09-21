% ======================================================================= %
% Name: makeVisualCodebook_LD.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the third file to extract HSV color descriptors 
% from Oxford-102 flower dataset (PSIVT_2015). It calculates the visual
% codebook from the HSV color descriptor set using "vlfeat" library
% downloaded from the link http://www.vlfeat.org/. For codebook calculation
% in this large dimension, "Approximate Nearest Neighbor" (ANN) option of 
% vlfeat library is used. The file hierarchy for HSV color features 
% extraction and testing using multiple kernel learning (Oxford-102 
% dataset, PSIVT_2015) is listed as follows: (1) extractColorDescriptors.m,
%(2) makeDesMat.m, (3) makeVisualCodebook_LD.m, (4) makeFeaMat.m, 
% (5) makeSimMat.m, (6) classifyMKL.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc; 
restoredefaultpath;
echo on;

%image_version = 'Images_Segmented_Adjusted';
image_version = 'Images_Min_500';
%image_version = 'Images';
%image_version = 'Images_Org_Min_500';
IGNORE_LOCATION = true; % change
featName = 'hsv';
blockSize = 3;
K = 900;

featName = [featName,'_',num2str(blockSize),'x',num2str(blockSize)];
dbPath = ['../../Databases/Oxford/Features/',image_version,'/'];

run('vlfeat-0.9.20/toolbox/vl_setup.m');

load([dbPath,'TrainDesc_',featName,'.mat']);
if IGNORE_LOCATION
    trainDesc = trainDesc(:,1:3); % ignore locations
end
trainDesc = trainDesc';

tic; 
[VC,~] = vl_kmeans(trainDesc,K,'verbose','distance','l2',...
    'algorithm','ann'); 
toc;
VC = VC';

if IGNORE_LOCATION
    save([dbPath,'VC_',num2str(K),'_',featName,'.mat'],'VC');
else
    save([dbPath,'VC_',num2str(K),'_',featName,'_Loc.mat'],'VC');
end

clear all; close all; 
echo off;