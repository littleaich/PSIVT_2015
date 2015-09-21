% ======================================================================= %
% Name: makeMsdSiftDesMat.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the second file to extract MSD-SIFT features from 
% Oxford-102 flower dataset (PSIVT_2015). It accumulates the MSD-SIFT 
% descriptors from different images for visual codebook calculation. The 
% file hierarchy for MSD-SIFT features extraction and testing using 
% multiple kernel learning (Oxford-102 dataset, PSIVT_2015) is listed as 
% follows: (1) extractMsdSiftFeatures.m, (2) makeMsdSiftDesMat.m, 
% (3) makeMsdSiftVisualCodebook_LD.m, (4) makeMsdSiftFeaMat.m, 
% (5) makeMsdSiftSimMat.m, (6) classifyMKL_MsdSift.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc;
restoredefaultpath;
echo off;

image_version = 'Images_Min_500';
% image_version = 'Images_Org_Min_500';
featName = 'msdsift';
stepSize = 5; 
mag = 6;

featName = [featName,'_step_',num2str(stepSize),'_mag_',num2str(mag)];

matPath = ['../../Databases/Oxford/Features/', ...
    image_version,'/', featName,'/'];
outPath = ['../../Databases/Oxford/Features/',image_version,'/'];

addpath(matPath);

load('../../Databases/Oxford/setid.mat');

trnid = [trnid,valid];
numImg = length(trnid);

trainDesc = [];
for i = 1:20:numImg % change
    
    disp(['Processing Image = ', num2str(i)]);
    load([num2str(trnid(i)),'.mat']);
    trainDesc = [trainDesc; desc];
end

save([outPath,'TrainDesc_',featName,'.mat'],'trainDesc');

clear all; close all;
