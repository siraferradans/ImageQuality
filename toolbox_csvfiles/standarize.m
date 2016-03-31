function X=standarize(X)

meanX = mean(X,1);
X = X-repmat(meanX,[size(X,1) 1]);
stdX = std(X);
invX = 1./stdX;
X = X.*repmat(invX,[size(X,1) 1]); %now X is centered and standarized