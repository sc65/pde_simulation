%%

d1 = del_activator.*colonyState;
%%

for ii = 1:500:3099
    figure; imagesc(d1(:,:,ii));
end
%%

integratedValue = sum(del_activator,3);
%%
figure; imagesc(integratedValue);
%%

maxDerivative = max(del_activator,[],3);
%%
figure; imagesc(maxDerivative);
%%

% 1) Absolute max value
% 2) max duration (steady state value (before reaching steady state))
% 3) max derivative
% 4) maximum integrated value

%%

activatorValues = squeeze(storeStates(:,:,1,:));

% 1)
activator_max = zeros(nSquare);
activator_max = max(activator_max, activatorValues, [], 3);

% 2)
activator_high = zeros(nSquare);
activator_high = sum(cat(activator_high , activatorValues(activatorValues >  threshold),3), 3);

% 3) 
activator_derivative_max = zeros(nSquare);
activator_lastValue = squeeze(storeStates(:,:,1,end));
activator_derivative = diff(cat(3, activator_lastValue, squeeze(storeStates(:,:,1,:))), 1, 3);
activator_derivative_max = max(activator_derivative_max, activator_derivative,[], 3);

% 4)
activator_derivative_sum = zeros(nSquare);
activator_derivative_sum = sum(cat(activator_derivative_sum, activator_derivative, 3), 3); 



%%

inputs = {activator_derivative_max, activator_derivative_sum, activator_max, activator_high};

for ii = 1:4
    inputs{ii} = inputs{ii}.*colonyState;
    figure; imagesc(inputs{ii});
end
