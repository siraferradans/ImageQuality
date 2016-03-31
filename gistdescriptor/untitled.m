%% Testing features 
addpath(genpath('~/Regain/code/'));
Ni=64;
num_data = 1000; %num of exemplars
N_minibatch=num_data;

% Function extract features

d =2; %dimensions of the extracted features
feature_function = mean_and_std;




%A testear: Gram matrix correlation sobre las salidas de las wavelets


%% Gist
O =4;%orientations per scale
clear param;
param.imageSize = [Ni Ni]; % it works also with non-square images
param.orientationsPerScale = [O O O O];
param.numberBlocks = 4;
param.fc_prefilt = 4;

% Computing gist requires 1) prefilter image, 2) filter image and collect
% output energies
gist=@(x)LMgist(x, '', param);
d = Ni*O;
feature_function=gist;



%% data computation and get error

testing_featuresloaddata_and_extract_features
%[errtrain,errtest,errrandom]=getErrors_LinearRegression(X,Y,num_data);