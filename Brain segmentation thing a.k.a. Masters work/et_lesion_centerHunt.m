function et_lesion_centerHunt()
% ET_LESION - automatic lesion detector
%
%   TBA
%
% AB 2018.02.20 "edgetech" All Rights Reserved.

origdir = cd;

srcNiiDir = 'D:\Games\MATLAB R2015a\_et files\Masters\mri_filtered\source'; % folder with FMRI scan .nii files (needs L or R at the name end to indicate damaged hamisphere); without '\' at the end; was 'D:\Games\MATLAB R2015a\_et files\Masters\mri_filtered\source'
labelsDir = 'D:\Games\MATLAB R2015a\_et files\Masters\mri_filtered\labels'; % folder with hand drawn lesion areas for patients (name: ['l' patient_nii_file_name] <- that is small L); without '\' at the end; was 'D:\Games\MATLAB R2015a\_et files\Masters\mri_filtered\labels'
wrkDirRoot= 'D:\Games\MATLAB R2015a\_et files\Masters\Finals\wrkDir\'; % folder where folders with generated data will be placed; with '\' at the end
pngDir =    'D:\Games\MATLAB R2015a\_et files\Masters\Finals\pngs'; % folder for DSC plot placement; without '\' at the end
lesionDir = fullfile(fileparts(which('spm')), 'toolbox', 'lesion_gnb');


spm_jobman('initcfg');
fwhm = 11;
im_mask = 0;
times = [];
segTimes = [];
srcNii = dir([srcNiiDir '\*.nii']); % poll for .nii files 
fullTime = tic;
o = zeros(1,12);
routs = o;
outputStr = '';
outputStr = [outputStr 'Lesion center determination testing system' '\n'];
outputStr = [outputStr '  mmmx - point of maximum difference a.k.a. max(max(max(f1nii.img))) coordinates' '\n'];
outputStr = [outputStr '  GTC - geometric thresholded center' '\n'];
outputStr = [outputStr '  GWTC - geometric weighted thresholded center' '\n'];
outputStr = [outputStr '  GWATC - geometric weighted adaptive thresholded center' '\n'];


for i = 1:length(srcNii)
    [~, fname, fext] = fileparts(srcNii(i).name);
    % fname = 'P0089_R'; % debug
