
%% to continue a previous simulation
clear global userParam;
clearvars;
saveInPath =  '/Users/sapnachhabra/Desktop/modelTry/tw/bmp_high_everwhere/1_2'; mkdir(saveInPath); 
% path to saved .mat output files from previous simulation
outputFiles = dir([saveInPath filesep '*.mat']);

global userParam
load([outputFiles(1).folder filesep outputFiles(1).name], 'userParam');
%%

fhandle = userParam.fhandle;
nSides = userParam.nSides(1);
radius = userParam.colonyRadius(1);
kappa = userParam.kappa;

runMeinhartPDE_continue(fhandle,  kappa, radius, nSides, saveInPath)