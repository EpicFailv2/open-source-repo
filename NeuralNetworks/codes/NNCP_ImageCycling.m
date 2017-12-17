function rez = NNCP_ImageCycling(inputFilepath,outputDir,outputFName,slices)
% NNCP_IMAGECYCLING - generates features and stuff
% 
%   inputFilepath - path, filename, extension of input .nii file
%   outputDir     - slice image output directory
%   outputFName   - common name for the slices
% 
%   Note: if any variables not given, defaults are used
% 
% ET 2017.12.17 "edgetech"™ All Rights Reserved.

start = tic;

if ~exist('inputFilepath','var'); inputFilepath = 'D:\Games\MATLAB R2015a\_et files\NNCP\src.nii'; end
if ~exist('outputDir','var'); outputDir = 'D:\Games\MATLAB R2015a\_et files\NNCP\slices\'; end
if ~exist('outputFName','var'); outputFName = 'slice'; end
if ~exist('slices','var'); slices = [.48 .73]; end
nifti2slices(inputFilepath,[outputDir outputFName],slices);
content = dir(outputDir);
for i = 1:length(content)
   if content(i).isdir; continue; end; %skip non files
   ret = NNCP_Image_Segmentation_edgetech([outputDir content(i).name]);
   if exist('rez','var'); rez = [rez ret];
   else rez = ret;
   end
end

disp(['NNCP_ImageCycling took: ' ns(toc(start))]);

end