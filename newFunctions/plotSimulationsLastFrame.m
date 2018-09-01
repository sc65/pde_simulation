%% ----------------- model phenotypes

% model behavior based on Dc.
Dc = linspace(0.001,0.04, 10);
Dc_new = [Dc(1) 0.0025 0.0053 0.0097  Dc(4:end)]';
%%
%[Dc Lattice_behavior Circle_behavior] - 3d array, 3rd dimension:kappa
% Lattice: 1-spots, 2 - patches, 3-no pattern
% Circle: 1-spots, 2-patches, 3-waves

%% ------------------------- plot the last frame for all Dc's for a given shape, given kappa

masterFolder = '/Volumes/sapnaDrive2/180522_modelSimulation/travellingWave_noBMP_noI2_fft/Parameters4_check3_differentDa/outputFiles';
shapes = {'lattice', 'Circles', 'Triangle'};
kappa = [0 0.1];

shape1 = shapes{1};
kappa1 = kappa(1);

figure; counter = 1;

Dc1 = Dc_new(1:2);

for ii = Dc1'
    simulationPath = [masterFolder filesep 'Da' num2str(ii) filesep shape1 ...
        filesep 'k' num2str(kappa1)];
      
    outputFiles = dir([simulationPath filesep '*.mat']);
   
    load([outputFiles(1).folder filesep outputFiles(end).name] , 'storeStates');
    subplot(4,3,counter); imagesc(storeStates(:,:,1,100)); title(['Da' num2str(ii)]); colorbar;
    counter = counter+1; 
end
%%

lattice_pattern = [1; 1; 2; 2; repmat(3,7,1)];
circles_pattern = [1; 2; repmat(3,8,1)];