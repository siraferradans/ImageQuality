
%% Testing features 
addpath(genpath('~/Regain/code/'));
Ni=128;

J=log2(Ni);
L=8;

%get filters
flat=@(x)x(:);
[filters_image, ~,~] = generate_translate_wavelets([Ni Ni], J, L, 'image');
simplefilters.phi = filters_image{1}.phi{1};
for j=1:J
    for l=1:L
        simplefilters.psi{j}{l} = filters_image{1}.psi{1}{j}{l};
    end
end

% Parameters for the scattering and for data loading
filecsv='challenge_output_data_training_file_predict_the_aesthetic_score_of_a_photograph.csv';
foldertrain='data_challenge_train_set';
load('./trainfilenames_and_tags.mat'); %get Yscore and files
path=['~/Regain/data/' foldertrain];


%% Define the options of the method
Jinit=1;
colorspace = 'opponent-colors';%worst hsv: completely unstable, the others approx. the same
Norm='';
regression='ols';
J=5;

%computation of the error: 
num_trials = 15;
num_data=50000;

%%
err_scat=[];   
disp(num2str(J))
%options
options.J =J;
options.colorspace=colorspace;
options.norm_type=Norm%'log';%Normalizations{i};
options.secondorder=false;

U = Ni/2^(J);%non-overlapping
if ~options.secondorder
    d = ((J*L+1)*U^2)*3; %dimensions scattering
else 
    d = ((L^2*J*(J-1)/2+J*L+1)*U^2)*3;
end 

feature_extractionfnc=@(x)getscatteringvector(x,simplefilters,options);

X = getFeatures_DB(d,files(1:num_data),path,feature_extractionfnc);
Y = Yscore(1:num_data);
   

regressiontype=regression;

M = 1320;
beta = [];
%%get error and std
lambda = 0;
parfor indx =1:num_trials
   % indx
    [~,errtestv(indx),~,beta(:,indx)]=getErrors_LinearRegression(X,Y,num_data,regressiontype,M,lambda);
end

[err,biastest, variancetest]=get_bias_variance(Y,X,beta);
err_scat=[err, biastest, variancetest];
err_scat

