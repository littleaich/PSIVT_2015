% ======================================================================= %
% Name: resize_min_500.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This file resizes all the images produced by adjustSegImg.m 
% such that the minimum dimension of all the images is at least 500.
% ======================================================================= %
clear all; close all; clc;

MIN_SIZE = 500;
imgPath = '../../Databases/Oxford/Images_Segmented_Adjusted/';
outPath = '../../Databases/Oxford/Images_Min_500/';
imPref = 'adj_seg_image_';

addpath(imgPath);
mkdir(outPath);

numImg = length(dir(imgPath))-2;

for i = 1:numImg
    
    disp(['Processing Image = ', num2str(i)]);
    if i<10
        addZeros = '0000';
    elseif i>=10 && i<100
        addZeros = '000';
    elseif i>=100 && i<1000
        addZeros = '00';
    else
        addZeros = '0';
    end
    
    f = imread([imPref,addZeros,num2str(i),'.jpg']);
    [r,c,~] = size(f);
    if (r < MIN_SIZE) || (c < MIN_SIZE)
        if r < c
            rat = MIN_SIZE/r;
            r_new = MIN_SIZE;
            c_new = round(rat*c);
        else
            rat = MIN_SIZE/c;
            c_new = MIN_SIZE;
            r_new = round(rat*r);
        end
        f_new = imresize(f,[r_new,c_new]);
    else
        f_new = f;
    end
    imwrite(f_new,[outPath,num2str(i),'.jpg']);
end

clear all; close all; clear memory;