function colonyState = specifyRegularPolygonColony(initialState, colonyRadius, nSides)
%% returns a binary matrix, with colony pixels as 1.
%% works for square, equilateral triangle

%% 1) get the side of the shape with the same area as the circle with the
%radius colonyRadius.
if nSides == 4 %square
    side = colonyRadius*sqrt(pi); % a^2 = pi*r^2;
    radius = 0.5*sqrt(2)*side; % radius of the circumcircle. 
elseif nSides == 3 %triangle
    side = 2*colonyRadius*sqrt(pi/sqrt(3));
    radius = side/sqrt(3); %radius of the circumcircle.
end


center = [floor(size(initialState,2)/2),  floor(size(initialState,1)/2)]; %[center_x, center_y];

L = linspace(0,2.*pi,nSides+1);
xv = center(1)+radius.*cos(L)';
yv = center(2)+radius.*sin(L)';
vertices = [xv'; yv'];

%% 2) rotate the shape to align one side with the x axis.
if nSides == 4
    theta = pi/4; %angle of rotation
else
    theta = 1.5*pi;
end

R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
vertices1 = R*vertices;

vertices1 = round(vertices1);
oldCenter_x = mean(vertices1(1,:));
oldCenter_y = mean(vertices1(2,:));
newCenter = [floor(size(initialState,1)/2), floor(size(initialState,1)/2)];
diff = round(newCenter - [oldCenter_x oldCenter_y]);
vertices2 = vertices1 + diff';
%%
colonyState = false(size(initialState,1), size(initialState,2));
for ii = 1:size(vertices2,2)
    colonyState(vertices2(2,ii), vertices2(1,ii)) = 1;
end
%%
colonyState = bwconvhull(colonyState, 'union');
end



