clear global userParam
clearvars;

addpath(genpath('/Users/sapnachhabra/Desktop/CellTrackercd/model/PDE'));
%%
saveInPath_masterFolder  = '/Volumes/sapnaDrive2/180522_modelSimulation/travellingWave_noBMP_noI2_fft/Parameters4_check3_differentDa/outputFiles';
mkdir(saveInPath_masterFolder);
% path to save .mat output files

global userParam

shapes = {'Circles', ' ', 'Triangle', 'Square'};

activatorDiffusion = linspace(0.001, 0.04, 10);
kappa = [0 0.1]; nSides = [0 1 3]; quadrantCut = [0 0 0];
%
tMax = 30000; %run simulation for tMax more timepoints (moreFiles: tMax/(writeInFileEvery*updateEvery*dt));
%%
%activatorDiffusion = [0.001 0.0025 0.0053 0.0097 0.014];
for ii = activatorDiffusion(6:10)
    saveInPath1 = [saveInPath_masterFolder filesep 'Da' num2str(ii)];
    for jj = kappa
        for kk = 1:numel(nSides)
            if nSides(kk) == 1 & quadrantCut(kk) == 1
                shapesSuffix = 'pacman';
            elseif nSides(kk) == 1 & quadrantCut(kk) == 2
                shapesSuffix = 'semicircle';
            elseif nSides(kk) == 0
                shapesSuffix = 'lattice';
            else
                shapesSuffix = shapes{nSides(kk)};
            end
            saveInPath2 = [saveInPath1 filesep shapesSuffix filesep 'k' num2str(jj)];
            
            outputFiles = dir([saveInPath2 filesep '*.mat']);
            load([outputFiles(1).folder filesep outputFiles(end).name], 'storeStates', 'userParam');
            
            fileSuffix = size(outputFiles,1) + 1;
            runMeinhardt_AI_modified_fft2_continue(storeStates, fileSuffix, tMax, jj, nSides(kk), saveInPath2);
        end
    end
end
%%
