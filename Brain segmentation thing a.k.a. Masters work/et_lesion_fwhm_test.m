function rez = et_lesion_fwhm_test()
% ET_LESION - automatic lesion detector
% 
%   TBA
% 
% 2016.11.15 "edgetech" All Rights Reserved.

origdir = cd;

srcNiiDir = 'D:\Games\MATLAB R2015a\_et files\Masters\mri_filtered\source'; % folder with FMRI scan .nii files (needs L or R at the name end to indicate damaged hamisphere)
labelsDir = 'D:\Games\MATLAB R2015a\_et files\Masters\mri_filtered\labels'; % folder with hand drawn lesion areas for patients (name: ['l' patient_nii_file_name] <- that is small L) 
wrkDirRoot= 'D:\Games\MATLAB R2015a\_et files\Masters\etOutput\'; % folder where folders with generated data will be placed
pngDir =    'D:\Games\MATLAB R2015a\_et files\Masters\DSCplots\fullETrun'; % folder for DSC plot placement
lesionDir = fullfile(fileparts(which('spm')), 'toolbox', 'lesion_gnb');


spm_jobman('initcfg');
fwhm = 11;
priors = .5;
im_mask = 0;
times = [];
segTimes = [];
% srcNii = dir(srcNiiDir);


% [~, fname, fext] = fileparts(srcNii(3).name);
fname = 'P0089_R';
fext = '.nii';

% param sets
% fwhs = 2:2:32;
fwhs = [2:2:6 8:12 14:2:32];
% prrs = 0:.1:1;


for i = 1:length(fwhs);
    
%     x = prrs(i);
    fwhm = fwhs(i);
    
    workDir = [wrkDirRoot fname];
    if ~isdir(workDir); mkdir(workDir); end
    copyfile(fullfile(srcNiiDir,[fname fext]), workDir);
    cd(workDir)
    
    full = tic;
    
    % ----------------- segmentation -------------------------------------
    if ~exist(['wc1' fname fext],'file')
        seg = tic;
        run_sectioning(fullfile(workDir,[fname fext]))
        t = toc(seg);
        segTimes = [segTimes t];
        disp(['Sectioning time: ' num2str(t) ' seconds.']);
    end
    % run_sectioningFull(fullfile(workDir,[fname fext]))
    
    % ----------------- feature extraction -------------------------------
    if ~exist('gmta','var') || ~exist('wmta','var') || ~exist('csfta','var')
        cd(fullfile(lesionDir,'volume_files'));
        if ~exist(['s' num2str(fwhm) 'TPM.nii'], 'file')
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
    
    %ET:     wont be used in the end, i guess, but now for reruns it is useful:
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
        error('What Hemisphere?');
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
    
    gm1 = (gma-gmu).*(wmu-wma); % abnormal tissue feature map 1 
    gt1 = (gma-gmt).*(wmt-wma); % abnormal tissue feature map 2 
    
    f2 = (gm1 + gt1)./2; % get average volume
    f2 = round(f2.*100)./100; % round result to 2 significant digits 
    f2(f2<0) = 0; % set voxels with values < 0 to 0
    
    gmf.img = f1; %ET: he asigns working images to my_gm so that save_nii could work. ...
    save_nii(gmf, [fname '_f1.nii']); % ... It aparently needs some of those extra variables/parameters.
    gmf.img = f2;
    save_nii(gmf, [fname '_f2.nii']);
    
    tb_mask = b_mask;
    tb_mask(idxFrom:idxTo,:,:) = 0;
    indexes = find(tb_mask); % extract indices of non-zero voxels from mask
    features = [f1(indexes) f2(indexes)];    

    % ----------------- clasification ------------------------------------
    if ~exist('predict_lesion','var')
        load(fullfile(lesionDir, 'trained_gnbc', 'predict_lesion.mat')) %ET: some sort of his prediction; 1x1 struct ClassificationNaiveBayes
