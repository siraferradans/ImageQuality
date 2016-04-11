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

Jinit=1;
J = log2(Ni);

ColorSpaces = {'opponent-colors','rgb','yuv','lab'};%worst hsv: completely unstable, the others approx. the same
Normalizationsd={'linear','log','division'};
RegressionType={'linearregression','ols','ridge'};

%computation of the error: 
num_trials = 15;

%%
err_scat=[];
num_data=10000;%:10000:50000
J=5;
for ivr=1:3%J=log2(Ni):-1:1 %length(Normalizations)
    
   disp(num2str(J))
    %options
    options.J =J;
    options.colorspace='rgb'%ColorSpaces{i};%'yuv';
    options.norm_type='linear'%'log';%Normalizations{i};
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
   
    %%regression type
    M=d/2;
  
    regressiontype=RegressionType{ivr};
    beta = [];
    %%get error and std
    for indx =1:num_trials
        indx
        [~,errtestv(indx),~,beta(:,indx)]=getErrors_LinearRegression(X,Y,num_data,regressiontype,M,lambda);
    end
    
    [err,biastest, variancetest]=get_bias_variance(Y,X,beta);
    err_scat(ivr,:)=[err, biastest, variancetest];

end
Js = 3:log2(Ni);
save('./errsJs_newerror.mat','err_scat','options');
h=figure;
plot(Js,err_scat(3:end,2),'r');hold on;
plot(Js,err_scat(3:end,3),'k');
plot(Js,err_scat(3:end,2)+err_scat(3:end,3),'-*g')
plot(Js,err_scat(3:end,1))
legend('bias^2','variance','bias+var','error')
saveas(h,'./errsJs_newerror.png')
