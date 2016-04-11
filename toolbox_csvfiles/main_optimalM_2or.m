
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


%%
Jinit=1;
J = log2(Ni);

ColorSpaces = {'opponent-colors','rgb','yuv','lab'};%worst hsv: completely unstable, the others approx. the same
Normalizationsd={'linear','log','division'};
RegressionType={'linearregression','ols','ridge'};

%computation of the error: 
num_trials = 12;

%%
err_scat=[];
num_data=10000;%:10000:50000
J=5;
    
   disp(num2str(J))
    %options
    options.J =J;
    options.colorspace='opponent-colors';%ColorSpaces{i};%'yuv';
    options.norm_type='division'%'log';%Normalizations{i};
    options.secondorder=true;
   
    U = Ni/2^(J);%non-overlapping
    if ~options.secondorder
        d = ((J*L+1)*U^2)*3; %dimensions scattering
    else 
        d = ((L^2*J*(J-1)/2+J*L+1)*U^2)*3
    end 
    
    feature_extractionfnc=@(x)getscatteringvector(x,simplefilters,options);
    
    X = getFeatures_DB(d,files(1:num_data),path,feature_extractionfnc);
    Y = Yscore(1:num_data);
   
  %%
    regressiontype='ols';
    lambda = 0;
    vM = [10:100:1200];
    %%
    for ivr=1:length(vM)
    	ivr
        M = vM(ivr);
        beta = [];
        %%get error and std
        
        for indx =1:num_trials
            indx
            [~,~,~,beta(:,indx)]=getErrors_LinearRegression(X,Y,num_data,regressiontype,M,lambda);
        end

        [err,biastest, variancetest]=get_bias_variance(Y,X,beta);
        err_scat(ivr,:)=[err, biastest, variancetest];
        err_scat(ivr,:)
    end 
%%
save('./errsM_2or_division_cv.mat','err_scat','options','vM');
h=figure;Js = log10(M);

[v,indx]=sort(Js);
%plot error to get the best lambda
h=figure;plot(Js(indx),err_scat(indx,1))
xlabel('M');title('J=5, rgb')
saveas(h,'./M_vs_err_secondord.png')
h=figure;
plot(Js(indx),err_scat(indx,2),'r');hold on;
plot(Js(indx),err_scat(indx,3),'k');
plot(Js(indx),err_scat(indx,2)+err_scat(indx,3),'-*g')
plot(Js(indx),err_scat(indx,1))
legend('bias^2','variance','bias+var','error')
saveas(h,'./errsMs.png')
