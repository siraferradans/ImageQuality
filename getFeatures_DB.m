function DBS = getFeatures_DB(d,files,path,feature_extractionfnc)

flat=@(x)x(:);

%files = dir([folderpath '*.jpg']);
DBS = -ones(length(files),d);
%disp('Generating features')
%tic

parfor i=1:length(files)
         in=double(imread([path '/' files(i).name]));
         
         if size(in,3)<3
             in = repmat(in,[1 1 3]);
         end  
       
        s= feature_extractionfnc(in); 
       
        DBS(i,:) = flat(s);
end
%disp(['Complete Feature extraction time DB:' num2str(toc)])