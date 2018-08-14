
%% run simulation.
% specify number of components in parameter file.

clear global userParam
clearvars;

paramfile = 'setUserParameter_simpleAI';
global userParam

eval(paramfile);

nSides = userParam.nSides(1);
radius = userParam.colonyRadius(1);
kappa = userParam.kappa;
fhandle =  userParam.fhandle;

saveInPath = ['/Volumes/sapnaDrive2/180522_modelSimulation/travellingWave_noBMP_noI2_fft/Parameters4_noBasal_10_kappa0_highkd/lattice']; % path to save .mat output files
mkdir(saveInPath);
%%
runMeinhartPDE(fhandle,  kappa, radius, nSides, saveInPath);
%%
%% view and save output as a video
%%
saveInPath_masterFolder = '/Volumes/SAPNA/1803257_PDEmodel_fft_movies/noDiffusionBMP_movies/Parameters1';
matFilesPath_masterFolder = '/Volumes/SAPNA/1803257_PDEmodel_fft_movies/noDiffusionBMP/Parameters1'; % path to the output files

component = 1:3; % component for which you want to view the results

matFilesPrefix = 'k1radius20'; % .mat output file prefix (part before _t1.mat)


shapes = {'Circles', ' ', 'Triangle', 'Square'};
for nSides = [1 3 4]
    radius = 20;
    
    aviFilesPath = [saveInPath_masterFolder filesep shapes{nSides}];
    mkdir(aviFilesPath);
    
    matFilesPath = [matFilesPath_masterFolder filesep shapes{nSides}]; 
 
    for ii = component
        aviFilesPrefix = ['component' int2str(component)];
        saveasAvi_1component(matFilesPath, matFilesPrefix, aviFilesPath, aviFilesPrefix, ...
            radius, nSides, ii)
    end
end
%%






