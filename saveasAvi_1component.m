function saveasAvi_1component(matFilesPath, matFilesPrefix, aviFilesPath, aviFilesPrefix, ...
    radius, nSides, component)
%% combining output from multiple .mat output files and saving a video.

files  = dir([matFilesPath filesep matFilesPrefix '*.mat']);
nTimePoints = numel(files);
videoPath = [aviFilesPath filesep aviFilesPrefix '_' matFilesPrefix];

%%

fig = figure;
set(fig, 'Position', [68 800 500 400]);
fullVideoPath = [videoPath 'component' int2str(component) '.avi'];
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
    
    for kk = [1 10:10:timeSteps] % each file has multiple timesteps
        values = storeStates(:,:,component,kk);
        imagesc(values); colorbar;
        title(['component=' int2str(component) ' t=' int2str(counter)]);
        counter = counter+1;
        
        
        if component == 1
            caxis([0 1.6]);
        elseif component < 4
            caxis([0 1]);
        else
            caxis([9.5 10]);
        end
        
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




















