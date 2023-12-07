clear
%create the initial signal
n=99;
h = 1/(n-1);
dt = 0.001;
K = 50;
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

u1 = perona_malik(noisy_u0,h,1000,n,dt,K,0.1);

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
title('Denoised Signal With Perona-Malik model') 
linkaxes([ax1 ax2 ax3],'xy')
ax1.YLim = [0 2.5];


function u = perona_malik(u0,h,nt,n,dt,K,eps)
    %create the iterated array
    u=u0(2:n+1);
    c=0;
    err = 1;
    t=0;
    v = zeros(1,n);
    boundary = u0(1);
    %initiate time loop
    while t<nt
        for i = 2:n-1
            forward = (u(i+1)-u(i))/h;
            backward = (u(i)-u(i-1))/h;
            c_f = 1/(1+abs(forward)/K);
            c_b = 1/(1+abs(backward)/K);
            v(i) = c_f*forward/sqrt(forward^2 +eps^2) - c_b *backward/sqrt(backward^2 +eps^2);
        end
        %check error
        err = max(abs(u-v));
        u = u + dt*v;
        u(1) = boundary; u(end)=boundary;
        t=t+1;
    end
end