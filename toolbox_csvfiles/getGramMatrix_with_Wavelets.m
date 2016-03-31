function GM = getGramMatrix_with_Wavelets(x,filters,Jinit)

J= length(filters.psi);
L= length(filters.psi{1});
linearindx=@(j,l)(j-Jinit-1)*L+l;
flat=@(x)x(:);

X = fft2(x);

Wx=zeros((J-Jinit)*L+1,3,size(x,1)*size(x,2));
for c=1:3
    for j=Jinit+1:J
        for l=1:L
            %do it indep. for each color
            Wx(linearindx(j,l),c,:)=flat(ifft2(X(:,:,c).*filters.psi{j}{l}));
        end
    end

    Wx(end,c,:)=flat(ifft2(X(:,:,c).*filters.phi));
end 

Wx = reshape(Wx,size(Wx,1)*size(Wx,2),size(Wx,3));

GM = Wx*Wx';
