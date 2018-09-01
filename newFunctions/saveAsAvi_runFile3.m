%%
%% -------------------------------------- different diffusion constants. 
clearvars;
masterFolder = '/Volumes/sapnaDrive2/180522_modelSimulation/travellingWave_noBMP_noI2_fft/Parameters4_check3_differentDa';
Da_files = dir([masterFolder filesep 'outputFiles' filesep 'Da*']);

saveInPath = [masterFolder filesep 'movies'];

component = 1:2; % component for which you want to view the results
matFilesPrefix = 'radius25'; % .mat output file prefix (part before _t1.mat)
radius = 25; 
quadrantCut = 0; % for pacman, quadrantCut = 1, for semi-circle, quadrantCut = 2;
nSides = [0 1 3];
shapes = {'Circles', ' ', 'Triangle', 'Square'};
%%
for ii = [3 6 7]
%for ii = 1:numel(Da_files) % each Da
    Da_filesPath = [Da_files(ii).folder filesep Da_files(ii).name];
     
    for jj = nSides % each shape
        if jj == 1 & quadrantCut == 1
            shapeSuffix = 'pacman';
        elseif jj == 1 & quadrantCut == 2
            shapeSuffix = 'semicircle';
        elseif jj == 0
            shapeSuffix = 'lattice';
        else
            shapeSuffix = shapes{jj};
        end
        
        matFilesPath = dir([Da_filesPath filesep shapeSuffix filesep 'k*']);
        
        for kk = 1:2
        %for kk = 1:numel(matFilesPath) % each kappa
            matFilesPath1 = [Da_filesPath filesep shapeSuffix filesep matFilesPath(kk).name];
            kappa = matFilesPath(kk).name;
            
            aviFilesPath = [saveInPath filesep kappa filesep shapeSuffix];
            mkdir(aviFilesPath);
            aviFilesPrefix = Da_files(ii).name;
            
            for ll = component(1)
                saveasAvi_1component(matFilesPath1, matFilesPrefix, aviFilesPath, aviFilesPrefix, ...
                    radius, jj, quadrantCut, ll);
            end
        end
    end
end