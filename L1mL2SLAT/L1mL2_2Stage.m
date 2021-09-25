%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function performs L1mL2 two-stage segmentation for grayscale images.
%Input:
%   f: image
%   lambda: weighing parameter for fidelity term
%   mu: weigh parameter for smoothing term
%   alpha: sparsity parameter for L1-\alpha L2 term of gradient
%   delta: penalty parameter for ADMM
%   k: number of regions/clusters
%Output:
%   result: segmented image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = L1mL2_2Stage(f, lambda, mu, alpha, delta, k)

    %rescale image
    f = rescale_image(f);

    %obtain size of f
    [m,n] = size(f);
    
    %%Two-Stage Segmentation
    %stage one: smooth the image
    u = L1mL2smooth(f, lambda, mu, alpha, delta);
    
    %stage two: perform k-means
    u_vector = reshape(u, m*n,1);
    idx = kmeans(u_vector, k, 'Replicates',5);
    idx = reshape(idx, m,n);
    
    %%postprocessing step
    %compute mean of each part and construct the piecewise constant image
    mean_c = zeros(k,1);
    result = zeros(m,n);
    for i=1:k
        region = (i==idx).*u;
        mean_c(i) = sum(region(:))/(sum(region(:)>0));
        result = result+(i==idx)*mean_c(i);
    end
end