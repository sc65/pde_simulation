
%% ---- experimental data
close all;
outputFile1 = '/Users/sapna/Desktop/testModel/experimentalData/output.mat';
load(outputFile1, 'fatePattern');
patterns1 = fatePattern(1).pattern;
figure; imagesc(patterns1);

% zoom onto the colony
patterns1_zoom = zoomOnObject(patterns1);
%% ---- simulation data
outputFile2 = '/Users/sapna/Desktop/testModel/Parameters4_check3/Circles/k0radius25_t100.mat';
load(outputFile2);
activator = storeStates(:,:,1,100);
inhibitor = storeStates(:,:,2,100);
figure;
subplot(1,2,1); imagesc(activator); colorbar;
subplot(1,2,2); imagesc(inhibitor); colorbar;
%%
colonyRadius = userParam.colonyRadius;
nSides = 1; quadrantCut = 0;
lattice = zeros(size(storeStates,1));
[~, ~, colonyState] = specifyColonyInsideLattice(lattice, colonyRadius, nSides, quadrantCut);
figure; imagesc(colonyState);


%% ----- find the best thresholds for circles data.
activatorThreshold_best = 1;
inhibitorThreshold_best = 1;
relativeError = 1;

activatorThresholds = [5:0.05:13];
inhibitorThresholds = [600:5:800];

for ii = activatorThresholds
    for jj= inhibitorThresholds
        [~, pattern2_new] = findFatePatternsWithThresholds_ModelAI(colonyState, activator, inhibitor,...
            ii, jj);
        [pattern2_new, ~, relativeError1] = comparePatterns(pattern2_new, patterns1_zoom);
        if relativeError1 < relativeError
            activatorThreshold_best = ii;
            inhibitorThreshold_best = jj;
            relativeError = relativeError1;
            patterns2_best = pattern2_new;
        end
    end
end
%%
figure;
subplot(1,2,1); imagesc(patterns1_zoom); ax = gca; ax.XTick = []; ax.YTick = []; title('Experimental');
subplot(1,2,2); imagesc(patterns2_best);  ax = gca; ax.XTick = []; ax.YTick = []; title('Simulation');


%% -----------------------------------------------------------------------------------
%% --------------- apply same threshold to pacman, triangle --------------------------
%% -----------------------------------------------------------------------------------
outputFile1 = '/Users/sapna/Desktop/testModel/experimentalData/output.mat';
load(outputFile1, 'fatePattern');
shapeId = [3 2];  %[triangle, pacman]

masterFolder2 = '/Users/sapna/Desktop/testModel/Parameters4_check3/';
shapes = {'Triangle', 'pacman'}; nSides = [3 1]; quadrantCut = [0 1];
outputFile = 'k0radius25_t100.mat';

for ii = 1:2
    %% experimental
    pattern1 = fatePattern(shapeId(ii)).pattern;
    % zoom onto the colony
    pattern1_zoom = zoomOnObject(pattern1);
    %figure; imagesc(pattern1_zoom);
    
    %% theoretical
    outputFile2 = [masterFolder2 filesep shapes{ii} filesep outputFile];
    load(outputFile2);
    activator = storeStates(:,:,1,100);
    inhibitor = storeStates(:,:,2,100);
    %figure;
    %subplot(1,2,1); imagesc(activator); colorbar;
    %subplot(1,2,2); imagesc(inhibitor); colorbar;
    
    colonyRadius = userParam.colonyRadius;
    lattice = zeros(size(storeStates,1));
    [~, ~, colonyState] = specifyColonyInsideLattice(lattice, colonyRadius, nSides(ii), quadrantCut(ii));
    %figure; imagesc(colonyState);
    
    %rotate pacman
    if ii == 2
        pattern1_zoom = imrotate(pattern1_zoom, -90);
        figure; imagesc(pattern1_zoom);
    end
    
    %% compare & plot
    [~, pattern2_new] = findFatePatternsWithThresholds_ModelAI(colonyState, activator, inhibitor,...
        activatorThreshold_best, inhibitorThreshold_best);
    [pattern2_new, ~, relativeError1] = comparePatterns(pattern2_new, pattern1_zoom);
    relativeError1
    figure;
    subplot(1,2,1); imagesc(pattern1_zoom); ax = gca; ax.XTick = []; ax.YTick = []; title('Experimental'); caxis([0 3]);
    subplot(1,2,2); imagesc(pattern2_new);  ax = gca; ax.XTick = []; ax.YTick = []; title('Simulation'); caxis([0 3]);  
end

