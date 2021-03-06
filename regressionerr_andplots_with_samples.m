addpath(genpath('../regression/'));
main_folder='/users/data/ferradan/Regain/';
addpath(genpath([main_folder 'code/']));
% Testing the 

% loaddata_and_extract_features
% clear files; clear files_minibatch; 
% %load_scats_inmats
% % X is of size [N,d], 
% % Y size [N,1]
% 
 addpath(genpath('~/AudioSynth/spams-matlab'));
% 
% %save only the amount of data needed
% 
ntest = 3000;
ntrain = 10000;
nfiles =30;

%% Get data from .mats
%[X,Y]=load_scats_inmats(nfiles);
%%
%get random permutation for train and test: 
indx = randperm(length(Y));

Xtrain = X(indx(1:ntrain),:);
Xtest = X(indx(ntrain+1:ntrain+ntest),:);

Ytrain = Y(indx(1:ntrain));
Ytest = Y(indx(ntrain+1:ntrain+ntest));

clear X;clear Y; clear indx;


% Prepare data:
Xtrain=standarize(Xtrain);
Ytrain=Ytrain/100;
Ytrain=Ytrain-mean(Ytrain);

Xtest=standarize(Xtest);
Ytest=Ytest/100;
Ytest = Ytest-mean(Ytest);


%% small data set
[num_data,dims] = size(Xtrain);
flat=@(x)x(:);
mean_squared_error=@(Y,X,W)sum(flat(Y-X*W).^2)/length(Y);
vN=6000:1000:num_data;


%% OLS
vM = [2:25];% 50 100:200:1000];
errols=zeros(length(vM),length(vN));
errtestols=errols;
%Wols=zeros(size(X,2),length(errols));

err_per_N = zeros(length(vN),2);
for iN=1:length(vN);
   N=vN(iN);

   rast = 1;
  % h=figure;
   for iM=1:length(vM)
       M=vM(iM);
       if (M<N) 
          
           [atom_ind,orth_basis] = ols(Ytrain(1:N),Xtrain(1:N,:),M,1); %get the dictionary
           Waux= Xtrain(1:N,atom_ind);
           
           beta = pinv(Waux)*Ytrain(1:N);

           %now, get the coefficients
           errols(iM,iN)=mean_squared_error(Ytrain(1:N),Xtrain(1:N,atom_ind),beta);
           errtestols(iM,iN)=mean_squared_error(Ytest,Xtest(:,atom_ind),beta);
            

           plot( vM(1:iM),errols(1:iM,iN),'r');hold on;
           plot( vM(1:iM),errtestols(1:iM,iN),'b');
       end 
   end 
   [iv,ii]=min(errtestols(:,iN));
   disp(['For ' num2str(N) ' min_err=' num2str(iv) ' at indx=' num2str(ii)] )
   
   err_per_N(iN,:)=[iv,ii];
end

c = hsv2rgb([N/size(Xtrain,1) 1 1]);
plot(log2(vM),errols);drawnow;hold on;
plot(log2(vM),errtestols,'*-');drawnow;hold on;

%legend(num2str([2000:1000:size(Xtrain,1)/2]'))
saveas(h,['./ols_err.png'])
saveas(h,'./ols_err.fig');


W=[];
h=figure;
%%
for lambda=[0 0.1 0.2]
    err=[];
    errtest=[];
    c=hsv2rgb([lambda 1 1]);
    for N=vN
        W=ridgeregression(Xtrain(1:N,:),Ytrain(1:N),lambda);
        err(end+1)=mean_squared_error(Ytrain,Xtrain,W(:,end)); 
        errtest(end+1)=mean_squared_error(Ytest,Xtest,W);  
        
        plot(log2(vN(1:length(err))),err(:),'Color',c);drawnow;hold on;  
        plot(log2(vN(1:length(err))),errtest(:),'*-','Color',c);drawnow;hold on;
    end

end 
saveas(h,'./ridgeregression.fig');
saveas(h,'./ridgeregression.png')
save('./ridgeregression_firstorder.mat','vN','W','errtest');

