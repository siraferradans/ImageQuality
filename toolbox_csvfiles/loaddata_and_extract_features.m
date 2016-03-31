main_folder='/users/data/ferradan/Regain/';
addpath(genpath([main_folder 'code/']));


flat=@(x)x(:);
% 
% Parameters for the scattering and for data loading
filecsv='challenge_output_data_training_file_predict_the_aesthetic_score_of_a_photograph.csv';
foldertrain='data_challenge_train_set';


J=3;
L=8;
Ni=256;
N_minibatch=512;
%end parameters to define

%% 
%Get corresponding filters: 

% disp('Get filters:')
% [filters_image, ~,~] = generate_translate_wavelets([Ni Ni], J, L, 'image');
% 
% % translate into simplefilters
% simplefilters.phi = filters_image{1}.phi{1};
% for j=1:J
%     for l=1:L
%         simplefilters.psi{j}{l} = filters_image{1}.psi{1}{j}{l};
%     end
% end



%% Load data: get ids and location of files
% disp(['Loading data'])
% idsfilepath=[main_folder '/data/' filecsv] ; %an image in the training database
% [filesID,Yscore]=load_ids_score(idsfilepath);
% 
% path=[main_folder 'data/' foldertrain ];
% files=getfilenames_from_id(filesID,folder);
% save('./trainfilenames_and_tags.mat','files','Yscore','path');

load('./trainfilenames_and_tags.mat')
%%
Yscore = Yscore(1:num_data);
for indx = 1:N_minibatch:length(Yscore)
    disp([num2str(indx) '/' num2str(length(Yscore))]);
    M=min(indx+N_minibatch,length(Yscore));
    files_minibatch = files(indx:M );

    DBS = getScattering_DB(J,L,Ni,files_minibatch,path,simplefilters);

    Y=Yscore(indx:M);
    namefile=[main_folder 'train_mini' num2str(indx) '.mat'];
    save(namefile,'DBS','Y','J','L','Ni','simplefilters','N_minibatch','-v7.3');
end 
disp('Ojo hay que sacar los -1!')
