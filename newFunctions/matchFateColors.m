
for ii = 1:3
a1 = allFates_small{ii};
a1(a1 == 0) = 0; % media
a1(a1 == 300) = 8; % sox2
a1(a1 == 200) = 30; % T
a1(a1 == 100) = 15; % cdx2

figure; imagesc(a1); colormap(jet); axis off;
end
%%