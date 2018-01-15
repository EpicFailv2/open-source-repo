function rez = et_dsc()

origdir = cd;

srcNiiDir = 'D:\Games\MATLAB R2015a\_et files\Masters\mri_filtered\source'; % folder with FMRI scan .nii files (needs L or R at the name end to indicate damaged hamisphere)
labelsDir = 'D:\Games\MATLAB R2015a\_et files\Masters\mri_filtered\labels'; % folder with hand drawn lesion areas for patients (name: ['l' patient_nii_file_name] <- that is small L) 
wrkDirRoot= 'D:\Games\MATLAB R2015a\_et files\Masters\etOutput\fullRun2\'; % folder where folders with generated data will be placed
pngDir =    'D:\Games\MATLAB R2015a\_et files\Masters\DSCplots\fullETrun2\et_dscrun\'; % folder for DSC plot placement

fwhm = 11;
srcNii = dir(srcNiiDir);
sub = 0;
for i =1:length(srcNii)
    [~, fname, fext] = fileparts(srcNii(i).name);
    if srcNii(i).isdir; disp('Not .nii'); sub = sub + 1; continue; end
    disp(['--- Cycle #' num2str(i) ' [' fname '] ---']);
    
    workDir = [wrkDirRoot fname];
    cd(workDir)
    
%     if ~exist(['ws' fwhm 'lesion_labels_clustered_500.nii'],'file')
%         matlabbatch=[];
%         matlabbatch{1}.spm.util.defs.comp{1}.def = {['iy_' fname fext]}; % file path for inverse deformation field
%         matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {'s8lesion_labels_clustered_500.nii'}; % file path for reverse normalization
%         matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savepwd = 1; % save in current directory 
%         matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 7; %7th degree b-spline interpolation (values 4-7 can be used for 4th to 7th degree b-spline)
%         matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 0; % no implicit masking 
%         matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0]; % Gaussian smoothing kernel FWHM (can be applied to mask e.g. 8 8 8)
%         spm_jobman('run',matlabbatch); % run job
%     end

    lbl = load_nii(fullfile(labelsDir, ['l' fname fext]));
    l = lbl.img;
    wf1 = load_nii(['ws11' fname '_labels_clustered.nii']);
    f = wf1.img;
    
    cutoff = max(max(max(f)))*.325;
    f(f>=cutoff) = 1;
    f(f<cutoff) = 0;
    f = uint8(f);
    
%     sliceCnt = size(f,3);
%     ratio = reshape((2*summ(f&l))./(summ(f)+summ(l)), 1, sliceCnt);
%     areal = reshape(summ(l), 1, sliceCnt); %note: might find better whay than reshaping
%     areaf = reshape(summ(f), 1, sliceCnt);
%     mx = max([areal areaf])+100;
%     areal = areal./mx;
%     areaf = areaf./mx;
%     
%     plot(1:sliceCnt, ratio, 'LineStyle', '-', 'Color', [0 .4 .75], 'LineWidth', 2); hold on
%     plot(1:sliceCnt, areal, 'LineStyle', '--', 'Color', [1 0 0]); 
%     plot(1:sliceCnt, areaf, 'LineStyle', '--', 'Color', [0 .5 0]); hold off
%     xlabel('Slice number'); ylabel('DSC');
%     legend('DSC','Manual','Automatic')
%     title([strrep(fname(1:end-2),'_','') '; total DSC = ' num2str((2*summm(f&l))./(summm(f)+summm(l)))]);
%     ylim([0 1]);
%     grid on
%     
%     printPlot(fname,pngDir,0,0);
    
%     break;
%     if i > 10; break; end

%     rez(i-sub)=(2*summm(f&l))./(summm(f)+summm(l));
    rez(i-sub)=(summm(f)*100)/(size(f,1)*size(f,2)*size(f,3));
end

cd(origdir)
disp('  Done.')

function y = summ(x)
y = sum(sum(x));

function y = summm(x)
y = sum(sum(sum(x)));