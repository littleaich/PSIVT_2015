% ======================================================================= %
% Name: makeFeaMat.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the fourth file to extract HSV color descriptors 
% from Oxford-102 flower dataset (PSIVT_2015). It forms the bag-of-words 
% feature vectors using HSV color descriptors and visual codebook. The file
% hierarchy for HSV color features extraction and testing using multiple 
% kernel learning (Oxford-102 dataset, PSIVT_2015) is listed as follows: 
% (1) extractColorDescriptors.m, (2) makeDesMat.m, 
% (3) makeVisualCodebook_LD.m, (4) makeFeaMat.m, (5) makeSimMat.m, 
% (6) classifyMKL.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %

clear all; close all; clc;
restoredefaultpath;

%image_version = 'Images_Segmented_Adjusted';
image_version = 'Images_Min_500';
%image_version = 'Images';
%image_version = 'Images_Org_Min_500';
K = 900;
IGNORE_LOCATION = true;
featName = 'hsv'; % change
blockSize = 3;
featName = [featName,'_',num2str(blockSize),'x',num2str(blockSize)];

inMatPath1 = '../../Databases/Oxford/';
outMatPath = ['../../Databases/Oxford/Features/',image_version,'/'];
inMatPath2 = [outMatPath,featName,'/'];
addpath(inMatPath1);
addpath(inMatPath2);

matList = dir([inMatPath2,'*.mat']);
load setid.mat;
load imagelabels.mat;

trnid = [trnid,valid]; % comment this line to exclude validation images

trainLabel = labels(trnid); % change
testLabel = labels(tstid); % change
trainLabel = trainLabel';
testLabel = testLabel';

if IGNORE_LOCATION
    load([outMatPath,'VC_',num2str(K),'_',featName,'.mat']);
else
    load([outMatPath,'VC_',num2str(K),'_',featName,'_Loc.mat']);
end

binRange = 1:K+1;

trainData = [];
for i = 1:length(trnid) 
    disp(['Processing Training Image = ',num2str(i)]);
    load([num2str(trnid(i)),'.mat']); 
    if IGNORE_LOCATION
        desc = desc(:,1:3);
    end
    dmat = eucliddist(desc,VC);
    [~,visword] = min(dmat,[],2);
    H = histc(visword,binRange);
    H = H/sqrt(sum(H.^2)); % L2 Normalization
%    H = H/sum(H); % L1 Normalization
    trainData = [trainData; H'];
end

testData = [];
for i = 1:length(tstid) 
    disp(['Processing Test Image = ',num2str(i)]);
    load([num2str(tstid(i)),'.mat']); 
    if IGNORE_LOCATION
        desc = desc(:,1:3); % ignore location
    end
    dmat = eucliddist(desc,VC);
    [~,visword] = min(dmat,[],2);
    H = histc(visword,binRange);
    H = H/sqrt(sum(H.^2)); % L2 Normalization
%    H = H/sum(H); % L1 Normalization
    testData = [testData; H'];
end

if IGNORE_LOCATION
    save([outMatPath,'Data_',num2str(K),'_',featName,'.mat'], ...
        'trainData', 'testData','trainLabel','testLabel');
else
    save([outMatPath,'Data_',num2str(K),'_',featName,'_Loc.mat'], ...
        'trainData', 'testData','trainLabel','testLabel');
end

clear all; close all;