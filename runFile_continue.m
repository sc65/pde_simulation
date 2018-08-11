
%% to continue a previous simulation
clear global userParam;
clearvars except saveInPath;
%saveInPath =  '/Users/sapnachhabra/Desktop/modelTry/AI/bmp_high_everwhere/3_2_highD_highInhibition_noI2'; 
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