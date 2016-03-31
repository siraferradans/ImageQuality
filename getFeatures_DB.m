function DBS = getFeatures_DB(d,Ni,files,path,feature_extractionfnc)

flat=@(x)x(:);

%files = dir([folderpath '*.jpg']);
DBS = -ones(length(files),d);
%disp('Generating features')
%tic

for i=1:length(files)
         in=double(imread([path '/' files(i).name]));
         
         %HSV space
         if size(in,3)==3
           % in = rgb2hsv(in);
         else 
             in = repmat(in,[1 1 3]);
         end 
        inc = imresize(in,[Ni Ni]);
%        inc = repmat(prefilt(in,4,[Ni,Ni]),[1 1 3]);
        
        s= feature_extractionfnc(inc); 
        DBS(i,:) = flat(s);
end
%disp(['Complete Feature extraction time DB:' num2str(toc)])