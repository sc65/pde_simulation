%%  --------- save movies of activator and inhibitor varying in time.
clear global userParam; clearvars;

saveInPath_masterFolder = '/Volumes/sapnaDrive2/180522_modelSimulation/travellingWave_noBMP_noI2_fft/Parameters4_check3_differentDa/movies';
mkdir(saveInPath_masterFolder);

matFilesPath_masterFolder = '/Volumes/sapnaDrive2/180522_modelSimulation/travellingWave_noBMP_noI2_fft/Parameters4_check3_differentDa'; % path to the output files

component = 1:2; % component for which you want to view the results
matFilesPrefix = 'radius25'; % .mat output file prefix (part before _t1.mat)
radius = 25;
quadrantCut = 0; % for pacman, quadrantCut = 1, for semi-circle, quadrantCut = 2;
nSides = [0 3];

%%

shapes = {'Circles', ' ', 'Triangle', 'Square'};
for ii = nSides
    if ii == 1 & userParam.quadrantCut == 1
        suffix = 'pacman';
    elseif ii == 1 & userParam.quadrantCut == 2
        suffix = 'semicircle';
    elseif ii == 0
        suffix = 'lattice';
    else
        suffix = shapes{ii};
    end
    
    aviFilesPath = [saveInPath_masterFolder filesep suffix];
    mkdir(aviFilesPath);
    
    matFilesPath = [matFilesPath_masterFolder filesep suffix];
    for jj = component
        aviFilesPrefix = ['component' int2str(jj)];
        saveasAvi_1component(matFilesPath, matFilesPrefix, aviFilesPath, aviFilesPrefix, ...
            radius, ii, quadrantCut, jj);
    end
end
%%