function sr = regui(num_iters)
%REGUI Select files via UI and call registration function
%   Detailed explanation goes here

if ~exist('num_iters', 'var')
    num_iters = 10;
end

z = 3;

% Suppress "Error updating Button" warning
warning('off', 'MATLAB:handle_graphics:exceptions:SceneNode');

% Select data files via user input
[lmat, path] = uigetfile('*.tif;*.tiff', "Select label matrix (anatomical)");
lmat = fullfile(path, lmat);
[img, path] = uigetfile(fullfile(path, '*.tif;*.tiff'), "Select image stack (anatomical)");
img = fullfile(path, img);
[cnmf, path] = uigetfile(fullfile(path, '*.mat'), "Select CNMF data (functional)");
cnmf = fullfile(path, cnmf);

% Read data files
lmat = bigread2(lmat);
img = bigread2(img);

S = whos('-file',fullfile(path,'002_z03_cnmf.mat'));
nam = cell2mat(regexp(cell2mat({S.name}),'(?i)cnmf?','match'));
load(cnmf, nam);

% Reformat data for function input
scene = exctrs2(lmat(:,:,z));
scene = scene(:, 2:3);
scn_im = img(:,:,z);

model = fliplr(CNM.cm);
model = model(:, 1:2);
mdl_im = mean(CNM.Y, 3);

% Run similarity registration
sr = sim_icp2(scene, scn_im, model, mdl_im, num_iters);

end

