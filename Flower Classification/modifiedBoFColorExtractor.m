%function [features, metrics] = modifiedBoFColorExtractor(I, colorModel ,blockSize,cform) 
function [features] = modifiedBoFColorExtractor(I, colorModel ,blockSize,cform) 
% Example color layout feature extractor. Designed for use with bagOfFeatures.
%
% Local color layout features are extracted from truecolor image, I and
% returned in features. The strength of the features are returned in
% metrics.

[~,~,P] = size(I);

isColorImage = P == 3; 

if isColorImage
    
    % Convert RGB images to the L*a*b* colorspace. The L*a*b* colorspace
    % enables you to easily quantify the visual differences between colors.
    % Visually similar colors in the L*a*b* colorspace will have small
    % differences in their L*a*b* values.
    if strcmp(colorModel,'rgb')
        Ilab = I;
    elseif strcmp(colorModel, 'hsv')
        Ilab = rgb2hsv(I);
        blueThresh = [0.66,0.68,0.98,1,0.98,1];
%        tmp = Ilab;
    elseif strcmp(colorModel, 'lab')
        %Ilab = rgb2lab(I); % only available in R2015a or later
        Ilab = applycform(im2double(I),cform);
        tmp = rgb2hsv(I);
        blueThresh = [0.66,0.68,0.98,1,0.98,1];
    end
      
    % Compute the "average" L*a*b* color within 16-by-16 pixel blocks. The
    % average value is used as the color portion of the image feature. An
    % efficient method to approximate this averaging procedure over
    % 16-by-16 pixel blocks is to reduce the size of the image by a factor
    % of 16 using IMRESIZE. 
    Ilab = imresize(Ilab, 1/blockSize); % previously blockSize = 16
%    tmp = imresize(tmp,1/blockSize);
    % Note, the average pixel value in a block can also be computed using
    % standard block processing or integral images.
    
    % Reshape L*a*b* image into "number of features"-by-3 matrix.
    [Mr,Nr,~] = size(Ilab);    
    colorFeatures = reshape(Ilab, Mr*Nr, []);
%    tmp = reshape(Ilab,Mr*Nr,[]);
    % Remove Blue Background Pixels
    pos = []; k = 0;
    for i = 1:size(colorFeatures,1)
        if colorFeatures(i,1)>=blueThresh(1) && ...
                colorFeatures(i,1)<=blueThresh(2) && ...
                colorFeatures(i,2)>=blueThresh(3) && ...
                colorFeatures(i,2)<=blueThresh(4) && ...
                colorFeatures(i,3)>=blueThresh(5) && ...
                colorFeatures(i,3)<=blueThresh(6) 
            
            k = k+1; pos(k,1) = i;
        end
    end
%    colorFeatures(pos,:) = [];
    % L2 normalize color features
%    rowNorm = sqrt(sum(colorFeatures.^2,2));
%    colorFeatures = bsxfun(@rdivide, colorFeatures, rowNorm + eps);
        
    % Augment the color feature by appending the [x y] location within the
    % image from which the color feature was extracted. This technique is
    % known as spatial augmentation. Spatial augmentation incorporates the
    % spatial layout of the features within an image as part of the
    % extracted feature vectors. Therefore, for two images to have similar
    % color features, the color and spatial distribution of color must be
    % similar.
    
    % Normalize pixel coordinates to handle different image sizes.
    xnorm = linspace(-0.5, 0.5, Nr);      
    ynorm = linspace(-0.5, 0.5, Mr);    
    [x, y] = meshgrid(xnorm, ynorm);
    
    % Concatenate the spatial locations and color features.
    features = [colorFeatures y(:) x(:)];
    % Remove Blue Background Pixels
    features(pos,:) = [];
    % Use color variance as feature metric.
%     metrics  = var(colorFeatures(:,1:3),0,2);
else
    
    % Return empty features for non-color images. These features are
    % ignored by bagOfFeatures.
    features = zeros(0,5);
   
end