function scat=getscatteringvector(x,filters,options)

Jend = getoptions(options,'J',length(filters.psi));
colorspace=getoptions(options,'colorspace','rgb');
normtype=getoptions(options,'normtype','linear');
secondorder=getoptions(options,'secondorder',false);

% Resizing the image
Ni = size(filters.phi); 
x = imresize(x,Ni)/255; %[0,1] range

L=length(filters.psi{1});

   
%Select color space
switch(colorspace)
    case 'rgb'
        %we are good
    case 'yuv'
        x = rgb2yuv(x);
    case 'hsv'
        x = rgb2hsv(x);
    case 'lab'
        x = rgb2lab(x);
    case 'opponent-colors'
        x=rgb2opponentcolors(x);
end 




if ~secondorder
    scattering=@(x)fastscattering2d(x,filters,1,Jend,false);
else 
    scattering=@(x)fastscattering2d(x,filters,1,Jend,true);
end 

%Select Normalization
switch(normtype)
    case 'linear'
        normalize=@(x)x;
        norm_scat=@(x)normalize(scattering(x));
    case 'log'
        normalize=@(x)log(x);
        norm_scat=@(x)normalize(scattering(x));
    case 'division'
        %just implemented for first layer
        norm_division=true;
        norm_scat=@(x)fastscattering2d(x,filters,1,Jend,second_order,norm_division);
        %rewritting the scattering funct!
end 


%Apply scattering with all the options to each color channel
for c=1:3
    % (scatcoef,U1,U2,color)
    s(:,:,:,c)= norm_scat(x(:,:,c));
end 
%we want non-overlapping windows
scat=real(s(:,1:2:end,1:2:end,:));

%scat = mean(mean(real(s),2),3);%not localized: mean on the spatial variable

function y=normalize_perlayer(x,secondorder,J,L)
%just for first layer for now
num_coefs = size(x,1);
y=x(2:J*L+1,:,:)./repmat(x(1,:,:),[num_coefs-1 1 1]);

if secondorder
    
end 






function y=rgb2opponentcolors(x)

y(:,:,1)=mean(x,3);
y(:,:,2)=x(:,:,2)-x(:,:,1);
y(:,:,3)=x(:,:,3)-(x(:,:,1)+x(:,:,2));



