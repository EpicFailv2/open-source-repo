function rez = NNCP_Image_Segmentation_edgetech(filename)
% NNCP_IMAGE_SEGMENTATION_EDGETECH - generates features and stuff for
%   single slice
% 
%   filename - full path name and extension to MRI image (.png/.jpg)
% 
% ET 2017.12.17 "edgetech"™ All Rights Reserved.

draw = 0;
if exist('filename','var'); fullFileName = filename;
else fullFileName = 'D:\Games\MATLAB R2015a\_et files\NNCP\slices\slice_75.png'; figure; draw = 1;
end

global originalImage
originalImage = double(imread(fullFileName));
originalImage = uint8(originalImage*(255/mmmx(originalImage)));

start = tic; % Start timer.
rez = [process(1,.4,draw) process(2,.3,draw) process(3,.6,draw)]';
elapsedTime = toc(start);
fprintf(1,'NNCP_Image_Segmentation_edgetech time: %1.2f [%s]\n',elapsedTime,fullFileName);
if draw; fprintf(1,'\n'); end

end

function rez = process(row, threshold, draw)

global originalImage
row = (row-1)*3;
captionFontSize = 14;

% Check to make sure that it is grayscale, just in case the user substituted their own image.
[~, ~, numberOfColorChannels] = size(originalImage);
if numberOfColorChannels > 1
	originalImage = rgb2gray(originalImage);
end

if draw
    % Display the image.
    subplot(3, 3, 1+row);
    imshow(originalImage);
    % Force it to display RIGHT NOW (otherwise it might not display until it's all done, unless you've stopped at a breakpoint.)
    drawnow;
    caption = sprintf('Original image with boundary centers shown');
    if row == 0; title(caption, 'FontSize', captionFontSize); end;
    axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.

    % Just for fun, let's get its histogram and display it.
    [pixelCount, grayLevels] = imhist(originalImage);
    subplot(3, 3, 2+row);
    bar(pixelCount);
    if row == 0; title('Histogram of image', 'FontSize', captionFontSize); end;
    xlim([0 grayLevels(end)]); % Scale x axis manually.
    grid on;
end

% Threshold the image to get a binary image (only 0's and 1's) of class "logical."
% Method #1: using im2bw()
  normalizedThresholdValue = threshold; % In range 0 to 1.
  thresholdValue = normalizedThresholdValue * max(max(originalImage)); % Gray Levels.
  binaryImage = im2bw(originalImage, normalizedThresholdValue);       % One way to threshold to binary
% Method #2: using a logical operation.
%   thresholdValue = 100;
%   binaryImage = originalImage > thresholdValue; % Bright objects will be chosen if you use >.
% ========== IMPORTANT OPTION ============================================================
% Use < if you want to find dark objects instead of bright objects.
%   binaryImage = originalImage < thresholdValue; % Dark objects will be chosen if you use <.

% Do a "hole fill" to get rid of any background pixels or "holes" inside the blobs.
binaryImage = imfill(binaryImage, 'holes');

if draw
    % Show the threshold as a vertical red bar on the histogram.
    hold on;
    maxYValue = ylim;
    line([thresholdValue, thresholdValue], maxYValue, 'Color', 'r');
    % Place a text label on the bar chart showing the threshold.
    annotationText = sprintf('Thresholded at %d gray levels', thresholdValue);
    % For text(), the x and y need to be of the data class "double" so let's cast both to double.
    text(double(thresholdValue + 5), double(0.5 * maxYValue(2)), annotationText, 'FontSize', 10, 'Color', [0 .5 0]);
    text(double(thresholdValue - 70), double(0.94 * maxYValue(2)), 'Background', 'FontSize', 10, 'Color', [0 0 .5]);
    text(double(thresholdValue + 50), double(0.94 * maxYValue(2)), 'Foreground', 'FontSize', 10, 'Color', [0 0 .5]);
end

% % Identify individual blobs by seeing which pixels are connected to each other.
% % Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
% % Do connected components labeling with either bwlabel() or bwconncomp().
labeledImage = bwlabel(binaryImage, 8);     % Label each blob so we can make measurements of it

% Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
blobMeasurements = regionprops(labeledImage, originalImage, 'all');
numberOfBlobs = size(blobMeasurements, 1);
    
if draw
    % bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.
    % Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries.
    subplot(3, 3, 3+row);
    imshow(originalImage);
    if row == 0; title('Outlines, from bwboundaries()', 'FontSize', captionFontSize); end;
    axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
    hold on;
    boundaries = bwboundaries(binaryImage);
    numberOfBoundaries = size(boundaries, 1);
    for k = 1 : numberOfBoundaries
        thisBoundary = boundaries{k};
        plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
    end
    hold off;
end

mArea = 0;
mAreaIdx = 0;
textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
labelShiftX = -7;	% Used to align the labels in the centers of the coins.
blobECD = zeros(1, numberOfBlobs);
% Print header line in the command window.
if draw
    if row == 0; fprintf(1,'Blob #      Mean Intensity  Area   Perimeter    Centroid       Diameter\n');
    else fprintf(1,'------------------------------------------------------------------------\n');
    end
end
% Loop over all blobs printing their measurements to the command window.
for k = 1 : numberOfBlobs % Loop through all blobs.
    meanGL2008a = blobMeasurements(k).MeanIntensity;    % Find the mean of each blob.
	blobArea = blobMeasurements(k).Area;                % Get area.
    blobCentroid = blobMeasurements(k).Centroid;		% Get centroid one at a time
    if draw
        if blobArea > 50                                    % Don't output insignificant data
            blobPerimeter = blobMeasurements(k).Perimeter;		% Get perimeter.
            blobECD(k) = sqrt(4 * blobArea / pi);				% Compute ECD - Equivalent Circular Diameter.
            fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, meanGL2008a, blobArea, blobPerimeter, blobCentroid, blobECD(k));
        end
        % Put the "blob number" labels on the "boundaries" grayscale image.
        text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold');
    end
    
    % find largest blob
    if blobArea > mArea
        mArea = blobArea;
        mAreaIdx = k;
    end
end

% Now, I'll show you another way to get centroids.
% We can get the centroids of ALL the blobs into 2 arrays,
% one for the centroid x values and one for the centroid y values.
allBlobCentroids = [blobMeasurements.Centroid];
centroidsX = allBlobCentroids(1:2:end-1);
centroidsY = allBlobCentroids(2:2:end);

if draw
    % % Plot the centroids in the original image in the upper left.
    % % Dimes will have a red cross, nickels will have a blue X.
    subplot(3, 3, 1+row);
    hold on; % Don't blow away image.
    for k = 1 : numberOfBlobs           % Loop through all keeper blobs.
        plot(centroidsX(k), centroidsY(k), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
    end
end

rez = blobMeasurements(mAreaIdx);

end
