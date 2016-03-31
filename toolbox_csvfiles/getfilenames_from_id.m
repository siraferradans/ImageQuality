function files=getfilenames_from_id(filesID,folder)

disp('...files...')

%TODO: change into parallel computing (parfor)
for i=1:length(filesID); 
  %ids  disp([num2str(i) '/' num2str(N)])
    ids=dir([folder '/*' num2str(filesID(i)) '.jpg']);
    names={ids(:).name};
    
    I=regexp(cellstr(names),['0*' num2str(filesID(i)) '.jpg']);%check that it is the correct file (may have zeros before)
    indx=cell2mat(I)==1;
    if sum(indx)==0
        disp(['Error: cannot find file:' filesID(i)])
    else 
        files(i)=ids(indx);
    end 
end
