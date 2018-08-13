
addpath(genpath('/Users/sapnachhabra/Desktop/CellTrackercd/model/PDE/simple2D'));
%%
saveInPath_masterFolder = '/Volumes/SAPNA/1803257_PDEmodel_fft_movies/noDiffusionBMP_movies/Parameters11';
matFilesPath_masterFolder = '/Volumes/SAPNA/1803257_PDEmodel_fft_movies/noDiffusionBMP/Parameters11'; % path to the output files

matFilesPrefix = 'k1radius20'; % .mat output file prefix (part before _t1.mat)
aviFilesPrefix = ['IA_ratio_'];

shapes = {'Circles', ' ', 'Triangle', 'Square'};
for nSides = [1 3 4]
    radius = 20;
    
    aviFilesPath = [saveInPath_masterFolder filesep shapes{nSides}];
    mkdir(aviFilesPath);
    
    matFilesPath = [matFilesPath_masterFolder filesep shapes{nSides}];
    
    saveAsAvi_AI_ratio(matFilesPath, matFilesPrefix, aviFilesPath, aviFilesPrefix, ...
        radius, nSides);  
end
%%