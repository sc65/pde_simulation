
function setUserParameter_travellingWave
% parameters adapted from parameter sets for figure2 
% of "Out-of-phase oscillations and traveling waves with unusual properties: the use of three-component systems in biology" 

global userParam 

userParam.nComponents = 4; %[activator; inhibitor1(diffusive); inhibitor2; BMP4].

if userParam.nComponents == 3
    userParam.fhandle = @(x) travellingWave(x); 
else
    userParam.fhandle = @(x) travellingWave_BMP4(x); 
end
%% ----------------- equation parameters.
userParam.kd = [0.005; 0.008; 0.001; 0]; %degradation of proteins in the colony.  - meinhardt's paper
userParam.kd1 = 0.01; %degradation of proteins outside the colony.

userParam.s = 0.015; %random fluctuation
%userParam.Dc = [0.003; 0.2; 0; 0]; % diffusion constants [Activator inhibitor1(that diffuses) inhibitor2(does not diffuse) BMP4]
userParam.Dc = [0.0005; 0.2; 0; 0];

userParam.kI1 = 0.5; %inhibition of inhibitor 1 on activator.
userParam.kI2 = 0.5; %inhibition of inhibitor 2 on activator. 

userParam.kappa = 0.3; % [0 0.25] [spots, stripes]
userParam.basal = [0.01; 0.01; 0; 0]; %basal production rate of components 

userParam.activator_t0 = 3.1; % initial high activator level at edges.

userParam.BMP_t0 = 10; %high media concentration
userParam.BMP_inhibitor = 2; % component that inhibits BMP4.

%userParam.ki = 0.005; % inhibitor1 inhibition on BMP4
userParam.ki = 0.1;
userParam.kb = 0.02; % activation of activator in the colony by BMP4.

userParam.knockout = 0; % position of the component you want to knockout from the system.

%% -------------------- lattice, simulation parameters.
% colony:region where all the action occurs, forms a small part of a big square lattice - ensures that anything
% diffusing outside of the colony does not influence components in the colony

userParam.dx = 0.1; %Square step size
userParam.latticeRadiusDifference = 7;
% maintain a certain ratio of lattice-circle, to ensure that opposite ends
%of colony do not see each other.
% nSquares = 2*(radius + userParam.latticeRadiusDifference/userParam.dx);
% lattice = nSqures*nSquares


userParam.colonyRadius = [35]; %in pixels, radius of the circular colony; can also be specified as an array
% for other shapes, side length is calculated such that area of the shape = area of the circle with colonyradius 
userParam.nSides = 3; %for circle nSides = 0, equilateral triangle = 3, square = 4; can be specified as an array

userParam.edgeDistance = 3; %assume a high initial activator value at a distance <= edgeDistance from the colony edges.


userParam.dt = 0.01; %time step
userParam.nT = 80000; %no. of timesteps in simulation

userParam.saveEvery = 100; % update component values every 100 timesteps. 
userParam.writeEvery = 1000; % save component values in a 4dmatrix (x,y, component, time)
% matlab can't store very big matrices.
% if the code breaks in between, you can start again from the saved values.