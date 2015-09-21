% ======================================================================= %
% Name: makeDesMat.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the second file to extract HSV color descriptors 
% from Oxford-102 flower dataset (PSIVT_2015). It accumulates the HSV color 
% descriptors from different images for visual codebook calculation. The 
% file hierarchy for HSV color features extraction and testing using 
% multiple kernel learning (Oxford-102 dataset, PSIVT_2015) is listed as 
% follows: (1) extractColorDescriptors.m, (2) makeDesMat.m, 
% (3) makeVisualCodebook_LD.m, (4) makeFeaMat.m, (5) makeSimMat.m, 
% (6) classifyMKL.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc; 
restoredefaultpath;
echo off;

imgStepSize = 4;
%image_version = 'Images_Segmented_Adjusted';
image_version = 'Images_Min_500';
%image_version = 'Images';
%image_version = 'Images_Org_Min_500';
featName = 'hsv';
blockSize = 3; % change
matPath = ['../../Databases/Oxford/Features/', ...
    image_version,'/', featName,'_',num2str(blockSize),'x',...
    num2str(blockSize),'/'];
outPath = ['../../Databases/Oxford/Features/',image_version,'/'];

addpath(matPath);

load('../../Databases/Oxford/setid.mat');

trnid = [trnid,valid]; % comment this line to exclude validation images
numImg = length(trnid);

trainDesc = [];
for i = 1:imgStepSize:numImg
    
    disp(['Processing Image = ', num2str(i)]);
    load([num2str(trnid(i)),'.mat']);
    trainDesc = [trainDesc;desc];
end

save([outPath,'TrainDesc_',featName,'_',num2str(blockSize),'x', ...
    num2str(blockSize),'.mat'],'trainDesc');

clear all; close all;