%%
% ------------------ assigning fates based on signaling dynamics similarity

outputFile1 = '/Volumes/sapnaDrive2/testModel/experimentalData/output.mat';
load(outputFile1, 'fatePattern');
patterns1 = fatePattern(1).pattern;
patterns1_zoom = zoomOnObject(patterns1);
figure; imagesc(patterns1_zoom);

fatePatterns_simulated = cell(1,3); relativeError = zeros(1,2);
fatePatterns_simulated{1} = patterns1_zoom;

%% ----- circle
masterFolder = '/Volumes/sapnaDrive2/testModel/Parameters4_check3/Circles';
nSides = 1; quadrantCut = 0; colonyRadius = 25;

lastTimepoint = 30;
counter = 1;
for ii = 1:lastTimepoint
    outputFile2 = [masterFolder filesep 'k0radius25_t' int2str(ii)];
    load(outputFile2);
    
    if ii == 1
        lattice = zeros(size(storeStates,1), size(storeStates,2));
        [~, ~, colonyState] = specifyColonyInsideLattice(lattice, colonyRadius, nSides, quadrantCut);
        timepoints = [1 lastTimepoint];
        activatorValues = zeros(size(patterns1_zoom,1), size(patterns1_zoom,2), lastTimepoint+1);
    else
        timepoints = lastTimepoint;
    end
    
    for jj = timepoints
        activator1 = storeStates(:,:,1,jj);
        activator1 = activator1.*colonyState;
        activator1 = zoomOnObject(activator1);
        
        activator1 = ceil(activator1);
        activator1 = imresize(activator1, size(patterns1_zoom));
        activator1(activator1<0) = 0;
        activatorValues(:,:,counter) = activator1; %for dynamics of activator evolution
        activatorValues1(counter,:) = activator1(9,9:18); % only values along a radius (use symmetry of circle)
        counter = counter+1;
    end
end
activatorDynamics{1} = activatorValues;
%%
% add value for background.
fateValues = [patterns1_zoom(9,9:18) 0];
activatorValues1(:,11) = zeros(lastTimepoint+1,1);

%% ------ triangle, pacman

shapeIds = [2 3]; %[pacman, triangle] , correspond to order in array fatePattern in outputFile1.
nSides = [1 3]; quadrantCut = [1 0]; shapeCounter = 1;
masterFolder = '/Volumes/sapnaDrive2/testModel/Parameters4_check3/';
shapes = {'Pacman', 'Triangle'};

for shapeId = shapeIds
    % experimental
    patterns2 = fatePattern(shapeId).pattern;
    patterns2_zoom = zoomOnObject(patterns2);
    figure; imagesc(patterns2_zoom);
    
    if shapeId == 2
        patterns2_zoom = imrotate(patterns2_zoom, -90);
        figure; imagesc(patterns2_zoom);
    end
    
    % simulated
    shapeFolder = [masterFolder filesep shapes{shapeCounter}];
    counter = 1;
    for ii = 1:lastTimepoint
        outputFile2 = [shapeFolder filesep 'k0radius25_t' int2str(ii)];
        load(outputFile2);
        
        if ii == 1
            lattice = zeros(size(storeStates,1), size(storeStates,2));
            [~, ~, colonyState] = specifyColonyInsideLattice(lattice, colonyRadius, nSides(shapeCounter), quadrantCut(shapeCounter));
            timepoints = [1 lastTimepoint];
            activatorValues2 = zeros(size(patterns2_zoom,1), size(patterns2_zoom,2), size(activatorValues1,1));
        else
            timepoints = lastTimepoint;
        end
        for jj = timepoints
            activator1 = storeStates(:,:,1,jj);
            activator1 = activator1.*colonyState;
            activator1 = zoomOnObject(activator1);
            activator1 = ceil(activator1);
            activator1 = imresize(activator1, size(patterns2_zoom));
            activator1(activator1<0) = 0;
            
            activatorValues2(:,:, counter) = activator1;
            counter = counter+1;
        end
    end
    activatorDynamics{shapeId} = activatorValues2;
    
    % compare
    difference_index = zeros(size(activator1,1), size(activator1,2), size(activatorValues1,2));
    for jj = 1:11
        activator1 = activatorValues1(:,jj);
        activator1 = permute(activator1,[3 2 1]);
        difference_index(:,:,jj) = sum((activatorValues2 - activator1).^2, 3); %sum of squared differences
    end
    
    [~,b] = min(abs(difference_index),[], 3);
    fate2 = fateValues(b);
    figure; imagesc(fate2);
    [fatePatterns_simulated{shapeId}, ~, relativeError(shapeId)] = comparePatterns(patterns2_zoom, fate2);
    shapeCounter = shapeCounter+1;
end

%% -------------- save
shapes = {'Circle', 'Pacman', 'Triangle'};
fatePattern_simulated = struct;
for ii = 1:3
    fatePattern_simulated(ii).pattern = fatePatterns_simulated{ii};
    fatePattern_simulated(ii).shape = shapes{ii};
end
save(outputFile1, 'fatePattern_simulated', 'relativeError', '-append');

%%
myColormap = [1 1 1];
%% ------ evolution of activator in time. 
figure; 
counter = 1;
for ii = [2:3:20 50]
    subplot(2,5,counter);
    imagesc(activatorValues(:,:,ii)); colorbar; caxis([1 11]);
    counter = counter+1;
end
%%
circle_activatorValues_simulated = activatorValues;
save(outputFile1, 'circle_activatorValues_simulated', '-append');



















