function [colonyIdx, colonyOutIdx, colonyState] = specifyColonyInsideLattice(lattice, colonyRadius, nSides, quadrantCut)
%% function to specify colony inside lattice
% colonyIdx: pixels in colony.
% colonyOutIdx = pixels outside colony
% colonyState = binary matrix:-  1:colony.

if nSides == 0
    colonyState = ones(size(lattice,1), size(lattice,2)); % run simulation on lattice
elseif nSides>1
    colonyState = specifyRegularPolygonColony(lattice, colonyRadius, nSides);
else
    if ~exist('quadrantCut', 'var')
        quadrantCut = 0; % default: circle
    end
    colonyState = specifyCircularColony(lattice, colonyRadius, quadrantCut);
end

[colonyIdx_1, colonyIdx_2] = find(colonyState); % [rows, columns]. all non-zero pixels
colonyIdx = [colonyIdx_1, colonyIdx_2];
%colonyIdx = find(colonyState); %returns linear indices.

[colonyIdx_1, colonyIdx_2] = find(~colonyState);
colonyOutIdx = [colonyIdx_1, colonyIdx_2];
%colonyOutIdx = find(~colonyState);

end
