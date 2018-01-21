function f = simpleAI_BMP4(u,userParam)
%Adapted from Eq 1. of Koch & Meinhardt RMP 66:1481 (1994)
% u = [Activator, Inhibitor,  BMP4_inhibitor, BMP4].  
rho = userParam.rho;
kappa= userParam.kappa;
sigma = userParam.sigma; 
kd = userParam.kd;
kb = userParam.kb;
%%
f = zeros(4,1);
%% Activator Inhibitor
f(1) = rho(1)*u(1)^2/(1+kappa(1)*u(1)^2)/u(2)+sigma(1); %Activator
f(2) = rho(2)*u(1)^2+sigma(2); %Inhibitor

f(1) = f(1) + kb(1)*(u(4)) - kd(1)*u(1);
f(2) = f(2) - kd(2)*u(2);

f(3) = kb(2)*u(4) - kd(3)*u(3); %BMP4_inhibitor
f(4) = 0; % BMP4 
end







