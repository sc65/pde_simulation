function f=travellingWave_BMP4_noI2(u)

global userParam

f = zeros(userParam.nComponents,1);
%% parameters
s = userParam.s; ba = userParam.basal(1); ra = userParam.kd(1); sa = userParam.kappa; %saturation parameter
bb = userParam.basal(2); rb = userParam.kd(2);

sb = userParam.kI1; % inhibition of inhibitor1 on activator

k2 = userParam.kb(1); % activation of activator by bmp4.


%% model equations
f(1) = (s*(u(1)*u(1) + ba) + k2*u(3))/ ((1 + sb*u(2))*(1+sa*u(1)*u(1))) - ra*u(1);

f(2) = s*u(1)*u(1)- rb*u(2) + bb;

f(3) = 0; %BMP4


if userParam.knockout > 0
    f(userParam.knockout) = 0;
end
end