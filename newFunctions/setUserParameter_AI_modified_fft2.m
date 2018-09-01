
function setUserParameter_AI_modified_fft2
% parameters adapted from parameter sets for figure2
% of "Out-of-phase oscillations and traveling waves with unusual properties: the use of three-component systems in biology"

% components order: [activator inhibitor bmp4]

global userParam
%% ----------------- equation parameters.
userParam.Dc = [0.001; 0.4; 0]; % diffusion constants.

userParam.kd = [0.001; 0.008; 0]; %degradation of proteins inside the colony.
userParam.kd1 = 0.01; %degradation of proteins outside the colony.

userParam.sa = 0.01; %random fluctuation, also the rate of self-activation.
userParam.si = 0.01; %rate of  inhibitor activation

userParam.kI1 = 0.2; %inhibition of inhibitor1 on activator.
userParam.kI2 = 1.0; % inhibition of inhibitor1 on BMP4.

userParam.kb = 0; % activation of activator in the colony by BMP4.

userParam.kappa = [0 0.3]; % [0 0.3] [spots, stripes]
userParam.basal = [0.0; 0.0; 0]; %basal production rate of components

userParam.initial_values = [3.1; 1; 0]; % NaN: random value between 0 and 1.
userParam.initial_regions = {'ColonyEdge'; 'Colony'; 'colonymedia'}; % where in the simulation space are the components present. 

userParam.knockout = 0;
% position of the component in [Activator inhibitor1(that diffuses) inhibitor2(does not diffuse) BMP4] you want to knockout from the system.

%% -------------------- lattice, simulation parameters.
% colony:region where all the action occurs, forms a small part of a big square lattice - ensures that anything
% diffusing outside of the colony does not influence components in the colony

userParam.dx = 0.1; %Square step size
userParam.latticeRadiusDifference = 7;
% maintain a certain ratio of lattice-circle, to ensure that opposite ends
%of colony do not see each other.
% nSquares = 2*(radius + userParam.latticeRadiusDifference/userParam.dx);
% lattice = nSqures*nSquares


userParam.colonyRadius = 25;%in pixels, radius of the circular colony; can also be specified as an array
% for other shapes, side length is calculated such that area of the shape = area of the circle with colonyradius
userParam.nSides = [0]; %for circle nSides = 1, equilateral triangle = 3, square = 4; can be specified as an array
userParam.quadrantCut = 0; 
% only applicable for circle, pacman and semi-circle. i.e. when nSides = 1;
% for circle, set this to 0. for pacman, to 1. for semi-circle, to 2. for any other shape, set this to NaN

userParam.radiusByEdgeRatio = 5;  % edgeWidth = radius/radiusByEdgeRatio
%userParam.edgeWidth =floor(userParam.colonyRadius/4); %


userParam.dt = 0.1; %time step
userParam.nT = 100000; %no. of timesteps in simulation

userParam.updateEvery = 10; % update component values every 10 timesteps.
userParam.writeInFileEvery = 1000; % save component values after every 100 updates in a 4dmatrix (x,y, component, time)
% matlab can't store very big matrices.
% if the code breaks in between, you can start again from the saved values.