%     if (i > 5); break; end;
    if (~strcmp(fname,'P1268_L'))
        continue;
    end;
    
    disp(['--- Cycle #' num2str(i) ' [' fname '] ---']);
    
    workDir = [wrkDirRoot fname];
    if ~isdir(workDir); mkdir(workDir); end
    copyfile(fullfile(srcNiiDir,[fname fext]), workDir);
    cd(workDir)
    
    full = tic;
    
    % ----------------- segmentation -------------------------------------
    if ~exist(['wc1' fname fext],'file')
        seg = tic;
        run_sectioning(fullfile(workDir,[fname fext]))
        % run_sectioningFull(fullfile(workDir,[fname fext]))
        t = toc(seg);
        segTimes = [segTimes t];
        disp(['Sectioning time: ' num2str(t) ' seconds.']);
    end
    
    % ----------------- feature extraction -------------------------------
    if ~exist('gmta','var') || ~exist('wmta','var') || ~exist('csfta','var')
        cd(fullfile(lesionDir,'volume_files'));
        if ~exist(['s' ns(fwhm) 'TPM.nii'], 'file')
            my_smooth_spm('TPM.nii', [fwhm fwhm fwhm], im_mask); % if it doesn't exist, create it
        end
        smoothed_tpm_template = load_nii(['s' num2str(fwhm) 'TPM.nii']); % load smoothed TPM volume
        
        gmta = smoothed_tpm_template.img(:,:,:,1);
        wmta = smoothed_tpm_template.img(:,:,:,2);
        csfta = smoothed_tpm_template.img(:,:,:,3);
        clear smoothed_tpm_template
        
        % go to subject directory
        cd(workDir);
    end
    
    %ET: wont be used in the end, i guess, but now for reruns it is useful:
    if ~exist(['s' num2str(fwhm) 'wc1' fname fext], 'file')
        my_smooth_spm({['wc1' fname '.nii']; ['wc2' fname '.nii']; ['wc3' fname '.nii']}, [fwhm fwhm fwhm], im_mask); %ET: creates blurred wc1-3_Scans
    end
    %ET: kruva load'inimo ir isskirstymo kintamaisiais
    gmf = load_nii(['s' num2str(fwhm) 'wc1' fname fext]);
    wmf = load_nii(['s' num2str(fwhm) 'wc2' fname fext]);
    csff = load_nii(['s' num2str(fwhm) 'wc3' fname fext]);
    
    gma = gmf.img;
    wma = wmf.img;
    csfa = csff.img;
    
    % get brain mask
    if ~exist('outside_index','var')
        b_mask = load_nii(fullfile(lesionDir, 'volume_files', 'mask_ICV.nii'));
        b_mask = b_mask.img;
        outside_index = find(b_mask == 0); %ET: netestavau, bet panasu isrenka indexus tasku kurie yra uz kaukoles template
    end
    
    % smooth and clip segmentations
    gma(outside_index) = 0; %ET: ir pagal ta outside_index
    wma(outside_index) = 0; % ... isvalo duomenis ...
    csfa(outside_index) = 0; % ... kaukoles isoreje.
        
    gmu = flip(gma,1);
    wmu = flip(wma,1);
    csfu = flip(csfa, 1);
    
    l_bound = ceil(0.5*size(gma,1));
    affected = fname(end);
    if strcmp(affected, 'L') == 1
        idxFrom = l_bound;
        idxTo = size(gma,1);
    elseif strcmp(affected, 'R') == 1
        idxFrom = 1;
        idxTo = l_bound;
    else
        error('What hemisphere?');
    end
    
    % create single hemisphere subject volumes %ETedit
    gma(idxFrom:idxTo, :,:) = 0;
    wma(idxFrom:idxTo, :,:) = 0;
    csfa(idxFrom:idxTo, :,:) = 0;
    gmu(idxFrom:idxTo, :,:) = 0;
    wmu(idxFrom:idxTo, :,:) = 0;
    csfu(idxFrom:idxTo, :,:) = 0;
    gmt = gmta; gmt(idxFrom:idxTo, :,:) = 0;
    wmt = wmta; wmt(idxFrom:idxTo, :,:) = 0;
    csft = csfta; csft(idxFrom:idxTo, :,:) = 0;
    
    
    ct = (csfa - csft).*((gmt + wmt)-(gma + wma)); % missing tissue feature map 1
    cm = (csfa - csfu).*((gmu + wmu)-(gma + wma)); % missing tissue feature map 2
    
    f1 = (cm + ct)./2; % get average of the two volumes
    f1 = round(f1.*100)./100; % round result to two significant digits
    f1(f1<0)= 0; % set voxels with values < 0 to 0
    
    gmf.img = f1; %ET: he asigns working images to my_gm so that save_nii could work. ...
    save_nii(gmf, [fname '_f1.nii']); % ... It aparently needs some of those extra variables/parameters.
    
    % ----------------- center hunt stats --------------------------------
    outputStr = [outputStr fname ' stats:\n'];
    
    if ~exist(['w' fname '_f1.nii'],'file')
        returnToNativeSpace([fname '_f1.nii'], ['iy_' fname fext]);
    end
    nf1nii = load_nii(['w' fname '_f1.nii']);
