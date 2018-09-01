%% ------- view activator, inhibitor and their ratio for all shapes at last timepoint.  

%close all;
masterFolder = '/Users/sapna/Desktop/testModel/Parameters4_check3/';
shapes = {'Circles', 'Triangle', 'pacman'};
outputFile = 'k0radius25_t100.mat';
quadrantCut = [0 0 1]; nSides = [1 3 1]; colonRadius = 25;
lattice = zeros(190);
%%
for ii = 1:3
    outputFile2 = [masterFolder filesep shapes{ii} filesep outputFile];
    load(outputFile2);
    [~, ~, colonyState] = specifyColonyInsideLattice(lattice, colonyRadius, nSides(ii), quadrantCut(ii));
   
    activator = (storeStates(:,:,1,100)).*colonyState;
    inhibitor = (storeStates(:,:,2,100)).*colonyState;
    Ia_ratio = inhibitor./activator;
    Ia_ratio(isinf(Ia_ratio)) = 0;
    Ia_ratio(isnan(Ia_ratio)) = 0;
    Ia_ration = Ia_ratio.*colonyState;
    
    figure;
    subplot(1,3,1); imagesc(activator); colorbar; caxis([0 12]);
    subplot(1,3,2); imagesc(inhibitor); colorbar; caxis([0 800]);
    subplot(1,3,3); imagesc(Ia_ratio); colorbar; caxis([0 100]);
end
%%
