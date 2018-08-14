function newState = oneStep2D_1(dFunc,oldState, colonyIdx, colonyOutIdx)

global userParam

kdOut = userParam.kd1;
dx = userParam.dx;
dt = userParam.dt;
BMP_t0 = userParam.BMP_t0;
ki = userParam.ki;
Dc = userParam.Dc;

BMP_inhibitor = userParam.BMP_inhibitor;

%% calculating diffusion terms
si = size(oldState);
diag = 0;
diffFilter = [diag 1 diag; 1 -4-4*diag 1; diag 1 diag];

NC = si(3);
diffterms = zeros(si);

for ii = 1:NC
    diffterms(:,:,ii) = Dc(ii)*imfilter(oldState(:,:,ii),diffFilter,'circular')/dx^2;
end
%% calculating reaction terms
reactTerms = zeros(si);
% only the indices inside colony retain reaction terms
for ii = 1:size(colonyIdx,1)
    rowId = colonyIdx(ii,1);
    columnId = colonyIdx(ii,2);
    reactTerms(rowId,columnId,:) = dFunc(squeeze(oldState(rowId,columnId,:)));
end


if userParam.knockout >0
    components = setxor(1:userParam.nComponents, userParam.knockout);
else
    components = 1:userParam.nComponents;
end

%slow degradation of components outside the colony.
for ii = 1:size(colonyOutIdx,1)
    rowId = colonyOutIdx(ii,1);
    columnId = colonyOutIdx(ii,2);
    values = squeeze(oldState(rowId,columnId,components));
    
    newValues = -kdOut*values;
    reactTerms(rowId,columnId,components) = newValues;
    
end
% 
newState = oldState+dt.*(diffterms+reactTerms);
% 
%% adding the inhibition of BMP4 inhibitor on BMP4.
if size(oldState,3) == 4
    newState(:,:,4) = BMP_t0./(1+ki.*newState(:,:,BMP_inhibitor));
end

newState(newState<0) = 0; % concentration >= 0.

end











