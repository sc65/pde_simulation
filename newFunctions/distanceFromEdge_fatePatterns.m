%%
% Can edge distance explain patterns on pacman?

lattice = zeros(size(storeStates,1));
nSides = 1;
quadrantCut = 1;
colonyRadius = userParam.colonyRadius;
[~, ~, colonyState] = specifyColonyInsideLattice(lattice, colonyRadius, nSides, quadrantCut);
%%
figure; imagesc(colonyState);
%%
dists = bwdist(~colonyState);
%%
max_dists = max(max(dists));
%%
outerRing = double(dists>0 & dists <= 4);
innerRing = double(dists>4 & dists<=8);
center = double(dists>8);

outerRing(outerRing>0) = 1;
innerRing(innerRing>0) = 2;
center(center>0) = 3;

patterns = outerRing+innerRing+center;
figure; imagesc(patterns);
