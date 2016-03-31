%Extract features 
main_folder='~/Regain/';
addpath(genpath([main_folder 'code/']));


flat=@(x)x(:);
% 
% Parameters for the scattering and for data loading
filecsv='challenge_output_data_training_file_predict_the_aesthetic_score_of_a_photograph.csv';
foldertrain='data_challenge_train_set';


%Ni=256;
%N_minibatch=512;
%end parameters to define

load('./trainfilenames_and_tags.mat')

for indx = 1:N_minibatch:num_data
  %  disp([num2str(indx) '/' num2str(length(Yscore))]);
    M=min(indx+N_minibatch,length(Yscore));
    files_minibatch = files(indx:M);

    X = getFeatures_DB(d,Ni,files_minibatch,path,feature_function);

    Y=Yscore(indx:M);
%    namefile=[main_folder 'testing_features' num2str(indx) '.mat'];
%    save(namefile,'X','Y','feature_function','N_minibatch','-v7.3');
end 
%disp('Ojo hay que sacar los -1!')

for indx =1:5
    [errtrainv(indx),errtestv(indx),errrandomv(indx)]=getErrors_LinearRegression(X,Y,num_data);
end 
errtrain = mean(errtrainv);
errtest = mean(errtestv);
errrandom=mean(errrandomv);
stderrtrain=std(errtrainv);
stderrtest=std(errtestv);
stderrrandom=std(errrandomv);
disp(['Means: ' num2str(errtrain) ' ' num2str(errtest) ' ' num2str(errrandom) ' Stds: ' num2str(stderrtrain) ' ' num2str(stderrtest) ' ' num2str(stderrrandom)])
