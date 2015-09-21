% ======================================================================= %
% Name: extractSiftFeatures.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This is the first file to extract SIFT features from 
% Oxford-102 flower dataset (PSIVT_2015). It extracts the SIFT descriptors 
% from the foregound of the images in regular grid spacing. Descriptor
% extraction is performed using vlfeat library downloaded from this link 
% http://www.vlfeat.org/. The file hierarchy for SIFT features extraction 
% and testing using multiple kernel learning 
% (Oxford-102 dataset, PSIVT_2015) is listed as follows: 
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
MAXMIN_BG = 10;
MINMAX_BG = 245;
THRESH_DES_NORM = 200;
featName = 'sift';
radius = 5; % for internal sift
spacing = 5; % both internal and boundary sift

imgPath = ['../../Databases/Oxford/',image_version,'/'];
outPath = ['../../Databases/Oxford/Features/',image_version,'/'];
imPref = 'adj_seg_image_';
% imPref = '';
addpath('../../Databases/Oxford/');

run('vlfeat-0.9.20/toolbox/vl_setup.m');

addpath(imgPath);
featName = [featName,'_rad_',num2str(radius),'_spc_',num2str(spacing)];
outPath_deep = [outPath,featName,'/'];
mkdir(outPath_deep);

numImg = length(dir(imgPath))-2;

for i = 1:numImg
    
    disp(['Processing Image = ', num2str(i)]);
    if i<10
        addZeros = '000';
    elseif i>=10 && i<100
        addZeros = '00';
    elseif i>=100 && i<1000
        addZeros = '0';
    else
        addZeros = '';
    end
%    addZeros = '';
    im_rgb = imread([imPref,addZeros,num2str(i),'.jpg']);
    im = im2double(rgb2gray(im_rgb));
    % grid sift processing
    x = 1:spacing:size(im,1);
    y = 1:spacing:size(im,2);
    [X,Y] = meshgrid(x,y);
    X = X(:)'; Y = Y(:)';    
    count = 0;
    for j = 1:length(X)
        if im_rgb(X(j),Y(j),1) <= MAXMIN_BG && ...
                im_rgb(X(j),Y(j),2) <= MAXMIN_BG && ...
                im_rgb(X(j),Y(j),3) >= MINMAX_BG
            count = count+1;
            pos_bg(count) = j;
        end
    end
    
    R = radius*ones(1,length(X));
    fc = [Y; X; R; zeros(1,length(X))];
    [~,desc] = vl_sift(single(im),'frames',fc,'orientations');    
    if exist('pos_bg','var')
        desc(:,pos_bg) = [];
    end
    clear pos_bg;
    desc = single(desc');
    tmp = sqrt(sum(desc.^2,2));
    desc = desc(tmp > THRESH_DES_NORM,:);
    save([outPath_deep,num2str(i),'.mat'],'desc');
end

clear all; close all; 