
%% run simulation.
% specify number of components in parameter file.

clear global userParam
clearvars;
saveInPath = '/Users/sapnachhabra/Desktop/modelTry/tw/bmp_high_everwhere/3_2_lowD_highInhibition'; mkdir(saveInPath); 
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

matFilesPrefix = 'k1radius35'; % .mat output file prefix (part before _t1.mat)
matFilesPath = saveInPath; % path to the output files

component = 3; % component for which you want to view the results
aviFilesPath =  saveInPath; % path to save the results

aviFilesPrefix = ['component' int2str(component)];


for ii = component
    saveasAvi_1component(matFilesPath, matFilesPrefix, aviFilesPath, aviFilesPrefix, ...
        radius, nSides, ii)    
end






