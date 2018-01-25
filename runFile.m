
%% run simulation.
% specify number of components in parameter file.

clear global userParam
clearvars;
saveInPath = '/Users/sapnachhabra/Desktop/modelTry/tw/bmp_high_everwhere/1'; mkdir(saveInPath); 
% path to save .mat output files

paramfile = 'setUserParameter_travellingWave'; 
global userParam

eval(paramfile);

nSides = userParam.nSides(1);
radius = userParam.colonyRadius(1);
kappa = userParam.kappa;
fhandle =  userParam.fhandle;

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






