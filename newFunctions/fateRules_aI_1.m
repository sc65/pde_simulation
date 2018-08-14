function allFates = fateRules_aI_1(nSides, matFilesPath, matFilesPrefix, outputFiles_Id, threshold1, threshold2)
%% ------------- for a 2 component activator inhibitor system, threshold based

% rule 1: - region that experiences >threshold1 inhibitor/activator ratio for >=10 consecutive time
% points unresponsive to activator - pluripotent

% rule 2: activator concentration >threshold2 -> mesendoderm fates

% rule 3: rest -> trophectoderm fate

%%


counter = 1;
for ii = outputFiles_Id
    outputFile = [matFilesPath filesep matFilesPrefix  '_t' int2str(ii) '.mat'];
    load(outputFile, 'storeStates', 'userParam');
    
    if ii == outputFiles_Id(1) % get the colony boundary
        nSquares = size(storeStates,1);
        edgeLength = 1;
        lattice = false(nSquares);
        [~, ~, colonyState] = specifyColonyInsideLattice(lattice, userParam.colonyRadius, nSides);
        [colonyEdgeIdx] = specifyRegionWithinColony(colonyState, edgeLength);
        
        activator = storeStates(:,:,1,1);
        inhibitor = storeStates(:,:,2,1);
        Ia_ratio = inhibitor./activator;
        Ia_ratio(isnan(Ia_ratio)) = 0;
        
        Ia_ratio = Ia_ratio.*colonyState; % to keep values only inside the colony.
        Ia_ratio_all(:,:,counter) = Ia_ratio;
        counter = counter + 1;
        
        % ------- for activator region
        % 1) Max activator at a given timepoint
        % 2) Max total activator during simulation (steady state value)
        % 3) Max instantaneous change
        % 4) Max total change
        activator1_max  = zeros(nSquares);
        activatorTotal_max = activator1_max;
        activator_change1_max = activator1_max;
        activator_changeTotal_max  = activator1_max;
        
        actvator_firstValue = squeeze(storeStates(:,:,1,end));
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
    
    activatorValues = squeeze(storeStates(:,:,1,:));
    activator1_max = max(cat(3, activator1_max, activatorValues),[],3); % 1)
    activatorTotal_max = sum(cat(3, activatorTotal_max ,activatorValues > threshold2), 3); %2)
    
    
    if ii == outputFiles_Id(1)
        activator_derivative  = diff(squeeze(storeStates(:,:,1,:)), 1, 3);
    else
        activator_derivative = diff(cat(3, activator_lastValue, squeeze(storeStates(:,:,1,:))), 1, 3);
    end
    
    activator_change1_max = max(cat(3, activator_change1_max, activator_derivative),[], 3); % 3)
    activator_changeTotal_max = sum(cat(3, activator_changeTotal_max, activator_derivative), 3); % 4)
    
    activator_lastValue = squeeze(storeStates(:,:,1,end));
end


activator_end = storeStates(:,:,1,end);
%%
inhibitorRegion = findRegionWithHighInhibitorActivtorRatio(Ia_ratio_all, threshold1);

%% -------------- brachyuryfate

%figure; imagesc(activator_end);

%threshold3 = 0.6;
activator_idx = find(activator_end > threshold2);

activatorRegion = zeros(nSquares);
activatorRegion([activator_idx']) = 1;

activatorRegion = activatorRegion.*(~inhibitorRegion);
figure; imagesc(activatorRegion);

%%
activatorRegion(activatorRegion == 1) = 100;
inhibitorRegion(inhibitorRegion == 1) = 200;

bmpRegion = colonyState.*(~activatorRegion).*(~inhibitorRegion);
bmpRegion(bmpRegion == 1) = 300;

allFates = activatorRegion+inhibitorRegion+bmpRegion;

figure; imagesc(allFates);colorbar; caxis([0 300]);
%hold on; plot(colonyEdgeIdx(:,2), colonyEdgeIdx(:,1), 'k.');
end