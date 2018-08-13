function saveAsAvi_AI_ratio(matFilesPath, matFilesPrefix, aviFilesPath, aviFilesPrefix, ...
    radius, nSides)
%% saving a video for changing activator/inhibitor levels 
% in the colony.

files  = dir([matFilesPath filesep matFilesPrefix '*.mat']);
nTimePoints = numel(files);
videoPath = [aviFilesPath filesep aviFilesPrefix '_' matFilesPrefix];

%%

fig = figure;
set(fig, 'Position', [68 800 500 400]);
fullVideoPath = [videoPath '.avi'];
v = VideoWriter(fullVideoPath); v.FrameRate = 5; open(v);

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
    end
    timeSteps = size(storeStates,4);
    
    for kk = [1:timeSteps] % each file has multiple timesteps
        activator = storeStates(:,:,1,kk);
        inhibitor = storeStates(:,:,2,kk);
        values = inhibitor./activator;
        values(isnan(values)) = 0;
        
        values = values.*colonyState;
        
        imagesc(values); colorbar; caxis([0 5]);
        title(['activator/inhibitor'  't=' int2str(counter)]);
        counter = counter+1;
        
        
%         if component == 1
%             caxis([0 1.1]);
%         elseif component < 3
%             caxis([0 2.5]);
%         else
%             caxis([0 0.5]);
%         end
        
        hold on;
        plot(colonyEdgeIdx(:,2), colonyEdgeIdx(:,1), 'k.', 'MarkerSize', 8); axis off;
        
        
        drawnow;
        pause(0.01);
        
        M = getframe(fig);
        writeVideo(v,M);
    end
end
close(v);

end