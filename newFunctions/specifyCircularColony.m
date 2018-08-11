function colonyState = specifyCircularColony(initialState, colonyRadius, quadrantCut)
%% returns a binary matrix, with colony pixels as 1.
colonyState = false(size(initialState,1), size(initialState,2));
colonyCenter = [floor(size(initialState,2)/2),  floor(size(initialState,1)/2)]; %[center_x, center_y];
colonyState(colonyCenter(1), colonyCenter(2)) = 1;

distMatrix = bwdist(colonyState);
colonyState(distMatrix<=colonyRadius) = 1;

if exist('quadrantCut', 'var')
    if quadrantCut == 1 % pacman
        colonyState(colonyCenter(1):size(colonyState,2),colonyCenter(2):size(colonyState,2)) = 0;
        colonyState = imrotate(colonyState, 180);
        
    elseif quadrantCut == 2 % semi-circle
        colonyState(colonyCenter(1):size(colonyState,2),1:size(colonyState,2)) = 0;

    end   
end
end

