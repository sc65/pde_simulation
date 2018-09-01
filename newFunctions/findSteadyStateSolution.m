%% ------- steady state solution for the best model

sa = 0.01; %rate of self-activation
si = 0.01; %rate of inhibitor activation

ra = 0.001; %degradation of proteins in the colony
rb = 0.008;

kappa = 0;

syms  x y
eqn1 = sa*x.^2./((1+y).*(1+kappa*x^2)) - ra*x == 0; %f(x,y)
eqn2 = si*x.^2 - rb*y == 0;% g(x,y)
s = solve(eqn1, eqn2, 'ReturnConditions', true);

x0 = double(vpa(s.x))
y0 = double(vpa(s.y))

%% ----------------------------
f_x = 2*sa*x./(1+y) - ra;
f_y = -sa*x^2./((1+y)^2);
g_x = 2*si*x;
g_y = -rb;
%%
J = zeros(2,2,3); traces = zeros(1,3); determinants = zeros(1,3);
for ii = 1:3
    x = x0(ii); y = y0(ii);
    J(:,:,ii)= [subs(f_x), subs(f_y); subs(g_x), subs(g_y)];
    traces(ii) = trace(J(:,:,ii));
    determinants(ii) = det(J(:,:,ii));
    eig(J(:,:,ii))
    
end
