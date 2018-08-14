function inhibitorRegion = findRegionWithHighInhibitorActivtorRatio(Ia_ratio_all, threshold)
%% returns the region where inhibitor/activator > threshold for at least 10 consecutive timepoints. 
% ----- Inputs:
% 1) Ia_ratio_all = ratio of inhibitor/activator levels for a set of timepoints
% 2) threshold = inhibitor/activator value over with the region is considered
% inhibitor high. 

%%
%threshold = 4.5;

inhibitor_high = Ia_ratio_all;
inhibitor_high(inhibitor_high<threshold) = 0;

[r, c, t] = findND(inhibitor_high >= threshold);

%% convert row, column into linear ids
rows = size(inhibitor_high,1);
columns = size(inhibitor_high, 2);

idx = sub2ind([rows,columns], r, c);
%% keep only consecutive timepoints
t1 = unique(t);
t1 = findConsecutiveIntegersInArray(t1');
t1 = t1';

%% get the indices common in at least t_continuous consecutive timepoints

t_continuous = 500;
indices = cell(1, numel(t1));

counter = 1;
for ii = t1'
  indices{counter} = idx(t == ii); 
  counter = counter+1;
end

%%
nSets = length(t1) - t_continuous+ 1;
common_indices = cell(1, nSets);

%for ii = 1
for ii = 1:nSets
    idx_search = ii:ii+t_continuous-1;
    common_indices{ii} = mintersect(indices{idx_search});
end
%%
inhibitor_idx = cat(1, common_indices{:});

inhibitorRegion = zeros(rows, columns);
inhibitorRegion([inhibitor_idx']) = 1;
figure; imagesc(inhibitorRegion);
end