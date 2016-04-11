function [errtrain,errtest,errrandom,beta]=getErrors_LinearRegression(X,Y,num_data,method,M,lambda)
if nargin<4
    method = 'linearregression';
end 
if nargin<5
    M=size(X,2)/2;
end 
if nargin<6 
    lambda = 0.001;
end 

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


%% small data set
[num_data,dims] = size(Xtrain);
flat=@(x)x(:);
mean_squared_error=@(Y,X,W)sum(flat(Y-X*W).^2)/length(Y);


extXtrain=(cat(2,Xtrain,ones(size(Xtrain,1),1)));%adding beta_0
beta = [];
switch method
    case 'linearregression'
        beta = pinv(extXtrain)*Ytrain;
      
    case 'ols' % Orthogonal least squares:
        [atom_ind,~] = ols(Ytrain,extXtrain,M,1); %get the dictionary
        Waux= extXtrain(:,atom_ind);
        beta = pinv(Waux)*Ytrain;
        P=sparse(atom_ind,1:M,1,size(extXtrain,2),M);
        beta = P*beta;
        
    case 'ridge'% Linear regression with L2 penalty
        beta = ridgeregression(extXtrain,Ytrain,lambda);
       
end 
%now, get the coefficients
errtrain=mean_squared_error(Ytrain,extXtrain,beta);

extXtest=cat(2,Xtest,ones(size(Xtest,1),1));
errtest=mean_squared_error(Ytest,extXtest,beta);
errrandom=mean_squared_error(Ytest,zeros(size(extXtest)),zeros(size(beta)));


%[errtrain errtest errrandom];
