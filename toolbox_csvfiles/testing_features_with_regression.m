addpath(genpath('~/Regain/code/'));
Ni=64;

% Function extract features
mean_and_std =@(x)[std(x(:)) ; mean(x(:))]; %1.0e+03 * [0.7484    0.7645    2.6320]
d =2; %dimensions of the extracted features
feature_function = mean_and_std;

% local averages and local stds
% disp('Get filters:')
%J=3;L=1;
%[filters_image, ~,~] = generate_translate_wavelets([Ni Ni], J, L, 'image');

%% test local averages

% phi = filters_image{1}.phi{1};
% flat=@(x)x(:);
% local_mean_nosubsample=@(x)flat(real(ifft2(fft2(mean(x,3)).*phi)));
% d=Ni*Ni;
% feature_function=local_mean_nosubsample;%Mega overfit: 10^4*[0.0000    3.9167    0.2314]


% phi = filters_image{1}.phi{1};
% flat=@(x)x(:);
% sample=@(x)x(1:2^J:end,1:2^J:end);
% local_mean=@(x)flat(real(sample(ifft2(fft2(mean(x,3)).*phi))));
% d=(Ni/2^J)*(Ni/2^J);%Ni*Ni;
% feature_function=local_mean;%1.0e+03 *[0.6882    0.7863    2.6585]


%% Getting local averages+wavelets
% simplefilters.phi = filters_image{1}.phi{1};
% for j=1:J
%     for l=1:L
%         simplefilters.psi{j}{l} = filters_image{1}.psi{1}{j}{l};
%     end
% end
% 
% scattering_o1= @(x)fastscattering2d_order1(mean(x,3), simplefilters);
% %Mega overfit:10^4*[0.0000    1.7566    0.2467] (1000imges)
% %Less overfit, but still...: 10^3*[0.6398    0.9244    2.5476]
% d=(1+J*L)*(Ni/2^(J-1))*(Ni/2^(J-1));
% feature_function=scattering_o1;

% unlocalize=@(x)mean(reshape(x,[size(x,1)  size(x,2)*size(x,3)]),2);
% scattering_o1_unlocal= @(x)unlocalize(fastscattering2d_order1(mean(x,3), simplefilters));
% %1000 images : 10^3* [0.7487    0.7550    2.6619]
% %10000 images:10^3 *[0.7818    0.8091    2.5470]
% d=(1+J*L);
% feature_function=scattering_o1_unlocal;

%%
flat=@(x)x(:);
histfeature=@(x)cat(2, mean(flat(x)), hist(flat(mean(x,3)),0:9));%err:10^3*[ 0.7662    0.7300    2.2240]
d = 11;
feature_function=histfeature;


%%
num_data = 1000; %num of exemplars
N_minibatch=num_data;


testing_featuresloaddata_and_extract_features
[errtrain,errtest,errrandom]=getErrors_LinearRegression(X,Y,num_data);


