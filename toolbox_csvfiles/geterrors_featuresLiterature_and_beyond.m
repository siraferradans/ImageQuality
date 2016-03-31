function [err_simple,err_simplehighfreq,err_gram,err_gist]=geterrors_featuresLiterature_and_beyond(Ni,num_data)
N_minibatch=num_data;
% Function extract features
upper_matrix_indx = find(triu(cov(randn(10,3)))~=0);

flat=@(x)x(:);

% get_upper_matrix=@(C)C(upper_matrix_indx); %we want the upper triangular matrix of the cov.
% vectorize=@(x)reshape(x,Ni*Ni,3);
% getcov=@(x)cov(vectorize(x));
% cov_and_mean =@(x)[flat(get_upper_matrix(getcov(x))) ;...
%                    flat(mean(vectorize(x)))]; %1.0e+03 * [0.7484    0.7645    2.6320]
% d =length(upper_matrix_indx)+3; %dimensions of the extracted features
% feature_function = cov_and_mean;
% 
% disp('Error with cov and mean:')
% testing_featuresloaddata_and_extract_features
% err_simple = [errtest stderrtest];
% %Error with cov and mean: 20k imagenes
% %Means: 789.5354 790.8661 2550.9798 Stds: 3.5161 7.1031 29.1109
% 
% %% now with scattering, low level
% 
% 
% 
% 
% 
% %% anadiendo altas frequencias
% 
% absderiv=@(x)abs(diff(x));
% highfreq=@(x)mean(flat(absderiv(x))+flat(absderiv(permute(x,[2 1 3]))));
% cov_and_mean_highfreq=@(x)[cov_and_mean(x); highfreq(x)];
% d=length(upper_matrix_indx)+4;
% feature_function = cov_and_mean_highfreq;
% testing_featuresloaddata_and_extract_features
% err_simplehighfreq=[errtest stderrtest];
% 
% %% Gram matrix correlation sobre las salidas de las wavelets
% J=log2(Ni);
% L=4;
% [filters_image, ~,~] = generate_translate_wavelets([Ni Ni], J, L, 'image');
% simplefilters.phi = filters_image{1}.phi{1};
% for j=1:J
%     for l=1:L
%         simplefilters.psi{j}{l} = filters_image{1}.psi{1}{j}{l};
%     end
% end
% Jinit = 3;%Means: 763.6264 798.4853 2558.9539 Stds: 1.8387 2.4348 30.0177 (20000 imagenes)
% feature_function=@(x)flat(real(getGramMatrix_with_Wavelets(x,simplefilters,Jinit)));
% d=(3*((J-Jinit)*L+1)).^2;
% disp(['Error Gram matrix:'])
% testing_featuresloaddata_and_extract_features
% err_gram=[errtest stderrtest];
% 

%% Gist
addpath('../gistdescriptor/')
O=4;%orientations per scale
scales =4;
clear param;
param.imageSize = [Ni Ni]; % it works also with non-square images
param.orientationsPerScale = O*ones(scales,1);
param.numberBlocks = Ni/(O*O);
param.fc_prefilt = 4;

% Computing gist requires 1) prefilter image, 2) filter image and collect
% output energies
gist=@(x)LMgist(x, '', param);
d = Ni*O;
feature_function=gist;
disp(['Error Gist:'])
%Error Gist: con 20000ims
%Means: 742.1464 767.5167 2561.3406 Stds: 3.78 7.7737 22.7939
%data computation and get error
testing_featuresloaddata_and_extract_features
%[errtrain,errtest,errrandom]=getErrors_LinearRegression(X,Y,num_data);
err_gist=[errtest stderrtest];