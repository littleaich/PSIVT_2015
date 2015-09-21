% ======================================================================= %
% Name: makeSiftDesMat.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the second file to extract SIFT features from 
% Oxford-102 flower dataset (PSIVT_2015). It accumulates the SIFT 
% descriptors from different images for visual codebook calculation. The 
% file hierarchy for SIFT features extraction and testing using multiple 
% kernel learning (Oxford-102 dataset, PSIVT_2015) is listed as follows:
% (1) extractSiftFeatures.m, (2) makeSiftDesMat.m, 
% (3) makeSiftVisualCodebook_LD.m, (4) makeSiftFeaMat.m, 
% (5) makeSiftSimMat.m, (6) classifyMKL_Sift.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc; 
restoredefaultpath;
echo off;

image_version = 'Images_Min_500';
% image_version = 'Images_Org_Min_500';
featName = 'sift';
radius = 5; % for internal sift
spacing = 5; % both internal and boundary sift

featName = [featName,'_rad_',num2str(radius),'_spc_',num2str(spacing)];

matPath = ['../../Databases/Oxford/Features/', ...
    image_version,'/', featName,'/'];
outPath = ['../../Databases/Oxford/Features/',image_version,'/'];

addpath(matPath);

load('../../Databases/Oxford/setid.mat');

trnid = [trnid,valid];
numImg = length(trnid);

trainDesc = [];
for i = 1:8:numImg % change
    
    disp(['Processing Image = ', num2str(i)]);
    load([num2str(trnid(i)),'.mat']);
    trainDesc = [trainDesc; desc];
end

save([outPath,'TrainDesc_',featName,'.mat'],'trainDesc');

clear all; close all;
