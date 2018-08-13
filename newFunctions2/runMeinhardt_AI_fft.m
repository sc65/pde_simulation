function runMeinhardt_AI_fft(kappa, radius, nSides, saveInPath)
%%% Hacked up spectral version of the RD code- from Ryan

global userParam

%% %System Parameters
d = userParam.Dc;  %%diffusion constants

sa =  kappa; %kap = 0.3; %[0 0.25] [spots,stripes]
sb = userParam.kI1; %inhibition of inhibitor1 on activator
ki = userParam.kI2; %inhibition of inhibitor1 on BMP

ba = userParam.basal(1); % basal production rate
bb = userParam.basal(2);

ra = userParam.kd(1); %degradation of proteins in the colony
rb = userParam.kd(2);

kd1 = userParam.kd1; %degradation of components outside colony
kd2 = 0; %degradation of BMP4 outside colony

k2 = userParam.kb; % activation of activator by BMP
s = userParam.s;% random fluctuation

%% %%Set up domain
L= radius*5;  %domain size

nSquares = 2*(radius + userParam.latticeRadiusDifference/userParam.dx);
N = nSquares; %2^9.

%x =linspace(-L,L,N);% (L/N)*(1:N)';
%y = x;
%[X,Y] = ndgrid(x,x);

%%%Define cutoff for colony
%R = sqrt(X.^2 + Y.^2);
initialState = zeros(nSquares, nSquares);

if nSides > 1 % included different shapes
    chi = specifyRegularPolygonColony(initialState, radius, nSides);
else
    chi = specifyCircularColony(initialState, radius);
end
[~,edge] = specifyRegionWithinColony(chi, userParam.edgeWidth);
chi = double(chi);
edge = double(edge);

media = ~chi;
%%
tmax = userParam.nT*userParam.dt;
dt = userParam.dt; %time step


updateStoreStates = userParam.updateEvery*userParam.dt;
saveStoreStates = userParam.writeInFileEvery*userParam.dt;

q1 = 2; q2 = 1; % for storeStates

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
f1 = @(uu1,uu2,uu3) (s*(uu1.^2 + ba) + k2*uu3)./((1+sb*uu2).*(1+sa*uu1.^2)) - ra*uu1; 
f2 = @(uu1,uu2,uu3) s*uu1.^2 - rb*uu2 + bb;
f3 = @(uu1,uu2,uu3) 0;


%%Find steady state equilibrium
%  fff =@(u) [f1(u(1),u(2),u(3),10) ;f2(u(1),u(2),u(3),10) ;f3(u(1),u(2),u(3),10)];% ;f4(u(1),u(2),u(3),u(4))];
%  [equil] = fsolve(fff,[1.4,1,1])

%% -------------------- Set up Initial conditions
u3_ic = 10;  %%BMP at edges

%noise size
noise = 0.1; 

u1_0 = noise*rand(N,N).*chi; 
u2_0 =  noise*rand(N,N).*chi;
u3_0 =  noise*(rand(N,N))+ u3_ic*(edge|media);


%%Calculate fourier transforms of these initial data, v denote
%%fourier transformed variables
v1 = fft2(u1_0);
v2 = fft2(u2_0);
v3 = fft2(u3_0);
t = 1;

storeStates = zeros(N, N, 3, saveStoreStates);
storeStates(:,:,1,1) = u1_0;
storeStates(:,:,2,1) = u2_0;
storeStates(:,:,3,1) = u3_0;
%%
%%%%Start the time stepper
tic;
while t< tmax 
    t = t+dt;
    u1 = real(ifft2(v1));
    u2 = real(ifft2(v2));
    u3 = real(ifft2(v3));
    
    u3 = u3./(1+ki.*u2); % inhibition of inhibitor on BMP4.
    
    if mod(round(t,1), updateStoreStates) == 0
        storeStates(:,:,1,q1) = u1;
        storeStates(:,:,2,q1) = u2;
        storeStates(:,:,3,q1) = u3;
        q1 = q1 + 1;
        
        if  mod(q1-1, saveStoreStates) == 0
            outputFile = [saveInPath filesep 'k' num2str(ceil(sa)) 'radius' int2str(radius) ...
                '_t' int2str(q2) '.mat'];
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


















