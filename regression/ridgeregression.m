function [W,loss]=ridgeregression(X,Y,lambda)

params.lambda=lambda;
%% preprocessing
meanX = mean(X,1);
X = X-repmat(meanX,[size(X,1) 1]);
stdX = std(X);
invX = 1./stdX;
X = X.*repmat(invX,[size(X,1) 1]); %now X is centered and standarized

Y = Y/100;%we know it is between (1-100)
Y = Y-mean(Y);
%%

addpath(genpath('~/AudioSynth/spams-matlab'));
W0 = zeros(size(X,2),size(Y,2));
tic 
W = mexRidgeRegression(Y,X,W0,params);
toc
loss=norm(Y-X*W);