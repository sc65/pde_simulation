function saveasAvi_1component(matFilesPath, matFilesPrefix, aviFilesPath, aviFilesPrefix, ...
    radius, nSides, quadrantCut, component)
%% combining output from multiple .mat output files and saving a video.
close all;

files  = dir([matFilesPath filesep matFilesPrefix '*.mat']);
nTimePoints = numel(files);
%nTimePoints = 100;
videoPath = [aviFilesPath filesep aviFilesPrefix '_' matFilesPrefix];

%%

fig = figure;
%set(fig, 'Position', [68 800 500 400]);
set(fig, 'Position', [68 1000 600 500]);
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
        [~, ~, colonyState] = specifyColonyInsideLattice(lattice, radius, nSides, quadrantCut);
        colonyState = colonyState([50:140], [50:140]);
        
        if nSides>0
            [colonyEdgeIdx] = specifyRegionWithinColony(colonyState, edgeLength);
        end
        
    end
    timeSteps = size(storeStates,4);
    
    for kk = [1 50:50:timeSteps] % each file has multiple timesteps
        values = storeStates(:,:,component,kk);
        values = values([50:140], [50:140]);
        
        imagesc(values); colorbar;
        title(['component=' int2str(component) ' t=' int2str(counter)]);
        counter = counter+1;
        
        
        %         if component == 1
        %             caxis([0 2]);
        %         elseif component == 2
        %             caxis([0 2]);
        %         else
        %             caxis([0 10]);
        %         end
        
        if nSides>0
            hold on;
            plot(colonyEdgeIdx(:,2), colonyEdgeIdx(:,1), 'k.', 'MarkerSize', 30); axis off;
        end
        
        
        drawnow;
        pause(0.01);
        
        M = getframe(fig);
        writeVideo(v,M);
    end
end
close(v);

end




















