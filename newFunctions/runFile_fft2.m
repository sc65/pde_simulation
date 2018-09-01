%% ---------- varying activator diffusion constant 
clear global userParam
clearvars;

addpath(genpath('/Users/sapnachhabra/Desktop/CellTrackercd/model/PDE'));
%%
saveInPath_masterFolder  = '/Volumes/sapnaDrive2/180522_modelSimulation/travellingWave_noBMP_noI2_fft/Parameters4_check3_differentDa/outputFiles';
mkdir(saveInPath_masterFolder);
% path to save .mat output files

paramFile = 'setUserParameter_AI_modified_fft2';
global userParam
eval(paramFile);

shapes = {'Circles', ' ', 'Triangle', 'Square'};
radius = userParam.colonyRadius;

activatorDiffusion = linspace(0.001, 0.04, 10);
kappa = [0 0.1];
%%
activatorDiffusion = [0.001 0.0025 0.0053 0.0097 0.014];
for ii = activatorDiffusion
    userParam.Dc(1) = ii;
    saveInPath1 = [saveInPath_masterFolder filesep 'Da' num2str(ii)];
    mkdir(saveInPath1); 
    for jj = kappa
        userParam.kappa = jj;
        for kk = 1:numel(userParam.nSides)
            if userParam.nSides(kk) == 1 & userParam.quadrantCut == 1
                suffix = 'pacman';
            elseif userParam.nSides(kk) == 1 & userParam.quadrantCut == 2
                suffix = 'semicircle';
            elseif userParam.nSides(kk) == 0
                suffix = 'lattice';
            else
                suffix = shapes{userParam.nSides(kk)};
            end
            saveInPath2 = [saveInPath1 filesep suffix];
            mkdir(saveInPath2);
            runMeinhardt_AI_modified_fft2(jj, radius, userParam.nSides(kk), saveInPath2);
        end
    end
end
%%