%     template = nf1nii;
    nf1 = nf1nii.img;
    mxf1 = mmmx(nf1); % maximum f1 value
    f1ct = .5; % f1 certainty threshold
    if (mxf1 > f1ct); 
        fprintf(['   Features extracted with good certainty.' '\n']);
        outputStr = [outputStr '  Feature extraction likelly found lesion.' '\n'];
    else
        fprintf([' Lesion delineation is unlicelly to be correct!' '\n']);
        outputStr = [outputStr '  Likelly missed lesion...' '\n'];
    end;
    
    [mxx,mxy,mxz]=ind2sub(size(nf1),find(nf1==mxf1));
    mxx = floor(mean(mxx));
    mxy = floor(mean(mxy));
    mxz = floor(mean(mxz));
    mxc = [mxx, mxy, mxz]; % found lesion center point
    
    gtc5 = GTC(nf1nii.img,.5);
    gtc3 = GTC(nf1nii.img,.3);
    gtc1 = GTC(nf1nii.img,.1);
    gtc5w = GWTC(nf1nii.img,.5);
    gtc3w = GWTC(nf1nii.img,.3);
    gtc1w = GWTC(nf1nii.img,.1);
    gtc0w = GWTC(nf1nii.img,0);
    gtac75 = GWATC(nf1nii.img,75);
    gtac50 = GWATC(nf1nii.img,50);
    gtac25 = GWATC(nf1nii.img,25);
    
    onii = load_nii(fullfile(workDir,[fname fext]));
    lnii = load_nii(fullfile(labelsDir, ['l' fname fext]));
    
    
    [htc, routs(1)] = hitCheck(lnii.img, mxc);
    outputStr = [outputStr '  mmmx center coordinate:      ' ns(mxc(1)) ' ' ns(mxc(2)) ' ' ns(mxc(3)) ' : ' htc '\n'];
    [htc, routs(2)] = hitCheck(lnii.img, gtc5);
    outputStr = [outputStr '  GTC  >.5 coordinate:         ' ns(gtc5(1)) ' ' ns(gtc5(2)) ' ' ns(gtc5(3)) ' : ' htc '\n'];
    [htc, routs(3)] = hitCheck(lnii.img, gtc5w);
    outputStr = [outputStr '  GWTC >.5 coordinate:         ' ns(gtc5w(1)) ' ' ns(gtc5w(2)) ' ' ns(gtc5w(3)) ' : ' htc '\n'];
    [htc, routs(4)] = hitCheck(lnii.img, gtc3);
    outputStr = [outputStr '  GTC  >.3 coordinate:         ' ns(gtc3(1)) ' ' ns(gtc3(2)) ' ' ns(gtc3(3)) ' : ' htc '\n'];
    [htc, routs(5)] = hitCheck(lnii.img, gtc3w);
    outputStr = [outputStr '  GWTC >.3 coordinate:         ' ns(gtc3w(1)) ' ' ns(gtc3w(2)) ' ' ns(gtc3w(3)) ' : ' htc '\n'];
    [htc, routs(6)] = hitCheck(lnii.img, gtc1);
    outputStr = [outputStr '  GTC  >.1 coordinate:         ' ns(gtc1(1)) ' ' ns(gtc1(2)) ' ' ns(gtc1(3)) ' : ' htc '\n'];
    [htc, routs(7)] = hitCheck(lnii.img, gtc1w);
    outputStr = [outputStr '  GWTC >.1 coordinate:         ' ns(gtc1w(1)) ' ' ns(gtc1w(2)) ' ' ns(gtc1w(3)) ' : ' htc '\n'];
    [htc, routs(8)] = hitCheck(lnii.img, gtc0w);
    outputStr = [outputStr '  GWTC >0  coordinate:         ' ns(gtc0w(1)) ' ' ns(gtc0w(2)) ' ' ns(gtc0w(3)) ' : ' htc '\n'];
    [htc, routs(9)] = hitCheck(lnii.img, gtac75);
    outputStr = [outputStr '  GWATC 75%%  coordinate:       ' ns(gtac75(1)) ' ' ns(gtac75(2)) ' ' ns(gtac75(3)) ' : ' htc '\n'];
    [htc, routs(10)] = hitCheck(lnii.img, gtac50);
    outputStr = [outputStr '  GWATC 50%%  coordinate:       ' ns(gtac50(1)) ' ' ns(gtac50(2)) ' ' ns(gtac50(3)) ' : ' htc '\n'];
    [htc, routs(11)] = hitCheck(lnii.img, gtac25);
    outputStr = [outputStr '  GWATC 25%%  coordinate:       ' ns(gtac25(1)) ' ' ns(gtac25(2)) ' ' ns(gtac25(3)) ' : ' htc '\n'];
    routs(12) = 1;
    o = o + routs;

    oslice = onii.img(:,:,mxc(3));
    oslice(:,:,2) = oslice(:,:,1);
    oslice(:,:,3) = oslice(:,:,1);
    lslice = lnii.img(:,:,mxc(3)).*255;
    lslice(:,:,2) = lslice(:,:,1).*0;
    lslice(:,:,3) = lslice(:,:,1).*0;
    cslice = zeros(size(lslice)); cslice(mxc(1),mxc(2),1:3) = 255;
    X = imfuse(oslice,lslice,'blend','Scaling','joint');
    X = imfuse(X,cslice,'blend','Scaling','joint');
    
    ETwasHere = cd;
    cd(pngDir);
    imwrite(X,['center_' fname '.png']);
    cd(ETwasHere);
    
    outputStr = [outputStr '\n'];
    
