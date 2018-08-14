
clearvars; clear global userParam;
addpath(genpath('/Users/sapnachhabra/Desktop/CellTrackercd/model/PDE'));

%%
masterFolder = '/Volumes/sapnaDrive2/180522_modelSimulation/travellingWave_noBMP_noI2_fft/Parameters4_check3';
colonyShapes = {'Circles', 'Triangle', 'Square'};
nSides = [1; 3;4];
outputFiles_prefix = 'k0radius25';

outputFiles_Id = [1:100]; 
%simulation output stored across multiple files - fileIds used in
%fateRules. 

%------ model with bmp 
% threshold1 = 4.8; % inhibitor/activator
% threshold2 = 3.6; % bmp
% threshold3 = 0.4; % activator

% ----- activator-inhibitor model, threshold based
threshold1 = 25; % inhibitor/activator high
threshold2 = 8.0; % activator high
%%
allFates = cell(1, length(colonyShapes));
steadyState_timepoint = 40;
for ii = 2:3
%for ii = 1:3
%for ii = 1:numel(colonyShapes)
    outputFiles_path = [masterFolder filesep colonyShapes{ii}];
    %steadyState_timepoint = findSteadyState(outputFiles_path, outputFiles_Id, outputFiles_prefix, nSides);
    
    allFates{ii} = fateRules_aI_1(nSides(ii), outputFiles_path, outputFiles_prefix, ...
        outputFiles_Id(1:steadyState_timepoint), threshold1, threshold2);
end
%%
outputFile = [masterFolder filesep 'output_threshold.mat'];
save(outputFile, 'allFates', 'threshold1', 'threshold2');

%%
% zoom onto colony
allFates_small = allFates;
limits_y = {[65, 115], [65, 115], [65, 110]};
limits_x = {[65, 115], [60 120], [65 110]};

for ii = 1:3
    
    a1 = allFates{ii};
    allFates_small{ii} = a1([limits_y{ii}(1):limits_y{ii}(2)], [limits_x{ii}(1):limits_x{ii}(2)]);
    
    figure; imagesc(allFates_small{ii}); colormap(jet);
end

%%
close all;
for ii= 1:3
    figure; imagesc(allFates_small{ii});colormap(jet);
end