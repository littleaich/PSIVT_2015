% ======================================================================= %
% Name: Segmentation_GrabCut.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This file performs GrabCut based segmentation on Oxford
% 102 class flower dataset. It uses Shai Bagon's GrabCut code from this 
% link http://grabcut.weebly.com/code.html . 
% ======================================================================= %

clear all; close all; clc;

addpath(genpath('../../Databases/Oxford/'));
addpath('GrabCut/');
pathGrabCutImg = '../../Databases/Oxford/Segmentation_Result/GrabCut/';

if isequal(exist(pathGrabCutImg,'dir'),7)
    disp('Execution terminated because...');
    disp('directory for scaled images already exists...');
    return;
else
    mkdir(pathGrabCutImg);
end

orgImgDir = '../../Databases/Oxford/Images/';
imgList = dir(orgImgDir);
numImg = length(imgList);
zeroColoring = 5;

for i = 3:numImg
    disp(i-2);
    f = im2double(imread(imgList(i).name));
    fSeg = segmentGrabCut(f,zeroColoring);
    
    imwrite(uint8(fSeg),[pathGrabCutImg,'seg_',imgList(i).name(1:5), ...
        imgList(i).name(6:end)]);
end
