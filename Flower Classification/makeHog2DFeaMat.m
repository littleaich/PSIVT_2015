% ======================================================================= %
% Name: makeHog2DFeaMat.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the fourth file to extract HOG features 
% from Oxford-102 flower dataset (PSIVT_2015). It forms the bag-of-words 
% feature vectors using HOG descriptors and visual codebook. The file 
% hierarchy for HOG features extraction and testing using multiple kernel 
% learning (Oxford-102 dataset, PSIVT_2015) is listed as follows: 
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
K = 1500;

featName = [featName,'_',num2str(cellSize),'x',num2str(cellSize),'_', ...
    num2str(blockSize),'x',num2str(blockSize),'_bin_',num2str(numBins)];

inMatPath1 = '../../Databases/Oxford/';
outMatPath = ['../../Databases/Oxford/Features/',image_version,'/'];
inMatPath2 = [outMatPath,featName,'/'];
addpath(inMatPath1);
addpath(inMatPath2);

matList = dir([inMatPath2,'*.mat']);
load setid.mat; % extended version	
load imagelabels.mat; % extended version
load([outMatPath,'VC_',num2str(K),'_',featName,'.mat']);

trnid = [trnid, valid];

trainLabel = labels(trnid); % change trn1, trn2, trn3
testLabel = labels(tstid); % change trn1, trn2, trn3
trainLabel = trainLabel';
testLabel = testLabel';

binRange = 1:K+1;

trainData = [];
for i = 1:length(trnid) % change trn1, trn2, trn3
    disp(['Processing Training Image = ',num2str(i)]);
    load([num2str(trnid(i)),'.mat']); % change trn1, trn2, trn3
    dmat = eucliddist(desc,VC);
    [~,visword] = min(dmat,[],2);
    H = histc(visword,binRange);
    H = H/sqrt(sum(H.^2)); % L2 Normalization
%    H = H/sum(H); % L1 Normalization
    trainData = [trainData; H'];
end

testData = [];
for i = 1:length(tstid) % change trn1, trn2, trn3
    disp(['Processing Test Image = ',num2str(i)]);
    load([num2str(tstid(i)),'.mat']); % change trn1, trn2, trn3
    dmat = eucliddist(desc,VC);
    [~,visword] = min(dmat,[],2);
    H = histc(visword,binRange);
    H = H/sqrt(sum(H.^2)); % L2 Normalization
%    H = H/sum(H); % L1 Normalization
    testData = [testData; H'];
end

save([outMatPath,'Data_',num2str(K),'_',featName,'.mat'], ...
    'trainData', 'testData','trainLabel','testLabel');

clear all; close all;