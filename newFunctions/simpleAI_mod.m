function f = simpleAI_mod(u)
%Modified Eq 1. of Koch & Meinhardt RMP 66:1481 (1994)
% u(1): Activator
% u(2): Inhibitor

global userParam

rho = userParam.rho;
kappa= userParam.kappa;
sigma = userParam.sigma; 
kd = userParam.kd;

%%
f = zeros(2,1);

f(1) = rho(1)*u(1)^2/(1+kappa(1)*u(1)^2)/(1+u(2))+sigma(1); 
f(2) = rho(2)*u(1)^2+sigma(2);

f(1) = f(1) - kd(1)*u(1);
f(2) = f(2) - kd(2)*u(2);