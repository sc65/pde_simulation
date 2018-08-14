function allFates = fateRules(radius, nSides, matFilesPath, matFilesPrefix, nTimePoints, threshold1, threshold2, threshold3)
% rule 1: - region that experiences >5 inhibitor/activator ratio for >=10 consecutive time
% points unresponsive to activator, bmp 

% rule 2: activator concentration >1 -> mesendoderm fates

% rule 3: rest -> trophectoderm fate

%%
counter = 1;
for ii = 1:nTimePoints
    outputFile = [matFilesPath filesep matFilesPrefix  '_t' int2str(ii) '.mat'];
    load(outputFile, 'storeStates');
    
    if ii == 1 % get the colony boundary
        nSquares = size(storeStates,1);
        edgeLength = 1;
        lattice = false(nSquares);
        [~, ~, colonyState] = specifyColonyInsideLattice(lattice, radius, nSides);
        [colonyEdgeIdx] = specifyRegionWithinColony(colonyState, edgeLength);
        
        activator = storeStates(:,:,1,1);
        inhibitor = storeStates(:,:,2,1);
        Ia_ratio = inhibitor./activator;
        Ia_ratio(isnan(Ia_ratio)) = 0;
        
        Ia_ratio = Ia_ratio.*colonyState; % to keep values only inside the colony. 
        Ia_ratio_all(:,:,counter) = Ia_ratio;
        counter = counter + 1;
    end
    timeSteps = size(storeStates,4);
    
    for kk = [1:timeSteps] % each file has multiple timesteps
        activator = storeStates(:,:,1,kk);
        inhibitor = storeStates(:,:,2,kk);
        Ia_ratio = inhibitor./activator;
        Ia_ratio(isnan(Ia_ratio)) = 0;
        
        Ia_ratio = Ia_ratio.*colonyState; % to keep values only inside the colony. 
        
        Ia_ratio_all(:,:,counter) = Ia_ratio;
        counter = counter + 1;
    end
end

activator_end = storeStates(:,:,1,end);
bmp_end = storeStates(:,:,3,end);
%%
inhibitorRegion = findRegionWithHighInhibitorActivtorRatio(Ia_ratio_all, threshold1);

%% -------------- fate1 
figure; imagesc(bmp_end);

%threshold2 = 5.2;
bmp_idx = find(bmp_end > threshold2);

bmp = zeros(180); 
bmp([bmp_idx']) = 1;

bmp = bmp.*colonyState;
bmp = bmp.*(~inhibitorRegion);
figure; imagesc(bmp); 

%% -------------- fate2
figure; imagesc(activator_end);

%threshold3 = 0.6;
activator_idx = find(activator_end > threshold3);

activatorRegion = zeros(180);
activatorRegion([activator_idx']) = 1;

activatorRegion = activatorRegion.*(~inhibitorRegion).*(~bmp);
figure; imagesc(activatorRegion);

%% 
bmp(bmp == 1) = 100;
activatorRegion(activatorRegion == 1) = 200;
inhibitorRegion(inhibitorRegion == 1) = 300;

allFates = bmp+activatorRegion+inhibitorRegion;

figure; imagesc(allFates);colorbar; caxis([0 300]);
%hold on; plot(colonyEdgeIdx(:,2), colonyEdgeIdx(:,1), 'k.');
end