function [colonyEdgeIdx, colonyEdge] = specifyRegionWithinColony(colonyState, regionWidth)
%% returns indices corresponding to the region with high activator values
% colonyEdgeIdx: pixels in the colony edge.

distmatrix = bwdist(imcomplement(colonyState));
[row, column] = find(distmatrix>0 & distmatrix<=regionWidth);
colonyEdgeIdx = [row, column];
colonyEdgeIdx_linear = sub2ind([size(colonyState,1), size(colonyState,2)], row', column');

colonyEdge = false(size(colonyState,1), size(colonyState,2));
colonyEdge(colonyEdgeIdx_linear) = 1;

end
