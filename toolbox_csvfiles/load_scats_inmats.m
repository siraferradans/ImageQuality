% load data
function [X,Y]=load_scats_inmats(max_indx)
%folder of .mat:
folder = '/users/data/ferradan/Regain/';
files =dir([folder '*.mat']);

X=[];Yscore=[];

if nargin<1
    max_indx = length(files);
end 

for i=1:max_indx
    disp([num2str(i) '/' num2str(length(files)) ' and samples:' num2str(size(X))])
    load([folder files(i).name]);
    X=cat(1,X,real(DBS));
    Yscore=cat(1,Yscore,Y);
end 
num_f=size(X,1);
Y = Yscore(1:num_f);
