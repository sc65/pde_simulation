%%
%% 1) region of simulation: colony inside lattice. 

lattice = zeros(180);
 radius = 20;
 nSides = 1;
 
[~, ~, colonyState] = specifyColonyInsideLattice(lattice, radius, nSides);
edgeLength1 = 1;
[colonyEdgeIdx, colonyEdge1] = specifyRegionWithinColony(colonyState, edgeLength1);
%%
figure; imagesc(colonyState);
hold on;
plot(colonyEdgeIdx(:,2), colonyEdgeIdx(:,1), 'k.', 'MarkerSize', 10);
%%
ax = gca;
ax.XTickLabels = [];
ax.YTickLabels = [];
%%
edgeLength2 = 5;
[colonyEdgeIdx2, colonyEdge2] = specifyRegionWithinColony(colonyState, edgeLength2);
%%
c1 = double(colonyState);
c1([colonyEdge2]) = 2;
%%
figure; imagesc(c1);