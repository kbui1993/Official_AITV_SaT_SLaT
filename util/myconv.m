%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function convolves the blurring operator g with the image f. 
%Input:
%   f: image to be blurred
%   g: filter for blurring the image f
%Output:
%   h: blurred image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = myconv(f,g)

%get size
[ny,nx]=size(f);

%create filter
H = psf2otf(g, [ny,nx]);

%convolve via fourier transform and obtain back the blurred image by
%inverse fourier transform
h = ifft2(fft2(f).*H);

%obtain real part
h = real(h);

end
