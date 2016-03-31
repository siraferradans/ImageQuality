function DBS = getScattering_DB(J,L,Ni,files,path,simplefilters)

%U = Ni/2^(J-1);
U = Ni/2^(J); %non-overlapping
d = J*L+1; %first order
%d = (J*(J-1)*L^2/2+J*L+1);


% disp('Get filters:')
% [filters_image, ~,~] = generate_translate_wavelets([Ni Ni], J, L, 'image');
% 
% %% translate into gpuarrays
% simplefilters.phi = filters_image{1}.phi{1};
% for j=1:J
%     for l=1:L
%         simplefilters.psi{j}{l} = filters_image{1}.psi{1}{j}{l};
%     end
% end 
%%
flat=@(x)x(:);

%files = dir([folderpath '*.jpg']);
DBS = -ones(length(files),3*d*U^2);
disp('Generating scattering')
tic


parfor i=1:length(files)
         in=double(imread([path '/' files(i).name]));
         
%          if sum(size(in(:,:,1))>Ni) %crop image
%         %   size(in)
%            if (size(in,1)< Ni) || (size(in,2) < Ni)
%                padsize = max(round((Ni-size(in(:,:,1)))/2),1);
%                in = padarray(in,padsize,'symmetric');
%            end 
%            
%            p = max(round(size(in(:,:,1))/2-Ni/2),1);
%            [size(in) p]
%            in = in(p(1):p(1)+Ni-1,p(2):p(2)+Ni-1,:);
%          end
%          
%          %set to range (0,1)
%          in = in/255;
         %HSV space
         if size(in,3)==3
            in = rgb2hsv(in);
         end 
         v = zeros(d,U^2,3);
         
         for c=1:size(in,3)
            inc = imresize(in(:,:,c),[Ni Ni]);
            s= fastscattering2d_order1(inc, simplefilters); 
            v(:,:,c) = real(reshape(s(:,1:2:end,1:2:end),size(v(:,:,1))));%non-overlapping
        end 
        DBS(i,:) = flat(v);
end
disp(['Complete time DB:' num2str(toc)])