function [currState, storeStates] = specifyInitialConditions(nSquares, colonyIdx, colonyEdgeIdx)
%% specify initial state of the components in colony assuming
% a) the activator is  high at the colony edges
% b) component order: [Activator Inhibitor1 BMp4_inhibitor BMP4].

global userParam

nComponents = userParam.nComponents;
initialState = zeros(nSquares,nSquares,nComponents);
storeStates = zeros(nSquares,nSquares,nComponents, userParam.nT/userParam.saveEvery);

%%  random initial values in the colony (0-1)
components_random = find(isnan(userParam.initial_values));
components_nonRandom = setxor(1:nComponents, components_random);

for ii = 1:size(colonyIdx,1)
    initialState(colonyIdx(ii,1), colonyIdx(ii,2), 1:userParam.nComponents) = rand(1, 1, userParam.nComponents); 
    %random values everywhere in the colony
end

%%  non-random values
for ii = components_nonRandom
    region = userParam.initial_regions{ii};
    
    switch lower(region)
        case 'colonymedia'
            initialState(:, :, ii) = userParam.initial_values(ii);
            
        case 'colony'
            for jj = 1:size(colonyIdx,1)
                initialState(colonyIdx(jj,1), colonyIdx(jj,2), ii) = userParam.initial_values(ii);
            end
            
        case 'colonyedge'
            for jj = 1:size(colonyEdgeIdx,1)
                initialState(colonyEdgeIdx(jj,1), colonyEdgeIdx(jj,2), ii) = userParam.initial_values(ii);
            end
            
        case 'mediaedge'
            initialState(:, :, ii) = userParam.initial_values(ii);
             for jj = 1:size(colonyIdx,1)
                initialState(colonyIdx(jj,1), colonyIdx(jj,2), ii) = 8+rand(1, 1, 1); % only for BMP4
             end
            for jj = 1:size(colonyEdgeIdx,1)
                initialState(colonyEdgeIdx(jj,1), colonyEdgeIdx(jj,2), ii) = userParam.initial_values(ii);
            end
    end
    
    
end
%% zero values
if userParam.knockout > 0
    % knocking out a component
    for ii = 1:size(colonyIdx,1)
        initialState(colonyIdx(ii,1), colonyIdx(ii,2), userParam.knockout) = 0;
    end
end
%%
currState = initialState;
storeStates(:,:,:,1) = initialState; % first timepoint values same as initialstate

end
