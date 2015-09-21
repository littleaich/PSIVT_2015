% ======================================================================= %
% Name: segmentGrabCut.m
% Author: Shubhra Aich
% Affiliation: M.Eng.(Ongoing), Chonnam National University
% E-mail: s.aich.72@gmail.com
% Description: This function creates the prespecified bounding box based on
% the input parameter zeroColoring and calls the modified callback function
% of Shai Bagon's GrabCut code downloaded from this link
% http://grabcut.weebly.com/code.html . 
% ======================================================================= %

function [fOut] = segmentGrabCut(f,zeroColoring)

f = f*255;
f1 = f(:,:,1);
f2 = f(:,:,2);
f3 = f(:,:,3);
labelInit = ones(size(f,1),size(f,2));
labelInit(:,1:zeroColoring) = 0;
labelInit(1:zeroColoring,:) = 0;
labelInit(end-zeroColoring+1:end,:) = 0;
labelInit(:,end-zeroColoring+1:end) = 0;
labelInit = logical(labelInit);
L = GrabCut_ShubhraAich(f,labelInit);
f1 = f1.*L;
f2 = f2.*L;
f3 = f3.*L;
f3 = f3+imcomplement(L)*255;

fOut = cat(3,f1,f2,f3);