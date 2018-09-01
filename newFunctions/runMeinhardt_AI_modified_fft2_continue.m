function runMeinhardt_AI_modified_fft2_continue(storeStates, fileSuffix, tMax,  kappa, nSides, saveInPath)
%%% Hacked up spectral version of the RD code- from Ryan
%% original activator inhibitor travelling waves model, no bmp4

global userParam

%% %System Parameters
d = userParam.Dc;  %%diffusion constants

sa = userParam.sa; %rate of self-activation
si = userParam.si; %rate of inhibitor activation

ba = userParam.basal(1); % basal production rate
bb = userParam.basal(2);

ra = userParam.kd(1); %degradation of proteins in the colony
rb = userParam.kd(2);

kd1 = userParam.kd1; %degradation of components outside colony
kd2 = 0; %degradation of BMP4 outside colony

k2 = userParam.kb; % activation of activator by BMP
%s = userParam.s;% random fluctuation

tmax = tMax*userParam.dt;
dt = userParam.dt; %time step

updateStoreStates = userParam.updateEvery*userParam.dt;
saveStoreStates = userParam.writeInFileEvery*userParam.dt;

%% %%Set up domain
L= userParam.colonyRadius*5;  %domain size

nSquares = 2*(userParam.colonyRadius + userParam.latticeRadiusDifference/userParam.dx);
N = nSquares; %2^9.

%x =linspace(-L,L,N);% (L/N)*(1:N)';
%y = x;
%[X,Y] = ndgrid(x,x);

%%%Define cutoff for colony
%R = sqrt(X.^2 + Y.^2);
initialState = zeros(nSquares, nSquares);

if nSides > 1 % included different shapes
    chi = specifyRegularPolygonColony(initialState, userParam.colonyRadius, nSides);
elseif nSides == 1
    chi = specifyCircularColony(initialState, userParam.colonyRadius, userParam.quadrantCut);
else
    chi = ~initialState; % entire lattice
end

%% %Set up fourier variable and the laplacian operator
k = [0:N/2-1, 0 , -N/2+1:-1]'/(L/(2*pi));  %%fourier vector, for matlab fft
[xi,eta] = ndgrid(k,k);

L1 = -d(1)*(eta.^2+xi.^2);
L2 = -d(2)*(eta.^2+xi.^2);
L3 = -d(3)*(eta.^2+xi.^2);

S1 = 1 - dt*L1;
S2 = 1 - dt*L2;
S3 = 1 - dt*L3 ;%- dt*L3;%-> because D3 = 0

%%Define Nonlinearities
if userParam.knockout == 2 % without inhibitor
    f1 = @(uu1,uu2,uu3) (sa*(uu1.^2 + ba) + k2*uu3)./((1+kappa*uu1.^2)) - ra*uu1;
else
    f1 = @(uu1,uu2,uu3) (sa*(uu1.^2 + ba) + k2*uu3)./((1+uu2).*(1+kappa*uu1.^2)) - ra*uu1;
end

f2 = @(uu1,uu2,uu3) si*uu1.^2 - rb*uu2 + bb;
f3 = @(uu1,uu2,uu3) 0;

%% -------------------- Set up Initial conditions
u1_0 = storeStates(:,:,1,end);
u2_0 = storeStates(:,:,2,end);
u3_0 = storeStates(:,:,3,end);

%%Calculate fourier transforms of these initial data, v denote
%%fourier transformed variables
v1 = fft2(u1_0);
v2 = fft2(u2_0);
v3 = fft2(u3_0);
t = 1;

storeStates = zeros(N, N, 3, saveStoreStates);
q1 = 1; q2 = fileSuffix; % for storeStates
%%
%%%%Start the time stepper
tic;
while t< tmax
    t = t+dt;
    u1 = real(ifft2(v1));
    u2 = real(ifft2(v2));
    u3 = real(ifft2(v3));
    
    u1(u1<0) = 0;
    u2(u2<0) = 0;
   
    
    %u3 = u3./(1+ki.*u2); % inhibition of inhibitor on BMP4.
    
    if mod(round(t,1), updateStoreStates) == 0
        storeStates(:,:,1,q1) = u1;
        storeStates(:,:,2,q1) = u2;
        storeStates(:,:,3,q1) = u3;
        q1 = q1 + 1;
        
        if  mod(q1-1, saveStoreStates) == 0
            outputFile = [saveInPath filesep 'radius' int2str(userParam.colonyRadius) '_t' int2str(q2) '.mat'];
            save(outputFile, 'storeStates', 'userParam');
            
            q2 = q2 +1;
            q1 = 1;
                storeStates = zeros(N, N,3, saveStoreStates); % re initialize
        end
    end
    
    v1 =( v1 + dt*fft2(chi.*f1(u1,u2,u3) - (1-chi).*u1*kd1   ) )./S1;
    v2 =( v2 + dt*fft2(chi.*f2(u1,u2,u3) - (1-chi).*u2*kd1  ) )./S2;
    v3 =( v3 + dt*fft2(chi.*f3(u1,u2,u3) - (1-chi).*u3*kd2  ) )./S3;
    
end
toc;


















