function [expFeat, goals] = NNCP_ET_NN()
% NNCP_ET_NN - NN training  geatures and goals extraction function
% 
% ET 2017.12.17 "edgetech"™ All Rights Reserved.

global extractedFeatures
start = tic;

if isempty(extractedFeatures)
    inputFileDir = 'D:\Games\MATLAB R2015a\_et files\NNCP\';
    inputFileExt = '.nii';
    outputDir = 'D:\Games\MATLAB R2015a\_et files\NNCP\NNCP_ET_NN\1 - Copy (';

    sampleNum = 1;
    inputFileName = 'darkLeftHemKaput';
    features = NNCP_ImageCycling([inputFileDir inputFileName inputFileExt],[outputDir ns(sampleNum) ')\']);

    sampleNum = 2;
    inputFileName = 'frontEffed';
    features = [features NNCP_ImageCycling([inputFileDir inputFileName inputFileExt],[outputDir ns(sampleNum) ')\'])];

    sampleNum = 3;
    inputFileName = 'leftHemKaput';
    features = [features NNCP_ImageCycling([inputFileDir inputFileName inputFileExt],[outputDir ns(sampleNum) ')\'])];

    sampleNum = 4;
    inputFileName = 'mainTest';
    features = [features NNCP_ImageCycling([inputFileDir inputFileName inputFileExt],[outputDir ns(sampleNum) ')\'])];

    sampleNum = 5;
    inputFileName = 'pretendFine';
    features = [features NNCP_ImageCycling([inputFileDir inputFileName inputFileExt],[outputDir ns(sampleNum) ')\'])];

    sampleNum = 6;
    inputFileName = 'pretendFine2';
    features = [features NNCP_ImageCycling([inputFileDir inputFileName inputFileExt],[outputDir ns(sampleNum) ')\'])];
    
    extractedFeatures = features;
else 
    features = extractedFeatures;
end

[rows, columns] = size(features);
for i = 1:columns
    for k = 1:rows
        structure = features(k,i);
        expStruct = [
            double(structure.Area) ...
            double(structure.Centroid) ...
            double(structure.MajorAxisLength) ...
            double(structure.MinorAxisLength) ...
            double(structure.Eccentricity) ...
            double(structure.ConvexArea) ...
            double(structure.EquivDiameter) ...
            double(structure.Extrema(:,1)') ...
            double(structure.Extrema(:,2)') ...
            double(structure.Solidity) ...
            double(structure.Extent) ...
            double(structure.WeightedCentroid) ...
            double(structure.MeanIntensity) ...
            double(structure.MinIntensity) ...
            double(structure.MaxIntensity)
            ];
        if exist('exp3Struct','var'); exp3Struct = [exp3Struct expStruct];
        else exp3Struct = expStruct;
        end
    end
    exp3Struct = exp3Struct';
    if exist('expFeat','var'); expFeat = [expFeat exp3Struct];
    else expFeat = exp3Struct;
    end
    clear exp3Struct
end

% normalize them all
[rows,~] = size(expFeat);
for i = 1:rows
    expFeat(i,:) = expFeat(i,:)./max(expFeat(i,:));
end





% hand picked lessioned slices a.k.a. expected results
% sample 1
ss  = 122;
lss = 137;
les = 183;
es  = 186;
s1 = cat(ss,lss,les,es);
% sample 2
ss  = 119;
lss = 126;
les = 181;
es  = 181;
s2 = cat(ss,lss,les,es);
% sample 3
ss  = 122;
lss = 122;
les = 186;
es  = 186;
s3 = cat(ss,lss,les,es);
% sample 4
ss  = 86;
lss = 86;
les = 107;
es  = 131;
s4 = cat(ss,lss,les,es);
% sample 5
ss  = 119;
lss = 119;
les = 119;
es  = 181;
s5 = cat(ss,lss,les,es);
% sample 6
ss  = 122;
lss = 122;
les = 122;
es  = 186;
s6 = cat(ss,lss,les,es);

goals = [s1 s2 s3 s4 s5 s6];










fprintf(1,'NNCP_ET_NN time: %3.2f\n',toc(start));

end

function rez = cat(ss,lss,les,es)
rez = [0 zeros(1,lss-ss) ones(1,les-lss) zeros(1,es-les)];
end