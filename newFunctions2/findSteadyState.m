function steadyState_timepoint = findSteadyState(outputFiles_path, outputFiles_Id, outputFiles_prefix, nSides)
%% ---- steady state = timepoint (fileId) when the derivative first becomes < 1.


derivative_sum_all = zeros(1,numel(outputFiles_Id));
counter = 1;

for ii = outputFiles_Id
    outputFile = [outputFiles_path filesep outputFiles_prefix  '_t' int2str(ii) '.mat'];
    load(outputFile, 'storeStates', 'userParam');
    
    if ii == outputFiles_Id(1) % get the colony boundary
        nSquares = size(storeStates,1);
        edgeLength = 1;
        lattice = false(nSquares);
        [~, ~, colonyState] = specifyColonyInsideLattice(lattice, userParam.colonyRadius, nSides);
        [colonyEdgeIdx] = specifyRegionWithinColony(colonyState, edgeLength);   
    end
 
    activatorValues = squeeze(storeStates(:,:,1,:));
    if ii == outputFiles_Id(1)
        activator_derivative  = diff(activatorValues, 1, 3).*colonyState;
    else
        activator_derivative = diff(cat(3, activator_lastValue, squeeze(activatorValues)), 1, 3).*colonyState;
    end
    
    derivative_sum_all(counter)=min(sum(sum(abs(activator_derivative)))); 
    counter=counter+1;
    
    activator_lastValue = squeeze(storeStates(:,:,1,end));
end

steadyState = find(derivative_sum_all < 0.1);
steadyState_timepoint = steadyState(1);
 