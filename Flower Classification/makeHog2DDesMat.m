% ======================================================================= %
% Name: makeHog2DDesMat.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the second file to extract HOG features from 
% Oxford-102 flower dataset (PSIVT_2015). It accumulates the HOG 
% descriptors from different images for visual codebook calculation. The 
% file hierarchy for HOG features extraction and testing using multiple 
% kernel learning (Oxford-102 dataset, PSIVT_2015) is listed as follows:
% (1) extractHog2DFeatures.m, (2) makeHog2DDesMat.m, 
% (3) makeHog2DVisualCodebook_LD.m, (4) makeHog2DFeaMat.m, 
% (5) makeHog2DSimMat.m, (6) classifyMKL_Hog2D.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc;
restoredefaultpath;
echo off;

%image_version = 'Images_Segmented_Adjusted';
image_version = 'Images_Min_500';
%image_version = 'Images_Min_500_Extended';
featName = 'hog2D';
cellSize = 8; % default
blockSize = 2; % default
numBins = 9; % default
blockLap = 0;

featName = [featName,'_',num2str(cellSize),'x',num2str(cellSize),'_', ...
    num2str(blockSize),'x',num2str(blockSize),'_bin_',num2str(numBins)];

matPath = ['../../Databases/Oxford/Features/', ...
    image_version,'/', featName,'/'];
outPath = ['../../Databases/Oxford/Features/',image_version,'/'];

addpath(matPath);

% old setid is enough for the extended version
load('../../Databases/Oxford/setid.mat'); 

trnid = [trnid,valid];
numImg = length(trnid); % change - trn1, trn2, trn3

trainDesc = [];
for i = 1:1:numImg % change
    
    disp(['Processing Image = ', num2str(i)]);
    load([num2str(trnid(i)),'.mat']); % change trn1, trn2, trn3
    trainDesc = [trainDesc; desc];
end

save([outPath,'TrainDesc_',featName,'.mat'],'trainDesc');

clear all; close all;