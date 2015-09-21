% ======================================================================= %
% Name: adjustSegImg.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This file cuts the unnecessary background portion of the 
% GrabCut segmented images along the boundaries produced by the file 
% Segmentation_GrabCut.m. It uses bwNoiseReduction.m for connected
% component based object identification.
% ======================================================================= %

clear all; close all; clc;

segImgDir = '../../Databases/Oxford/Segmentation_Result/GrabCut/';
addpath(genpath(segImgDir));

pathAdjSegImg = '../../Databases/Oxford/Images_Segmented_Adjusted/';

if isequal(exist(pathAdjSegImg,'dir'),7)
    disp('Execution terminated because...');
    disp('directory for scaled images already exists...');
    return;
else
    mkdir(pathAdjSegImg);
end

imgList = dir(segImgDir);
numImg = length(imgList);

minObjPix = 2000;

for i = 3:numImg
    disp(i-2);
    f = imread(imgList(i).name);
    rowLb = 0; rowUb = 0; colLb = 0; colUb = 0;
    f1 = f(:,:,1);
    f2 = f(:,:,2);
    f3 = f(:,:,3);
    f3_1 = f3;
    f3_1(f3>=254) = 0;
    L = bsxfun(@or, f1>0, f2>0);
    L = bsxfun(@or, L, f3_1>0);
    se = strel('disk',1);
    L1 = imdilate(L,se);
    L2 = bwNoiseReduction(L1, 8, -1,minObjPix);
    for j= 1:size(L2,1)
          if numel(find(L2(j,:))) > 0
              rowLb = j; 
              break;
          end
    end
    for j= size(L2,1):-1:1
          if numel(find(L2(j,:))) > 0
              rowUb = j; 
              break;
          end
    end
    for j= 1:size(L2,2)
          if numel(find(L2(:,j))) > 0
              colLb = j; 
              break;
          end
    end
    for j= size(L2,2):-1:1
          if numel(find(L2(:,j))) > 0
              colUb = j; 
              break;
          end
    end
    
    if rowLb~=0 && rowUb~=0 && colLb~=0 && colUb~=0
        f1 = f1(rowLb:rowUb, colLb:colUb);
        f2 = f2(rowLb:rowUb, colLb:colUb);
        f3 = f3(rowLb:rowUb, colLb:colUb);
        fAdj = cat(3,f1,f2,f3);
    else
        fAdj = f;
    end
    
    imwrite(fAdj,[pathAdjSegImg, 'adj_', imgList(i).name]);
end

