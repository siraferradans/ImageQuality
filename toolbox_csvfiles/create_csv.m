function create_csv(filename, IDS, bboxPred)
% bboxPred is a Nx4 array where N is the number of images
% bboxPred must be sorted such that bboxPred(i,:) is the bounding bow of testing image number i.

csvContent = {};
for i = 1:length(bboxPred)
    csvContent{i,1} = num2str(IDS(i));
    csvContent{i,2} = num2str(bboxPred(i)); % xTopLeft
end
header = 'ID,aesthetic_score';
writecsv(filename,csvContent,header);
end

function writecsv(filename, cellarray, header)
fid=fopen(filename,'w');
[rows,cols]=size(cellarray);
fprintf(fid,[header '\n']);
for i=1:rows
    for k=1:cols
        fprintf(fid,'%s',cellarray{i,k});
        if(k<cols)
             fprintf(fid,',');
        end
    end
    fprintf(fid,'\n');
end
fclose(fid);
end