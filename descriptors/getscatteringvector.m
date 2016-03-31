function scat=getscatteringvector(x,filters,Jinit)

%there is no geom. info in the color
s= fastscattering2d_order1(mean(x,3),filters,Jinit);


%no averaging
scat=real(s(:));

%scat = mean(mean(real(s),2),3);%not localized: mean on the spatial variable


