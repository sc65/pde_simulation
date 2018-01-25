function f=travellingWave(u)
%% equations 3-5 from
% "Out-of-phase oscillations and traveling waves with unusual properties: the use of three-component systems in biology"

global userParam
f = zeros(3,1);
%% parameters
s = userParam.s; ba = userParam.basal(1); ra = userParam.kd(1); sa = userParam.kappa; %saturation parameter
bb = userParam.basal(2); rb = userParam.kd(2);

sc = userParam.kI2; % inhibition of inhibitor 2 on activator.
rc = userParam.kd(3);

%% model equations
f(1) = s*(u(1)*u(1)+ba) / ((u(2))*(1+sa*u(1)*u(1))*(1+sc*(u(3)))) - ra*u(1);
f(2) = s*u(1)*u(1)- rb*u(2) + bb;
f(3) = rc*u(1) - rc*u(3);

if userParam.knockout > 0
    f(userParam.knockout) = 0;
end
end
%%