end

outputStr = [outputStr ' Overall scores: ' '\n'];
outputStr = [outputStr '       mmmx hit ' ns(o(1)) '/' ns(o(12)) ' [' ns(o(1)/o(12)*100) '%%]' '\n'];
outputStr = [outputStr '   GTC  >.5 hit ' ns(o(2)) '/' ns(o(12)) ' [' ns(o(2)/o(12)*100) '%%]' '\n'];
outputStr = [outputStr '   GWTC >.5 hit ' ns(o(3)) '/' ns(o(12)) ' [' ns(o(3)/o(12)*100) '%%]' '\n'];
outputStr = [outputStr '   GTC  >.3 hit ' ns(o(4)) '/' ns(o(12)) ' [' ns(o(4)/o(12)*100) '%%]' '\n'];
outputStr = [outputStr '   GWTC >.3 hit ' ns(o(5)) '/' ns(o(12)) ' [' ns(o(5)/o(12)*100) '%%]' '\n'];
outputStr = [outputStr '   GTC  >.1 hit ' ns(o(6)) '/' ns(o(12)) ' [' ns(o(6)/o(12)*100) '%%]' '\n'];
outputStr = [outputStr '   GWTC >.1 hit ' ns(o(7)) '/' ns(o(12)) ' [' ns(o(7)/o(12)*100) '%%]' '\n'];
outputStr = [outputStr '   GWTC > 0 hit ' ns(o(8)) '/' ns(o(12)) ' [' ns(o(8)/o(12)*100) '%%]' '\n'];
outputStr = [outputStr '  GWATC 75%% hit ' ns(o(9)) '/' ns(o(12)) ' [' ns(o(9)/o(12)*100) '%%]' '\n'];
outputStr = [outputStr '  GWATC 50%% hit ' ns(o(10)) '/' ns(o(12)) ' [' ns(o(10)/o(12)*100) '%%]' '\n'];
outputStr = [outputStr '  GWATC 25%% hit ' ns(o(11)) '/' ns(o(12)) ' [' ns(o(11)/o(12)*100) '%%]' '\n'];
outputStr = [outputStr '\n'];

fullTime = toc(fullTime)
cd('D:\Games\MATLAB R2015a\_et files\Masters');
cd(origdir)
disp('  Done.')
fprintf(outputStr);




function run_sectioning(filepath)
utilDir = fileparts(which('spm'));

