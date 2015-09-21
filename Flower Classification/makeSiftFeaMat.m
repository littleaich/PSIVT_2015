% ======================================================================= %
% Name: makeSiftFeaMat.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the fourth file to extract SIFT features 
% from Oxford-102 flower dataset (PSIVT_2015). It forms the bag-of-words 
% feature vectors using SIFT descriptors and visual codebook. The file 
% hierarchy for SIFT features extraction and testing using multiple kernel 
% learning (Oxford-102 dataset, PSIVT_2015) is listed as follows: 
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
%image_version = 'Images_Org_Min_500';
featName = 'sift';
radius = 5; % for internal sift
spacing = 5; % both internal and boundary sift
K = 3000;

featName = [featName,'_rad_',num2str(radius),'_spc_',num2str(spacing)];

inMatPath1 = '../../Databases/Oxford/';
outMatPath = ['../../Databases/Oxford/Features/',image_version,'/'];
inMatPath2 = [outMatPath,featName,'/'];
addpath(inMatPath1);
addpath(inMatPath2);

matList = dir([inMatPath2,'*.mat']);
load setid.mat;
load imagelabels.mat;
load([outMatPath,'VC_',num2str(K),'_',featName,'.mat']);

trnid = [trnid,valid];
trainLabel = labels(trnid); % change
testLabel = labels(tstid); % change
trainLabel = trainLabel';
testLabel = testLabel';

binRange = 1:K+1;

trainData = [];
for i = 1:length(trnid) % change
    disp(['Processing Training Image = ',num2str(i)]);
    load([num2str(trnid(i)),'.mat']); % change
    dmat = eucliddist(desc,VC);
    [~,visword] = min(dmat,[],2);
    H = histc(visword,binRange);
    H = H/sqrt(sum(H.^2)); % L2 Normalization
%    H = H/sum(H); % L1 Normalization
    trainData = [trainData; H'];
end

testData = [];
for i = 1:length(tstid) % change
    disp(['Processing Test Image = ',num2str(i)]);
    load([num2str(tstid(i)),'.mat']); % change
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
