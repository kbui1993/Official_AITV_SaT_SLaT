%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function performs AITV SLaT on a color image.
%Input:
%   f: color image
%   lambda: fidelity paramter
%   mu: smoothing parameter
%   alpha: sparsity parameter for L1-\alpha L2 term of gradient
%   k: number of clusters
%Output:
%   result: segmented result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [result, idx] = L1mL2_SLaT(f, lambda, mu, alpha, k)
    %rescale image to [0,1]
    f = rescale_color_image(f);
    
    %preinitialize
    uu = zeros(size(f));
    %get channel size
    zLen = size(uu,3);
    
    %Stage 1: smooth each channel
    parfor i = 1:zLen
        uu(:,:,i) = L1mL2smooth(f(:,:,i), lambda, mu, alpha, 2);
    end
    
    %Stage 2: Lifting
    cform = makecform('srgb2lab');
    g = double(applycform(uint8(uu*255),cform))/255;
    uu(:,:,4:6) = rescale_color_image(g);
    
    %Stage 3: Thresholding via kmeans
    [m,n,~] = size(uu);
    u_vector = reshape(uu, m*n, 6);
    idx = kmeans(u_vector, k, 'Replicates', 5);
    idx = reshape(idx, m,n);
    
    %postprocessing step
    %compute mean of each part and construct piecewise constant image
    mean_c = zeros(k,3);
    result = zeros(m,n,3);
    for i = 1:k
        region_channel1 = double(i==idx).*uu(:,:,1);
        region_channel2 = double(i==idx).*uu(:,:,2);
        region_channel3 = double(i==idx).*uu(:,:,3);
        
        mean_c(i,:) = [sum(region_channel1(:))/(sum(region_channel1(:)>0)),...
            sum(region_channel2(:))/(sum(region_channel2(:)>0)),...
            sum(region_channel3(:))/(sum(region_channel3(:)>0))];
        
        result(:,:,1) = result(:,:,1) +  mean_c(i,1)*double(i==idx);
        result(:,:,2) = result(:,:,2) +  mean_c(i,2)*double(i==idx);
        result(:,:,3) = result(:,:,3) +  mean_c(i,3)*double(i==idx);
    end
end