matlabbatch=[];
matlabbatch{1}.spm.spatial.preproc.channel.vols = {filepath};
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {[utilDir, '/tpm/TPM.nii,1']};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {[utilDir, '/tpm/TPM.nii,2']};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {[utilDir, '/tpm/TPM.nii,3']};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {[utilDir, '/tpm/TPM.nii,4']};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {[utilDir, '/tpm/TPM.nii,5']};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {[utilDir, '/tpm/TPM.nii,6']};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [1 0];
spm_jobman('run',matlabbatch);

function returnToNativeSpace(convertFilename, transformFieldName)
matlabbatch=[];
matlabbatch{1}.spm.util.defs.comp{1}.def = {transformFieldName}; % file path for inverse deformation field
matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {convertFilename}; % file path for reverse normalization
matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savepwd = 1; % save in current directory
matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 7; %7th degree b-spline interpolation (values 4-7 can be used for 4th to 7th degree b-spline)
matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 0; % no implicit masking
matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0]; % Gaussian smoothing kernel FWHM (can be applied to mask e.g. 8 8 8)
spm_jobman('run',matlabbatch); % run job

function s=GTC(img, threshold)
idStr = ['GTC@' ns(threshold)];
cdisp(idStr)
img(img>=threshold) = 1;
img(img<threshold) = NaN;
[xlim,ylim,zlim] = size(img);
s = [0 0 0];
for z = 1:zlim
    cdisp('\DEL');
    cdisp([idStr ' z:' ns(z) '/' ns(zlim) ' s=' ns(s(1)) ' ' ns(s(1)) ' ' ns(s(1))]);
    for y = 1:ylim
        for x = 1:xlim
            if (img(x,y,z)==1)
                s = s + [x y z];
            end
        end
    end
end
s = round(s./sssm(img(~isnan(img))));

function s = GWTC(img, threshold)
idStr = ['GWTC@' ns(threshold)];
cdisp(idStr);
img(img<threshold) = NaN;
[xlim,ylim,zlim] = size(img);
s = [0 0 0];
for z = 1:zlim
    cdisp('\DEL');
    cdisp([idStr ' z:' ns(z) '/' ns(zlim) ' s=' ns(s(1)) ' ' ns(s(1)) ' ' ns(s(1))]);
    if allNaNCheck(img(:,:,z)); continue; end;
    for y = 1:ylim
        for x = 1:xlim
            if (~isnan(img(x,y,z)))
                s = s + ([x y z].*img(x,y,z));
            end
        end
    end
end
s = round(s./sssm(img(~isnan(img))));

function s = GWATC(img, threshold)
idStr = ['GWATC@' ns(threshold) '%'];
cdisp(idStr);
threshold = mmmx(img) * threshold / 100;
img(img<threshold) = NaN;
[xlim,ylim,zlim] = size(img);
s = [0 0 0];
for z = 1:zlim
    cdisp('\DEL');
    cdisp([idStr ' z:' ns(z) '/' ns(zlim) ' s=' ns(s(1)) ' ' ns(s(1)) ' ' ns(s(1))]);
    if allNaNCheck(img(:,:,z)); continue; end;
    for y = 1:ylim
        for x = 1:xlim
            if (~isnan(img(x,y,z)))
                s = s + ([x y z].*img(x,y,z));
            end
        end
    end
end
s = round(s./sssm(img(~isnan(img))));

function [rez,x] = hitCheck(img, coords)
if sum(isnan(coords))>0
    rez='Got nothing...';
    x=0;
else
    if (img(coords(1),coords(2),coords(3)) > 0)
        rez = 'HIT!';
        x=1;
    else
        rez = 'MISS...';
        x=0;
    end
end

function out = allNaNCheck(in)
if sssm(~isnan(in)) > 0
    out = 0;
else 
    out = 1;
end

function out = sssm(in)
out = sum(sum(sum(in)));


    
    
    
    
    
    
    
    
    