%%
for ii = 1:15
    figure; imagesc(storeStates(:,:,1,ii)); title(['t = ' int2str(ii)]);
end
%%
xValues = 100:400; % colony boundary;

yValue = floor(size(storeStates,1)/2);
xValues = yValue:xValues(end); % only the values of the right half of radius

%%
for tt = 1:30
    outputFile = ['k1radius10_t' int2str(tt) '.mat'];
    load(outputFile, 'storeStates');
    
    activatorValues = squeeze(storeStates([xValues],yValue,1,:));
    inhibitorValues = squeeze(storeStates([xValues],yValue,2,:));
    %%
    if tt == 1
        fig1 = figure;
        set(fig1,'NextPlot','replacechildren');
        h = plot(xValues, flip(activatorValues(:,1)), 'k-');
        hold on;
        %l = plot(xValues, flip(inhibitorValues(:,1)), 'r-');
        
        ylim([0 0.3]);
        xlim([xValues(1) xValues(end)]);
        drawnow;
    end
    %%
    for ii = 1:size(activatorValues,2)
        
        set(h,'YData',flip(activatorValues(:,ii)));
        hold on;
        %set(l,'YData',flip(inhibitorValues(:,ii)));
        
        ylim([0 0.3]);
        xlim([xValues(1) xValues(end)]);
        
        pause(0.2);
        drawnow;
        title(['t =' int2str(tt)]);
        
    end
end