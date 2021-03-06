function runMeinhartPDE_continue(fhandle,  kappa, radius, nSides, saveInPath)
%% continues simulation, with initial state as result of previous simulation's last timepoint.  
% saves the value of components in the lattice in a .mat file in the
% path specified by saveInPath - give the full file path.


%% specify equation, lattice parameters
int2str(1);
global userParam;

%% specify lattice
int2str(2)
nSquares = 2*(radius + userParam.latticeRadiusDifference/userParam.dx);

%% load values from the previous simulation
int2str(3)
initialState = zeros(nSquares,nSquares,userParam.nComponents); %state of lattice
[colonyIdx, colonyOutIdx, ~] = specifyColonyInsideLattice(initialState, radius, nSides);

allFiles = dir([saveInPath filesep 'k' int2str(ceil(kappa)) 'radius' int2str(radius) '*.mat']);
tEnd = numel(allFiles); %last timePoint

currState_filePath = [saveInPath filesep allFiles(tEnd).name]; % get the last timepoint of previous simulation 
load(currState_filePath, 'storeStates'); % loads variable storeStates in workspace
currState = storeStates(:,:,:,end);

q2 = tEnd+1;
%% evaluate derivative function.
int2str(4)
tic;
q1 = 1; % reset storeStates
for tt=1:userParam.nT
    if mod(tt,50)==0
        disp(int2str(tt));
    end
    newState = oneStep2D_2(fhandle,currState, colonyIdx, colonyOutIdx);
    if mod(tt, userParam.saveEvery) == 0
        storeStates(:,:,:,q1) = newState;
        q1 = q1 + 1;
    end
    
    if mod(tt, userParam.writeEvery) == 0
        %% save the variable storeStates as .mat files, each with values for first userParam.writeEvery time points.
        saveInFile =  [saveInPath filesep 'k' num2str(ceil(kappa)) 'radius' int2str(radius) ...
            '_t' int2str(q2) '.mat'];
        storeStates = storeStates(:,:,:,1:q1-1);
        save(saveInFile, 'storeStates', 'userParam');
        q2 = q2+1;
        q1 = 1; % reset storeStates. Ensures that variable doesn't eat up too much memory.
    end
    
    currState = newState;
end
toc;



