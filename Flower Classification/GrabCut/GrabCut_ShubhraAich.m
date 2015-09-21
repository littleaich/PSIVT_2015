function L = GrabCut_ShubhraAich(rgbIm, primaryBinLabel, Beta, K)

%%% Input Arguments
% rgbIm = uint RGB image on which segmentation is to be performed
% primaryBinLabel = primarily labelled matrix of type logical

%%% Output Arguments
% L = output {0,1} image of type double

fixedBG = ~primaryBinLabel;
imd = double(rgbIm);

if nargin == 2
  %  Beta = 0.1;
    Beta = 0.3;
    K = 6;
end

G = 50;
maxIter = 10;
%maxIter = 100;
diffThreshold = 0.001;

L = GCAlgo_ConsoleVersion(imd, fixedBG, K, G, maxIter, Beta, diffThreshold);
L = double(bsxfun(@minus,1,L));

