% set type of noise
noise_setting = 0; %  0 for salt & pepper; 1 for random-valued

%read image
fui8 = imread('shape.png');
fui8 = rgb2gray(fui8);

f = double(fui8);
[N,M] = size(f);

%create color version
f_color = zeros(385,385,3);
f_color(:,:,1) = double(f>0)*0.5;
f_color(:,:,2) = double(f>0)*0.9;
f_color(:,:,3) = double(f>0)*0.25;

%set seed
rng(1234);

%add noise to each channel; 0 for salt & pepper and 1 for random-valued
fnoise = impulsenoise(f_color, 0.6, noise_setting);

if noise_setting == 0
    lambda = 1; mu = 1;
else
    lambda = 1.4; mu = 1;
end


%L1-alpha L2 SLaT method alpha = 0.8
[SLaT_0pt8_result, SLaT_0pt8_result_idx] = L1mL2_SLaT(fnoise, lambda, mu, 0.8, 2);
SLaT_0pt8_DICE = max(dice(double(SLaT_0pt8_result_idx>1), f/255), dice(double(SLaT_0pt8_result_idx<2), f/255));

%L1-alpha L2 SLaT method alpha = 0.6
[SLaT_0pt6_result,SLaT_0pt6_result_idx]  = L1mL2_SLaT(fnoise, lambda, mu, 0.6, 2);
SLaT_0pt6_DICE = max(dice(double(SLaT_0pt6_result_idx>1), f/255), dice(double(SLaT_0pt6_result_idx<2), f/255));


%L1-alpha L2 SLaT method alpha = 0.4
[SLaT_0pt4_result, SLaT_0pt4_result_idx] = L1mL2_SLaT(fnoise, lambda, mu, 0.4, 2);
SLaT_0pt4_DICE = max(dice(double(SLaT_0pt4_result_idx>1), f/255), dice(double(SLaT_0pt4_result_idx<2), f/255));


%L1-alpha L2 SLaT method alpha = 0.2
[SLaT_0pt2_result, SLaT_0pt2_result_idx] = L1mL2_SLaT(fnoise, lambda, mu, 0.2, 2);
SLaT_0pt2_DICE = max(dice(double(SLaT_0pt2_result_idx>1), f/255), dice(double(SLaT_0pt2_result_idx<2), f/255));

%plot figure
figure;
subplot(2,4,1);
imagesc(f_color); axis off; axis square; 
title('Original');

subplot(2,4,2);
imagesc(fnoise); axis off; axis square; 
title('Corrupted Image');

subplot(2,4,5);
imagesc(SLaT_0pt2_result); axis off; axis square; 
title(['\alpha =0.2', 'DICE:' + string(SLaT_0pt2_DICE)])

subplot(2,4,6);
imagesc(SLaT_0pt4_result); axis off; axis square; 
title(['\alpha =0.4', 'DICE:' + string(SLaT_0pt4_DICE)])

subplot(2,4,7);
imagesc(SLaT_0pt6_result); axis off; axis square; 
title(['\alpha =0.6', 'DICE:' + string(SLaT_0pt6_DICE)])

subplot(2,4,8);
imagesc(SLaT_0pt8_result);axis off; axis square; 
title(['\alpha =0.8', 'DICE:' + string(SLaT_0pt8_DICE)])
