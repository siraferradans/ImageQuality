function [err]=geterrors_featuresScattering(Ni,num_data,J,L,Jinit)

if nargin<3
    Jinit = 3;
    J=log2(Ni);
    L=1;
end 
N_minibatch=num_data;
% Function extract features
upper_matrix_indx = find(triu(cov(randn(10,3)))~=0);

flat=@(x)x(:);
[filters_image, ~,~] = generate_translate_wavelets([Ni Ni], J, L, 'image');
simplefilters.phi = filters_image{1}.phi{1};
for j=1:J
    for l=1:L
        simplefilters.psi{j}{l} = filters_image{1}.psi{1}{j}{l};
    end
end


scattering_controlled=@(x)getscatteringvector(x,simplefilters,Jinit);

%get also color info
upper_matrix_indx = find(triu(cov(randn(10,3)))~=0);

get_upper_matrix=@(C)C(upper_matrix_indx); %we want the upper triangular matrix of the cov.
vectorize=@(x)reshape(x,Ni*Ni,3);
getcov=@(x)cov(vectorize(x));
cov_and_mean =@(x)[flat(get_upper_matrix(getcov(x))) ;...
                   flat(mean(vectorize(x)))]; %1.0e+03 * [0.7484    0.7645    2.6320]

scat_and_colorinfo=@(x)[flat(scattering_controlled(x)) ; ...
                        flat(cov_and_mean(x))];


scat_and_colorinfo_resize=@(x)scat_and_colorinfo(imresize(x, [Ni Ni], 'bilinear'));
                 
%d=1+(J-Jinit+1)*L;
%feature_function=scattering_controlled;
U = Ni/2^(J-1);              
d =U^2*(1+(J-Jinit+1)*L)+3+length(upper_matrix_indx); %dimensions of the extracted features
feature_function = scat_and_colorinfo_resize;

disp('Error with scattering:')
testing_featuresloaddata_and_extract_features
err = [errtest stderrtest];
