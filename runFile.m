
%% run simulation.
% specify number of components in parameter file.

clearvars;
saveInPath = '/Users/sapnachhabra/Desktop/modelTry/2'; mkdir(saveInPath); 
% path to save .mat output files

paramfile = 'setUserParameter_travellingWave'; 
global userParam

fhandle = eval(paramfile);

nSides = userParam.nSides(1);
radius = userParam.colonyRadius(1);
kappa = userParam.kappa;

runMeinhartPDE(fhandle,  kappa, radius, nSides, saveInPath);
%%
%% view and save output as a video
%%
matFilesPath = saveInPath;
matFilesPrefix = 'k1radius25';

aviFilesPath =   saveInPath;
aviFilesPrefix = 'component1';

component = 1;

for ii = 1
    saveasAvi_1component(matFilesPath, matFilesPrefix, aviFilesPath, aviFilesPrefix, ...
        radius, nSides, ii)    
end
%% ---- continue a simulation

runMeinhartPDE_continue(fhandle,  kappa, radius, nSides, saveInPath)








