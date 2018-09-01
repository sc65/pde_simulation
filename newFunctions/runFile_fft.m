%%
clear global userParam
clearvars;

addpath(genpath('/Users/sapnachhabra/Desktop/CellTrackercd/model/PDE'));
%%
saveInPath_masterFolder  = '/Volumes/sapnaDrive2/180522_modelSimulation/travellingWave_noBMP_noI2_fft/Parameters4_check3_smallLatice';
mkdir(saveInPath_masterFolder);
% path to save .mat output files

paramFile = 'setUserParameter_AI_modified_fft2';
global userParam
eval(paramFile);

shapes = {'Circles', ' ', 'Triangle', 'Square'};
%%
for radius = userParam.colonyRadius
    saveInPath1 = [saveInPath_masterFolder filesep 'radius' int2str(radius)];
    mkdir(saveInPath1); 
    
    for kappa = userParam.kappa
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
            saveInPath2 = [saveInPath1 filesep suffix];
            mkdir(saveInPath2);
            runMeinhardt_AI_modified_fft2(kappa, radius, userParam.nSides(ii), saveInPath2);
        end
    end
end
%%
