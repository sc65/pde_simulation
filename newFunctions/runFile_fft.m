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
for ii = 1:numel(userParam.nSides)
    if userParam.nSides(ii) == 1 & userParam.quadrantCut == 1
        suffix = 'pacman';
    elseif userParam.nSides(ii) == 1 & userParam.quadrantCut == 2
        suffix = 'semicircle';
    elseif userParam.nSides(ii) == 0
        suffix = 'lattice';
    else
        suffix = shapes{userParam.nSides(ii)};
    end
    saveInPath = [saveInPath_masterFolder filesep suffix];
    mkdir(saveInPath);
    runMeinhardt_AI_modified_fft(kappa, radius, userParam.nSides(ii), saveInPath); 
end
%%
