%% Testing features 
addpath(genpath('~/Regain/code/'));
Ni=128;

J=log2(Ni)-1;
L=8;
Jinit=1;

num_data=10000;%:10000:50000
for i_nd=1:length(num_data)
    
    disp([num_data(i_nd) J Jinit L])
    
    [scat]=geterrors_featuresScattering(Ni,num_data(i_nd),J,L,Jinit);
    err_scat_nofilt(i_nd,:)=scat

    
    gi=geterrors_featuresGist(Ni,num_data(i_nd));
    err_gist(i_nd,:) = gi
    


    
%     [gi,s,sh,g]=geterrors_featuresLiterature_and_beyond(Ni,num_data(i_nd));
%     err_simple(i_nd,:)=s;
%     err_simplehighfreq(i_nd,:)=sh;
%     err_gram(i_nd,:)=g;
%     err_gist(i_nd,:)=gi;
end

h=figure;
errorbar(num_data,err_scat(:,1),err_scat(:,2));
hold on; 
errorbar(num_data,err_gist(:,1),err_gist(:,2),'k')





% h=figure; 
% errorbar(num_data,err_scat(:,1),err_scat(:,2));
% h=figure;
% errorbar(num_data,err_simple(:,1),err_simple(:,2),'r');hold on;
% errorbar(num_data,err_simplehighfreq(:,1),err_simplehighfreq(:,2),'b');
% errorbar(num_data,err_gram(:,1),err_gram(:,2),'k')
% errorbar(num_data,err_gist(:,1),err_gist(:,2),'m')
% save(h,'./errors_literature_beyond.fig')
% save(h,'./errors_literature_beyond.png');