%read image
fui8 = imread('shape.png');
fui8 = rgb2gray(fui8);
f = double(fui8);
[M,N] = size(f);

%specify a blurring operator and blur the image
g = fspecial('average', 15);
f1 = myconv(f,g);

%add noise; 0 for salt & pepper; 1 for random-valued
rng(1234)
fnoise = impulsenoise(f1, 0.5, 1);

%rescale image
fnoise = double(fnoise);
fnoise = rescale_image(fnoise);

%L1-alpha L2 SaT method alpha = 0.8
SaT_0pt8_result = Deblur_L1mL2_2Stage(fnoise, g, 1.5, 1, 0.8, 1, 2);
SaT_0pt8_result = double(SaT_0pt8_result >0.5);
SaT_0pt8_DICE = dice(SaT_0pt8_result, f/255);

%L1-alpha L2 SaT method alpha = 0.6
SaT_0pt6_result = Deblur_L1mL2_2Stage(fnoise, g, 1.5, 1, 0.6, 1, 2);
SaT_0pt6_result = double(SaT_0pt6_result >0.5);
SaT_0pt6_DICE = dice(SaT_0pt6_result, f/255);

%L1-alpha L2 SaT method alpha = 0.4
tic;
SaT_0pt4_result = Deblur_L1mL2_2Stage(fnoise, g, 1.5, 1, 0.4, 1, 2);
SaT_0pt4_result = double(SaT_0pt4_result >0.5);
SaT_0pt4_DICE = dice(SaT_0pt4_result, f/255);

%L1-alpha L2 SaT method alpha = 0.2
tic;
SaT_0pt2_result = Deblur_L1mL2_2Stage(fnoise, g, 1.5, 1, 0.2, 1, 2);
SaT_0pt2_result = double(SaT_0pt2_result >0.5);
SaT_0pt2_DICE = dice(SaT_0pt2_result, f/255);

%plot figure
figure;
subplot(2,4,1);
imagesc(f); axis off; axis square; colormap gray;
title('Original');

subplot(2,4,2);
imagesc(fnoise); axis off; axis square; colormap gray;
title('Corrupted Image');

subplot(2,4,5);
imagesc(SaT_0pt2_result); axis off; axis square; colormap gray;
title(['\alpha =0.2', 'DICE:' + string(SaT_0pt2_DICE)])

subplot(2,4,6);
imagesc(SaT_0pt4_result); axis off; axis square; colormap gray;
title(['\alpha =0.4', 'DICE:' + string(SaT_0pt4_DICE)])

subplot(2,4,7);
imagesc(SaT_0pt6_result); axis off; axis square; colormap gray;
title(['\alpha =0.6', 'DICE:' + string(SaT_0pt6_DICE)])

subplot(2,4,8);
imagesc(SaT_0pt8_result);axis off; axis square; colormap gray;
title(['\alpha =0.8', 'DICE:' + string(SaT_0pt8_DICE)])