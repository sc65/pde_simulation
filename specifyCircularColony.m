function colonyState = specifyCircularColony(initialState, colonyRadius)
%% returns a binary matrix, with colony pixels as 1.
colonyState = false(size(initialState,1), size(initialState,2));
colonyCenter = [floor(size(initialState,2)/2),  floor(size(initialState,1)/2)]; %[center_x, center_y];
colonyState(colonyCenter(1), colonyCenter(2)) = 1;

distMatrix = bwdist(colonyState);
colonyState(distMatrix<=colonyRadius) = 1;
end
