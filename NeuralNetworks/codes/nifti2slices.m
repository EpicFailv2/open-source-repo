function rez = nifti2slices(path,output,slices)
% NIFTI2SLICES - extract images from .nii file
% 
%   path    - full or relative path to the .nii file
%   output  - full path to output directory including filename (none or 
%               empty str disables output)(no file extension plis)
%   slices  - number or vector of slice numbers to output (none outputs one 
%               slice at 75% height)
% 
% ET 2017.12.16 "edgetech"™ All Rights Reserved.

% dbg:
if nargin == 0
    disp('[nifti2Slices]: using debug values');
    path = 'D:\Games\MATLAB R2015a\_et files\NNCP\pretendFine.nii'; 
    output = 'D:\Games\MATLAB R2015a\_et files\NNCP\slices\slc';
    slices = [0 1];
end;

outputFlag = 0;
if exist('output','var')
    if ~isempty(output)
        outputFlag = 1;
    end
end

global globalNii globalNiiName
if ~strcmp(globalNiiName, path)
    disp('[nifti2Slices]: Loading .nii')
    globalNii = load_nii(path);
    globalNiiName = path;
end
nii = globalNii;
[~,~,maxSlice] = size(nii.img);
rez = [];

if exist('slices','var')
    if length(slices)>1
        if slices(1) >= 0 && slices(1) < 1
            disp('[nifti2Slices]: Normalized slice range provided.')
            slices(1) = floor(slices(1)*maxSlice);
            if slices(1) == 0; slices(1) = 1; end
            slices(2) = floor(slices(2)*maxSlice);
        else
            disp('[nifti2Slices]: Numbered slice range provided.')
        end
        for i = slices(1):slices(2)
            if i>maxSlice; disp(['.nii has only ' ns(maxSlice) ' slices']);break;end;
            rez(:,:,i+1-slices(1)) = nii.img(:,:,i);
            if outputFlag; imwrite(im2uint16(double(nii.img(:,:,i))/mmx(double(nii.img(:,:,i)))),[output '_' ns(i) '.png']); end;
        end
    else
        disp('[nifti2Slices]: Single slice provided, getting single slice.')
        if slices>maxSlice 
            disp('.nii has only '+ns(maxSlice)+' slices');
        else
            rez = nii.img(:,:,slices);
            if outputFlag; imwrite(im2uint16(double(rez)/mmx(double(rez))),[output '.png']); end;
        end
    end
else
    disp('[nifti2Slices]: Slices not provided, getting single slice at 75%.')
    [~,~,z] = size(nii.img);
    rez = nii.img(:,:,round(z/4*3));
    if outputFlag; imwrite(im2uint16(double(rez)/mmx(double(rez))),[output '.png']); end;
end

if nargin == 0; rez = maxSlice; end
disp('[nifti2Slices]: Done')
end









