%%
nSides = 1;
viewLimits = [60 120]; edgeLength = 1; lattice = zeros(180); radius = 20;
%%
[~, ~, colonyState] = specifyColonyInsideLattice(lattice, radius, nSides);
colonyState = colonyState([viewLimits(1):viewLimits(2)], [viewLimits(1):viewLimits(2)]);
[colonyEdgeIdx] = specifyRegionWithinColony(colonyState, edgeLength);       
%%
storeStates = storeStates([viewLimits(1):viewLimits(2)], [viewLimits(1):viewLimits(2)],:,:);

t1 = 100;
a_t0 = storeStates(:,:,1,t1);
figure; imagesc(a_t0);
hold on;
plot(colonyEdgeIdx(:,2), colonyEdgeIdx(:,1), 'k.', 'MarkerSize', 40);
caxis([0 1.2]); colorbar;
axis off;

%%
saveInPath = '/Volumes/SAPNA/1803257_PDEmodel_fft_movies/noDiffusionBMP/Parameters21/activatorEvolution';
saveAllOpenFigures(saveInPath);