%         x = .5; % default priors he suggests when inputing values
        % x = .1064; % priors he loads from his predict_lesion.mat
    end
%     priors = [1-x x];
    predict_lesion.Prior = [1-priors priors]; %[0.8936    0.1064] original priors

    % predictExample() %ET: my try to figure out what predict needs, gives and does
    [labels, posterior] = predict(predict_lesion, features); %ET: where the magic happens
    gmf.img(:,:,:) = 0; 
    gmf.img(indexes) = posterior(:,2); 
    save_nii(gmf, [fname '_posterior.nii']);

    gmf.img(:,:,:) = 0;
    gmf.img(indexes) = labels;
    save_nii(gmf, [fname '_labels.nii']);
    
    % ----------------- post-processing ----------------------------------
    my_smooth_spm(fullfile(pwd, [fname '_labels.nii']), [fwhm fwhm fwhm], 0);
	slnii = load_nii(['s' num2str(fwhm) fname '_labels.nii']);
	slnii.nii(slnii.img <= 0.25) = 0;
	slnii.nii(slnii.img > 0) = 1;
    
    pproc_cluster = 200;
    [~, slnii.nii] = distance_cluster(slnii.img, 26); %ET: clustering algorithm
	slnii.nii(slnii.img < pproc_cluster) = 0;
	slnii.nii(slnii.img > 0) = 1;
	save_nii(slnii, [slnii.fileprefix '_clustered.nii']);
    
    asx = toc(full);
    times = [times asx];
    
    % ----------------- DSC ----------------------------------------------
    matlabbatch=[];
    matlabbatch{1}.spm.util.defs.comp{1}.def = {['iy_' fname fext]}; % file path for inverse deformation field
    matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {['s' num2str(fwhm) fname '_labels_clustered.nii']}; % file path for reverse normalization
    matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savepwd = 1; % save in current directory 
    matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 7; %7th degree b-spline interpolation (values 4-7 can be used for 4th to 7th degree b-spline)
    matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 0; % no implicit masking 
    matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0]; % Gaussian smoothing kernel FWHM (can be applied to mask e.g. 8 8 8)
    spm_jobman('run',matlabbatch); % run job

    lbl = load_nii(fullfile(labelsDir, ['l' fname fext]));
    l = lbl.img;
    wf1 = load_nii(['ws' num2str(fwhm) fname '_labels_clustered.nii']);
    f = wf1.img;
    
    cutoff = max(max(max(f)))*.2;
    f(f>=cutoff) = 1;
    f(f<cutoff) = 0;
    f = uint8(f);
    
    sliceCnt = size(f,3);
    ratio = reshape((2*summ(f&l))./(summ(f)+summ(l)), 1, sliceCnt);
    areal = reshape(sum(sum(l)), 1, sliceCnt); %note: might find better whay than reshaping
    areaf = reshape(sum(sum(f)), 1, sliceCnt);
    mx = max([areal areaf])+100;
    areal = areal./mx;
    areaf = areaf./mx;
    
%     plot(1:sliceCnt, ratio, 'LineWidth', 2); hold on
%     plot(1:sliceCnt, areal, 'r--', 1:sliceCnt, areaf, 'g--'); hold off
%     xlabel('Slice number');
%     legend('Dice-Sorensen Coefficient','what should be','what i got')
%     title(fname);
% %     title([fname '; average DSC = ' num2str(sum(ratio))])
%     ylim([0 1]);
%     grid on
%     
%     fprintf('fwhm%i: max %.2f; sum %.2f\n',fwhm,max(ratio),sum(ratio(ratio>0)))

    rez(i,1) = fwhm;
    rez(i,2) = max(ratio);
    rez(i,3) = (2*summm(f&l))/(summm(f)+summm(l));
    
end

cd(origdir)
disp('  Done.')
timedAlarm(0,1)



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

function y = summ(x)
y = sum(sum(x));

function y = summm(x)
y = sum(sum(sum(x)));