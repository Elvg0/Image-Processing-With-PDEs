clear
%create the initial signal
n=99;
h = 1/(n-1);
lambda=0.1;
dt = 0.001;
X=0:h:1;
u0 = 1:n+2;
u0(1:round(0.2*n+2)) = 2;
u0(round(0.9*n+2):n+2) = 2;
u0(round(0.2*n+2):round(0.4*n+2))=1;
u0(round(0.7*n+2):round(0.9*n+2))=1;
u0(round(0.4*n+2):round(0.7*n+2))=0.5;

%create noisy signal
noise = 0.1 * randn(1,n);
noise = [0,noise,0];
noisy_u0 = u0+noise;

u1 = ROF(noisy_u0,lambda,h,1000,n,dt,0.01);

tiledlayout(3,1)
% First plot
ax1 = nexttile;
plot(X,u0(2:n+1))
title('Original Signal') 
% Second plot
ax2 = nexttile;
plot(X,noisy_u0(2:n+1))
title('Noisy Signal') 
% Third plot
ax3 = nexttile;
plot(X,u1)
title('Denoised Signal With ROF model') 
linkaxes([ax1 ax2 ax3],'xy')
ax1.YLim = [0 2.5];


function u = ROF(u0,lambda,h,nt,n,dt,eps)
    %create the iterated array
    u=u0(2:n+1);
    err = 500;
    t =1;
    v = zeros(1,n);
    boundary = u0(1);
    %initiate time loop
    while (t<nt) && (err>3)
        err=0;
        for i = 2:n-1
            forward = (u(i+1)-u(i))/h;
            backward = (u(i)-u(i-1))/h;
            f_norm = sqrt(forward^2 + eps^2);
            b_norm = sqrt(backward^2 + eps^2);
            full = forward/f_norm - backward/b_norm;
            v(i) =  full + lambda*(u(i)-u0(i+1));
        end
        t= t+1;
        %check error
        err = max(abs(u-v));
        u = u+dt*v;
        u(1) = boundary; u(end)=boundary;
    end
end




