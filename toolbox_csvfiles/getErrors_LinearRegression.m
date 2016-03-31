function [errtrain,errtest,errrandom]=getErrors_LinearRegression(X,Y,num_data)

if sum(isnan(X))>0
        [i,j]=find(isnan(X));
        X(i,:)=[];
        Y(i)=[];
        num_data=min(length(Y),num_data);
        disp(['change in the amount of data:' num2str(length(Y)) ])
end

%now we have Y and X
ntrain = round(num_data*2/3);
ntest = num_data-ntrain;

indx = randperm(length(Y)); %Randomize the elements of the Data set!

Xtrain = X(indx(1:ntrain),:);
Xtest = X(indx(ntrain+1:ntrain+ntest),:);

Ytrain = Y(indx(1:ntrain));
Ytest = Y(indx(ntrain+1:ntrain+ntest));

%clear X;clear Y; clear indx;

% Prepare data:
% Xtrain=standarize(Xtrain);
% Ytrain=Ytrain/100;
% Ytrain=Ytrain-mean(Ytrain);
% 
% Xtest=standarize(Xtest);
% Ytest=Ytest/100;
% Ytest = Ytest-mean(Ytest);


%% small data set
[num_data,dims] = size(Xtrain);
flat=@(x)x(:);
mean_squared_error=@(Y,X,W)sum(flat(Y-X*W).^2)/length(Y);

%%%% Regression:
%[atom_ind,orth_basis] = ols(Ytrain(1:N),Xtrain(1:N,:),M,1); %get the dictionary
%Waux= Xtrain(1:N,atom_ind);
extXtrain=(cat(2,Xtrain,ones(size(Xtrain,1),1)));
beta = pinv(extXtrain)*Ytrain;

%now, get the coefficients
errtrain=mean_squared_error(Ytrain,extXtrain,beta);

extXtest=cat(2,Xtest,ones(size(Xtest,1),1));
errtest=mean_squared_error(Ytest,extXtest,beta);
errrandom=mean_squared_error(Ytest,zeros(size(extXtest)),zeros(size(beta)));


[errtrain errtest errrandom];