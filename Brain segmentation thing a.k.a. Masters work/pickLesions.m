function pickLesions

srcNiiDir = 'D:\Games\MATLAB R2015a\_et files\Masters\mri\orig';
labelsDir = 'D:\Games\MATLAB R2015a\_et files\Masters\mri\labelled';
outputRoot= 'D:\Games\MATLAB R2015a\_et files\Masters\mri_filtered'; 

if ~isdir(outputRoot); 
    mkdir(outputRoot); 
    mkdir(fullfile(outputRoot,'source'));
    mkdir(fullfile(outputRoot,'labels'));
end
    
total = 0;
srcNii = dir(srcNiiDir);
for i = 1:length(srcNii)
    [~, fname, fext] = fileparts(srcNii(i).name);
    disp(' ');
    disp(['--- Cycle #' num2str(i) ' [' fname '] ---']);
    if srcNii(i).isdir; disp('Not .nii'); continue; end
    
    nii = load_nii(fullfile(labelsDir,['l' fname fext]));
    mpoint = ceil(size(nii.img,1)/2);
    
    L = summm(nii.img(1:mpoint,:,:));
    R = summm(nii.img(mpoint:end,:,:));
    
    if (L && ~R) || (~L && R)
        % maybe insert check is single cluster, but for now overal size check will do
        if L < 5e3 && R < 5e3
            disp('Too small lesion size')
            continue;
        else if L > R 
                hs = '_L';
            else
                hs = '_R';
            end
        end
    else
        disp('Both hemispheres damaged. Skip! ');
        continue;
    end
    
    copyfile(fullfile(srcNiiDir,[fname fext]), fullfile(outputRoot,'source',[fname(1:5) hs fext]));
    copyfile(fullfile(labelsDir,['l' fname fext]), fullfile(outputRoot,'labels',['l' fname(1:5) hs fext]));
    
    total = total +1;
end

disp(' ')
disp(['Total copied files = ' num2str(total)])



function y = summm(x)
y = sum(sum(sum(x)));

% function [my_clust, L] = ze_cluster(niiimg, con_n) % nepakuriau
% 
% if max(niiimg(:) ~= 0)
%         
%     [D ~] = bwdist(niiimg);
%     my_mask = zeros(size(niiimg));
%     my_mask(D==0) = 1;
%     [L NUM] = bwlabeln(my_mask, con_n);
%     if NUM ~= 0
%         my_clust = zeros(NUM,1);
%         for j = 1:NUM
%             my_clust(j) = numel(L(L==j));
%             L(L == j) = numel(L(L==j));
%         end
%     end
% else
%     my_clust = 0;
%     vol_size = size(niiimg);
%     L  = zeros(vol_size);
% end