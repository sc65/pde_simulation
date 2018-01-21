function [colonyEdgeIdx] = specifyRegionWithinColony(colonyState, edgeLength)
%% returns indices corresponding to the region with high activator values
% colonyEdgeIdx: pixels in the colony edge.

distmatrix = bwdist(imcomplement(colonyState));
[row, column] = find(distmatrix>0 & distmatrix<=edgeLength);
colonyEdgeIdx = [row, column];

end
