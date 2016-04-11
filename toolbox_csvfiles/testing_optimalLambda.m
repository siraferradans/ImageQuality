%get optimal lambda v  
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
   disp(num2str(J))
    %options
    options.J =J;
    options.colorspace='yuv';
    options.norm_type='log';%Normalizations{i};
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
    lambda = 0.001;
    regressiontype='ridge';
   
    vL = [0.00001 0.001 0.01 0.1 1];
    for i_l=1:length(vL)
        lambda = vL(i_l);
         %%get error and std
        for indx =1:num_trials
              [~,~,~,beta(:,indx)]=getErrors_LinearRegression(X,Y,num_data,regressiontype,M,lambda);
        end
        [biastest, variancetest]=get_bias_variance(Y,X,beta);
           
        err_scat(i_l,:)=[biastest variancetest];
    end

end
save('./errs_linearregression.mat','err_scat','options','err_Mscat','err_Lambdascat','vM','vL');
h=figure;
errorbar(num_data,err_scat(:,1),err_scat(:,2));
saveas(h,'./errJsplot.png');