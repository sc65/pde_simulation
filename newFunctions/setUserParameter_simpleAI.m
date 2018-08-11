%%
function setUserParameter_simpleAI
%% parameters for simpleAI, simpleAI_BMP4.
% adapted from parameter sets for figure1 of Koch & Meinhardt RMP 66:1481 (1994) 

global userParam

userParam.nComponents = 2; %[activator; inhibitor; BMP4_inhibitor; BMP4].
if userParam.nComponents == 2
    userParam.fhandle = @(x) simpleAI_mod(x); 
else
    userParam.fhandle = @(x) simpleAI_BMP4(x); 
end

%% ----------------- equation parameters.

userParam.kappa = [0]; % saturation ; can be specified as an array
userParam.rho = [0.1; 0.2]; %[activator_auto-activation inhibitor_activation]

userParam.kd = [0.005; 0.01; 0.2; 0]; %degradation of comnponents in colony, [activator inhibitor BMP4_inhibitor BMP4], assumes constant BMP4.
userParam.kd1 = 0.05; %degradation of components outside colony

userParam.sigma = [0; 0];
userParam.Dc = [0.005; 0.2; 0.2; 0.00001]; %Diffusion constants, [activator inhibitor BMP4_inhibitor BMP4].

userParam.kb = [0.005; 0.5]; %[BMP4_activation_of_Activator, BMP4_activation_of_BMP4_inhibitor]
userParam.ki = 0.05; %BMP4_inhibitor inhibition on BMP4

userParam.activator_t0 = 1.1;
userParam.BMP_t0 = 10; %initial concentration of BMP4.
userParam.BMP_inhibitor = 3;% position of BMP4_inhibitor in component list 

userParam.knockout = 0; % position of the component you want to knockout from the system
%% -------------------------------------------------------------
%% -------------------- lattice, simulation parameters.
% colony:region where all the action occurs, forms a small part of a big square lattice - ensures that anything
% diffusing outside of the colony does not influence components in the colony

userParam.dx = 0.1; %Square step size
userParam.latticeRadiusDifference = 7;
% maintain a certain ratio of lattice-circle, to ensure that opposite ends
%of colony do not see each other.
% nSquares = 2*(radius + userParam.latticeRadiusDifference/userParam.dx);
% lattice = nSqures*nSquares


userParam.colonyRadius = [25]; %in pixels, radius of the circular colony; can also be specified as an array
% for other shapes, side length is calculated such that area of the shape = area of the circle with colonyradius 
userParam.nSides = 1; % for circle nSides = 1, equilateral triangle = 3, square = 4; can be specified as an array
userParam.quadrantCut = 0; 
% only applicable for circle, pacman and semi-circle. i.e. when nSides = 1;
% for circle, set this to 0. for pacman, to 1. for semi-circle, to 2. for any other shape, set this to NaN

userParam.edgeDistance = 3; %assume a high initial activator value at a distance <= edgeDistance from the colony edges.


userParam.dt = 0.01; %time step
userParam.nT = 80000; %no. of timesteps in simulation

userParam.saveEvery = 100; % update component values every 100 timesteps. 
userParam.writeEvery = 1000; % save component values in a 4dmatrix (x,y, component, time)
% matlab can't store very big matrices.
% if the code breaks in between, you can start again from the saved values.
