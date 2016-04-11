function [err,bias, variance]=get_bias_variance(Y,X,beta)
    
n_trials = size(beta,2);
Ytilde = 1000*ones(size(Y,1),n_trials);
for indx=1:n_trials
    Ytilde(:,indx)=X*beta(1:end-1,indx)+beta(end,indx);
end 

ybar=mean(Ytilde,2);%mean 'y tilde' along trials
bias = mean((ybar-Y).^2);%bias-squared
variance = mean(mean((repmat(ybar,[1 n_trials])-Ytilde).^2,2));
err = mean( mean((Ytilde - repmat(Y,[1 n_trials])).^2) );