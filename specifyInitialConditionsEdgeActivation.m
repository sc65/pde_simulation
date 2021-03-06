function [currState, storeStates] = specifyInitialConditionsEdgeActivation(nSquares, colonyIdx, colonyEdgeIdx)
%% specify initial state of the components in colony assuming
% a) the activator is  high at the colony edges
% b) component order: [Activator Inhibitor1 BMp4_inhibitor BMP4].

global userParam

nComponents = userParam.nComponents;
initialState = zeros(nSquares,nSquares,nComponents);
storeStates = zeros(nSquares,nSquares,nComponents, userParam.nT/userParam.saveEvery);

for ii = 1:size(colonyIdx,1)
    initialState(colonyIdx(ii,1), colonyIdx(ii,2), :) = rand(1, 1, nComponents); %random values everywhere
end


if userParam.nSides>0 % high activator at colony edges
    for ii = 1:size(colonyEdgeIdx,1)
        initialState(colonyEdgeIdx(ii,1), colonyEdgeIdx(ii,2), 1) = userParam.activator_t0; %high activator values at the edges
    end
end

if userParam.nComponents == 4
    % adding BMP4 values
    for ii = 1:size(colonyIdx,1)
        %initialState(colonyIdx(ii,1), colonyIdx(ii,2), 4) = userParam.BMP_t0;
        initialState(:, :, 4) = userParam.BMP_t0; % BMP high everywhere
    end
end

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
