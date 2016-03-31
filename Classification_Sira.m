clear all;
close all;

%data_train = csvimport('../challenge_output_data_training_file_predict_the_aesthetic_score_of_a_photograph.csv','delimiter',';');
folder = '../data/data_challenge_test_set';
files = dir([folder '/*.jpg']);
 
flat=@(x)x(:)';
% View some images of the training set
disp(['Load dataset']);
rast = 1;
rast2 = 1;
warning('error', 'MATLAB:imagesci:jpg:libraryMessage');

%%
for k = 1:size(files)
   % Chose randomly an image
   progressbar(k,size(files,1),50);
   try
    im = double(imread([folder '/' files(k).name]));
  
   catch
       corrupted(rast2,:)=files(k).name;
       rast2 = rast2+1;
   end 
   normim(k) = norm(im(:));
   stats(k,:)= [mean(im(:)) std(im(:))];
   try
    sizeim(k,:)= flat(size(im));
   catch
       errorin(rast,:)=files(k).name;
       rast = rast+1;
       sizeim(k,:) = [flat(size(im)) 0];
   end 
end


uniquenI=unique(normim);
if abs(length(normim)-length(uniquenI))>0.01*length(uniquenI)
    disp('Error repeated vectors');
end 
save('./test.mat','normim','stats','sizeim');