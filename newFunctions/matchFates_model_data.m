%% 
%%
clearvars;
%%
load('fateRegions.mat');
%%
c1 = circles;
c2 = allFates_small{1};
%%
figure; imagesc(c1); title('c1')
figure; imagesc(c2); title('c2');
%%
c1(c1 == 300) = 200;
c1(c1 == 1) = 300;
%%
colonyState1 = c1>1;
colonyState2 = c2>1;
%%
c12= colonyState1-colonyState2;
%%
common = c1==c2;
%%
figure; imagesc(common);
%%
common = logical(common.*colonyState1);
notCommon = logical((~common).*colonyState1);
%%
figure; imagesc(notCommon);

matching = double(colonyState1);
matching(common) = 100;
matching(notCommon) = 200;
%%
figure; imagesc(matching);
%%
sum(sum(common))./sum(sum(colonyState1));
%%

t1 = triangle;

t1 = t1([5:32], [4:36]);
figure; imagesc(t1);
%%
t1_2 = imresize(t2, [size(t1,1), size(t1,2)]);
t2 = t1_2;
figure; imagesc(t2);

t2(t2> 50 & t2 < 190) = 100;
t2(t2<50) = 0;

t2(t2>250) =  300;

t2(t2<250 & t2 >= 190) = 200;
figure; imagesc(t2); caxis([0 300]);
%%

figure; imagesc(t1); figure; imagesc(t2);
%%
colonyState2 = t2 > 1;
common = (t1 == t2).*colonyState2;
notCommon = (~(common).*colonyState2);
%%
all = common+notCommon;
%%
figure; imagesc(all);
%%
all = double(all);
%%
all(logical(common)) = 100;
all(logical(notCommon)) = 200;
%%
figure; imagesc(all);


%%
figure; imagesc(s1);
s2 = allFates_small{3};
figure; imagesc(s2);
%%
s1 = s1([7:32], [7:32]);
figure; imagesc(s1);

%%
ax = gca; axis off;
%%
saveInPath = '/Users/sapnachhabra/Desktop/poster/model'
saveAllOpenFigures(saveInPath);
