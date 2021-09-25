%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function solves the following nonconvex variant of the Mumford-Shah
%model:
%
%   min \frac{lambda}{2} \|Au-f\|_F^2 + \frac{\mu}{2} \|\nabla u\|_F^2 +
%   \|\nabla u\|_1 - \alpha \|\nabla u\|_{2,1}
%
%Input:
%   f: image
%   A: deblurring operator
%   lambda: weighing parameter for fidelity term
%   mu: weigh parameter for smoothing term
%   alpha: sparsity parameter for L1-\alpha L2 term of gradient
%   delta: penalty parameter for ADMM
%
%Output:
%   u: solution/smoothed image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u]= Deblur_L1mL2smooth(f, A, lambda, mu, alpha, delta)
    
    %penalty parameter multiplier
    rho = 1.5;
    
    %obtain dimension of image
    [rows,cols] = size(f);
    
    %Dx and Dy operators
    [DDx,DDy] = first_order_differences(rows,cols);
    
    %preintialize variable to store past u
    u0 = ones(rows,cols);
    
    %preinitialize u
    u= u0;
    
    %preinitialize w variables
    wx = u0;
    wy = u0;
    
    %preinitialize dual variable
    zx = u0;
    zy = u0;
    
    %build kernel: use the fft algorithm (5-pt stencil)
    uker = zeros(rows,cols);
    uker(1,1) = 4;uker(1,2)=-1;uker(2,1)=-1;uker(rows,1)=-1;uker(1,cols)=-1;
    
    %refit blurring operator and shift it
    [xLen_flt, yLen_flt] = size(A);
    ope_blur=zeros(rows,cols);
    ope_blur(1:xLen_flt,1:yLen_flt)=A;
    
    xLen_flt_1=floor(xLen_flt/2);yLen_flt_1=floor(yLen_flt/2);
    ope_blur_1=padarray(ope_blur,[rows,cols],'circular','pre');
    ope_blur_1=ope_blur_1(xLen_flt_1+1:rows+xLen_flt_1,yLen_flt_1+1:cols+yLen_flt_1);
    
    %% compute the fft of the first term of the right hand side
    rhslfft=lambda.*conj(fft2(ope_blur_1)).*fft2(f);
    
    for i=1:300
        
        %store past u
        u0 = u;
        
        %left-hand side of optimality eqn of u
        new_uker = lambda*conj(fft2(ope_blur_1)).*fft2(ope_blur_1)+(mu+delta)*fft2(uker);
        
        %right-hand side of optimality eqn of u
        rhs2 = delta*DDx'*(wx-zx/delta)+delta*(wy-zy/delta)*DDy;
        rhsfft = rhslfft + fft2(rhs2);
        
        %solve u-subproblem
        u = ifft2(rhsfft./new_uker);
        
        %compute relative err
        err=norm(u-u0,'fro')/norm(u, 'fro');
        
        if mod(i,10)==0
            disp(['iterations: ' num2str(i) '!  ' 'error is:   ' num2str(err)]);
        end
        
        % check the stopping criterion
        if err<10^(-4)
            break;
        end
        
        %solve w-subproblem
        temp1 = DDx*u+zx/delta;
        temp2 = u*DDy'+zy/delta;
        
        temp1 = reshape(temp1, rows*cols,1);
        temp2 = reshape(temp2, rows*cols,1);
        
        temp = [temp1, temp2];
        temp = shrinkL12(temp,1/delta, alpha);
        wx = temp(:,1);
        wy = temp(:,2);
        wx = reshape(wx, rows,cols);
        wy = reshape(wy, rows,cols);
        
        %update dual variables
        zx = zx+delta*(DDx*u-wx);
        zy = zy+delta*(u*DDy'-wy);
        
        %update ADMM penalty parameter
        delta = rho*delta;
    end


end

%--------------------------------------------------------------------------
function [H1_l,H1_r] = first_order_differences(m,n)
%--------------------------------------------------------------------------
%derivatives at the right and lower boundary are set to zero (mirroring)

d1 = [-ones(m-1,1); 0];
d2 = ones(m,1);
H1_l = spdiags([d1,d2],[0,1],m,m);

d1 = [-ones(n-1,1); 0];
d2 = ones(n,1);
H1_r = spdiags([d1,d2],[0,1],n,n);
end

function x = shrinkL12(y,lambda,alpha)
    %this function applies the proximal operator of L1-alpha L2 to each
    %row vector
        
    %initialize solution as zero vector
    x = zeros(size(y));

    %obtain the indices of the max entries of each row vector    
    [max_y, idx_y] = max(abs(y'));
    max_y = max_y';
    idx_y = idx_y';
    new_idx_y = sub2ind(size(y), (1:size(y,1))',idx_y);
    
    %compute new row vectors when max value of each row vector is greater
    %than lambda
    case1_idx = max_y > lambda;
    
    case1_result = max(abs(y(case1_idx,:))-lambda,0).*sign(y(case1_idx,:));
    norm_case1_result = sqrt(sum(case1_result.^2,2));
    x(case1_idx,:) =((norm_case1_result+alpha*lambda)./norm_case1_result).*case1_result;
    
    %compute one-sparse vector when max value of each row vector is less
    %than or equal to lambda and above (1-alpha)*lambda
    case2_idx = logical((max_y<=lambda).*(max_y>=(1-alpha)*lambda));
    x(new_idx_y(case2_idx)) = (max_y(case2_idx)+(alpha-1)*lambda).*sign(y(new_idx_y(case2_idx)));
    
end