
%% to continue a previous simulation

clearvars;
saveInPath = '/Users/sapnachhabra/Desktop/modelTry/1'; mkdir(saveInPath); 
% path to saved .mat output files from previous simulation

paramfile = 'setUserParameter_simpleAI'; 
global userParam

fhandle = eval(paramfile);

nSides = userParam.nSides(1);
radius = userParam.colonyRadius(1);
kappa = userParam.kappa;
runMeinhartPDE_continue(fhandle,  kappa, radius, nSides, saveInPath)