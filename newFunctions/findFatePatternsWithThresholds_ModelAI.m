function [fatePatterns, fatePatterns_zoom] = findFatePatternsWithThresholds_ModelAI(colonyState, activator, inhibitor,...
    activatorThreshold, inhibitorThreshold)
%% formulates fate patterns based on threshold, extracts colony. 
inhibitorRegion = double(inhibitor > inhibitorThreshold);
activatorRegion = double((activator > activatorThreshold).*(~inhibitorRegion));
bmpRegion = double(colonyState.*(~(inhibitorRegion+activatorRegion)));
activatorRegion(activatorRegion>0) = 2;
inhibitorRegion(inhibitorRegion>0) = 3;
fatePatterns = bmpRegion+activatorRegion+inhibitorRegion;

% zoom onto the colony
fatePatterns_zoom = zoomOnObject(fatePatterns);
end
