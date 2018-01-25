function f=travellingWave_BMP4(u)

global userParam

f = zeros(4,1);
%% parameters
s = userParam.s; ba = userParam.basal(1); ra = userParam.kd(1); sa = userParam.kappa; %saturation parameter
bb = userParam.basal(2); rb = userParam.kd(2);

sb = userParam.kI1; % inhibition of inhibitor1 on activator
sc = userParam.kI2; % inhibition of inhibitor 2 on activator.
rc = userParam.kd(3);

k2 = userParam.kb(1); % activation of activator by bmp4.
%% model equations


f(1) = s*(u(1)*u(1) + ba + k2*u(4))/ ((1 + sb*u(2))*(1+sa*u(1)*u(1))*(1+sc*(u(3)))) - ra*u(1);
% to prevent it from breaking when u(2) = 0.
f(2) = s*u(1)*u(1)- rb*u(2) + bb;

f(3) = rc*u(1) - rc*u(3);
f(4) = 0; %BMP4

if userParam.knockout > 0
    f(userParam.knockout) = 0;
end
end