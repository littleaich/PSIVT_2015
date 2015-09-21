% ======================================================================= %
% Name: extractColorDescriptors.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the first file to extract HSV color descriptors from 
% Oxford-102 flower dataset (PSIVT_2015). It extracts the HSV color 
% descriptors as the average values in consecutive non-overlapping nxn 
% blocks (n = 3 for PSIVT_2015). The processing for the color feature 
% extraction is done inside another function modifiedBoFColorExtractor.m. 
% This file calls the function once for each image. The file hierarchy for 
% HSV color features extraction and testing using multiple kernel learning 
% (Oxford-102 dataset, PSIVT_2015) is listed as follows: 
% (1) extractColorDescriptors.m, (2) makeDesMat.m, 
% (3) makeVisualCodebook_LD.m, (4) makeFeaMat.m, (5) makeSimMat.m, 
% (6) classifyMKL.m
% N.B. If the command "resourcedefaultpath" shows error, just restart
% MATLAB.
% ======================================================================= %
clear all; close all; clc;
restoredefaultpath;
echo off;
tic;

%image_version = 'Images_Segmented_Adjusted';
image_version = 'Images_Min_500';
%image_version = 'Images';
%image_version = 'Images_Org_Min_500';
featName = 'hsv';
blockSize = 3;

cform = makecform('srgb2lab');
imgPath = ['../../Databases/Oxford/',image_version,'/'];
outPath = ['../../Databases/Oxford/Features/',image_version,'/'];
if strcmp(image_version,'Images_Segmented_Adjusted')
    imPref = 'adj_seg_image_';
elseif strcmp(image_version,'Images_Min_500') || ...
        strcmp(image_version,'Images_Org_Min_500')
    imPref = '';
elseif strcmp(image_version,'Images')
    imPref = 'image_';
end

addpath(imgPath);
outPath_deep = [outPath,featName,'_',num2str(blockSize),'x', ...
    num2str(blockSize),'/'];
mkdir(outPath_deep);

numImg = length(dir(imgPath))-2;

for i = 1:numImg
    
    disp(['Processing Image = ', num2str(i)]);
    if strcmp(image_version,'Images_Segmented_Adjusted') || ...
            strcmp(image_version,'Images')
        if i<10
            addZeros = '0000';
        elseif i>=10 && i<100
            addZeros = '000';
        elseif i>=100 && i<1000
            addZeros = '00';
        else
            addZeros = '0';
        end
    elseif strcmp(image_version,'Images_Min_500') || ...
            strcmp(image_version,'Images_Org_Min_500')
        addZeros = '';
    end
    f = imread([imPref,addZeros,num2str(i),'.jpg']);
    [desc] = modifiedBoFColorExtractor(f,featName,blockSize,cform);
    desc = single(desc);
    save([outPath_deep,num2str(i),'.mat'],'desc');
end

toc;
clear all; close all;

