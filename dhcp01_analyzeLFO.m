%% dir settings (may not usable for you and you have to change them...)
clear all; clc
ana_dir = '/Users/mac/Projects/dHCP';
data_dir = '/Volumes/SeagateBackupPlusDrive/HCP/devhcp/dhcp-rel-1.1/';
ccs_dir = '/Users/mac/Projects/CCS';
ccs_matlab = [ccs_dir '/matlab'];
ccs_vistool = [ccs_dir '/vistool'];
fs_home = '/Applications/freesurfer';
fsaverage = 'fsaverage5';

%% Set up the path to matlab function in Freesurfer release
addpath(genpath(ccs_matlab)) %ccs matlab scripts
addpath(genpath(ccs_vistool)) %ccs matlab scripts
addpath(genpath([fs_home '/matlab'])) %freesurfer matlab scripts

%% Load surface model
FS_lh = SurfStatReadSurf({[fs_home '/subjects/' fsaverage ...
    '/surf/lh.inflated']} );
numVertices_lh = size(FS_lh.coord,2);
FS_rh = SurfStatReadSurf({[fs_home '/subjects/' fsaverage ...
    '/surf/rh.inflated']} );
numVertices_rh = size(FS_rh.coord,2);

%% Subjects list
fdemo = [data_dir '/demographics.xlsx'];
[~, ~, raw] = xlsread(fdemo,'demographics');
subjects = raw(2:end,1); nsubs = numel(subjects);
gender = raw(2:end,2); 
age_birth = cell2mat(raw(2:end,3));
age_scan = cell2mat(raw(2:end,4));
sex = zeros(nsubs,1);
% numberize
for sid=1:nsubs
    if strcmp(gender{sid}, 'M')
        sex(sid,1) = 1;
    else
        sex(sid,1) = 0;
    end
end

%% Reconstruct LFO maps: loop subjects
for subid=1:nsubs
    subject = subjects{subid};
    disp(['Getting LFO maps for subject ' subject ' ...'])
    sub_dir = [data_dir '/derivatives/sub-' subject];
    sess_list = dir(sub_dir);
    sess_name = sess_list(end).name;
    func_dir = [sub_dir '/' sess_name '/func'];
    %load brain mask
    fmask = [func_dir '/sub-' subject '_' sess_name '_task-rest_brainmask.nii.gz'];
    maskhead = load_nifti(fmask); maskvol = squeeze(maskhead.vol);
    maskvec = reshape(maskvol,numel(maskvol),1); 
    idx_mask = find(maskvec==1); numVXL = numel(idx_mask);
    %load rest-bold time series
    fbold = [func_dir '/sub-' subject '_' sess_name '_task-rest_bold.nii.gz'];
    boldhead = load_nifti(fbold); boldvol = squeeze(boldhead.vol); 
    [numX, numY, numZ, numTR] = size(boldvol); TR = boldhead.pixdim(5)/1000;
    boldmat = reshape(boldvol,numel(maskvol),numTR);
    [~, freqbands] = ccs_core_lfoamplitudes(rand(numTR,1), TR, 'false', 'false');
    lfoamps = zeros(numVXL,numel(freqbands),2);
    %loop voxels
    for vxlID=1:numVXL
        if ~mod(vxlID,1000)
            disp(['Completing ' num2str(vxlID/numVXL*100) ' percent voxels processed ...'])
        end
        time_series = boldmat(idx_mask(vxlID),:);
        [tmpamps, ~] = ccs_core_lfoamplitudes(time_series, TR);
        lfoamps(vxlID,:,:) = tmpamps;
    end
    %loop freq bands
    for fID=1:numel(freqbands)
        %make lfo dir
        lfo_dir = [func_dir '/LFO'];
        if ~exist(lfo_dir,'dir')
            mkdir(lfo_dir);
        end
        %alff
        tmpalff = zeros(size(maskvec)); 
        tmpalff(idx_mask) = squeeze(lfoamps(:,fID,1));
        tmpalff = reshape(tmpalff,numX, numY, numZ);
        tmphead = maskhead; tmphead.datatype = 16; 
        tmphead.descrip = ['CCS-ALFF ' date]; tmphead.vol = tmpalff;
        fout = [lfo_dir '/alff.lfo' num2str(fID) '.native.nii.gz'];
        err1 = save_nifti(tmphead, fout);
        %falff
        tmpfalff = zeros(size(maskvec)); 
        tmpfalff(idx_mask) = squeeze(lfoamps(:,fID,2));
        tmpfalff = reshape(tmpfalff,numX, numY, numZ);
        tmphead = maskhead; tmphead.datatype = 16; 
        tmphead.descrip = ['CCS-fALFF ' date]; tmphead.vol = tmpfalff;
        fout = [lfo_dir '/falff.lfo' num2str(fID) '.native.nii.gz'];
        err2 = save_nifti(tmphead, fout);
    end
end

