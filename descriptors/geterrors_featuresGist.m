function err_gist=geterrors_featuresGist(Ni,num_data)

N_minibatch=num_data;

%% Gist
addpath('../gistdescriptor/')
O=4;%orientations per scale
scales =4;
clear param;
param.imageSize = [Ni Ni]; % it works also with non-square images
param.orientationsPerScale = O*ones(scales,1);
param.numberBlocks = Ni/(scales*scales);
param.fc_prefilt = 4;

% Computing gist requires 1) prefilter image, 2) filter image and collect
% output energies
gist=@(x)LMgist(x, '', param);
d = param.numberBlocks.^2*scales*O;
feature_function=gist;
disp(['Error Gist:'])
%Error Gist: con 20000ims
%Means: 742.1464 767.5167 2561.3406 Stds: 3.78 7.7737 22.7939
%data computation and get error
testing_featuresloaddata_and_extract_features
%[errtrain,errtest,errrandom]=getErrors_LinearRegression(X,Y,num_data);
err_gist=[errtest stderrtest];