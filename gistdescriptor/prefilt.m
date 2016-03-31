function output = prefilt(img, fc, imageSize)
% ima = prefilt(img, fc);
% fc  = 4 (default)
% 
% Input images are double in the range [0, 255];
% You can also input a block of images [ncols nrows 3 Nimages]
%
% For color images, normalization is done by dividing by the local
% luminance variance.

if nargin == 1
    fc = 4; % 4 cycles/image
end

%%%%% anadido por Sira viene del codigo Gist
 % convert to gray scale
        img = single(mean(img,3));

        % resize and crop image to make it square
        img = imresizecrop(img, imageSize, 'bilinear');
        %img = imresize(img, param.imageSize, 'bilinear'); %jhhays

        % scale intensities to be in the range [0 255]
        img = img-min(img(:));
        img = 255*img/max(img(:));
      
%%%%%%%%%%


w = 5;
s1 = fc/sqrt(log(2));

% Pad images to reduce boundary artifacts
img = log(img+1);
img = padarray(img, [w w], 'symmetric');
[sn, sm, c, N] = size(img);
n = max([sn sm]);
n = n + mod(n,2);
img = padarray(img, [n-sn n-sm], 'symmetric','post');

% Filter
[fx, fy] = meshgrid(-n/2:n/2-1);
gf = fftshift(exp(-(fx.^2+fy.^2)/(s1^2)));
gf = repmat(gf, [1 1 c N]);

% Whitening
output = img - real(ifft2(fft2(img).*gf));
clear img

% Local contrast normalization
localstd = repmat(sqrt(abs(ifft2(fft2(mean(output,3).^2).*gf(:,:,1,:)))), [1 1 c 1]); 
output = output./(.2+localstd);

% Crop output to have same size than the input
output = output(w+1:sn-w, w+1:sm-w,:,:);

