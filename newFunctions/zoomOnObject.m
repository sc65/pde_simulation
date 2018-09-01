function patterns1_zoom = zoomOnObject(patterns1)
%% zoom onto the colony object

triangle1 = patterns1>0;
stats = regionprops(triangle1, 'PixelList');
pixels_min = min(stats.PixelList);
pixels_max = max(stats.PixelList);
patterns1_zoom = patterns1([pixels_min(2):pixels_max(2)], [pixels_min(1):pixels_max(1)]);
