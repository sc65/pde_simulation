%%
clear global userParam
clearvars;

addpath(genpath('/Users/sapnachhabra/Desktop/CellTrackercd/model/PDE'));
%%
saveInPath_masterFolder  = '/Volumes/sapnaDrive2/180522_modelSimulation/travellingWave_noBMP_noI2_fft/Parameters4_check3';
mkdir(saveInPath_masterFolder);
% path to save .mat output files

paramFile = 'setUserParameter_AI_modified_fft';
global userParam
eval(paramFile);

radius = userParam.colonyRadius(1);
kappa = userParam.kappa;
shapes = {'Circles', ' ', 'Triangle', 'Square'};
%%
for nSides = userParam.nSides
    
    if nSides == 1 & userParam.quadrantCut == 1
        suffix = 'pacman';
    elseif nSides == 1 & userParam.quadrantCut == 2
        suffix = 'semicircle';
    else
        suffix = shapes{nSides};
    end
    
    saveInPath = [saveInPath_masterFolder filesep suffix];
    mkdir(saveInPath);
    runMeinhardt_AI_modified_fft(kappa, radius, nSides, saveInPath); 
end
%%
