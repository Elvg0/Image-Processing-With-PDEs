clear
%create the initial signal
n=99;
h = 1/(n-1);
dt = 0.001;
D=1.5;
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

u1 = forth_order(noisy_u0,1,1000,n,dt,D,1);

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
plot(X,u1(2:n+1,end))
title('Denoised Signal With Fourth Order PDE') 
linkaxes([ax1 ax2 ax3],'xy')
ax1.YLim = [0 2.5];


function u = forth_order(u0, h, nt,n, dt, D,lambda)
    %create solution matrix
    u = zeros(n+2,nt);
    u(:,1)=u0;
    t = 1;
    err=5;
    %initiate time loop
    while (t<nt) && (err>3)
        v = zeros(n+2,1);
        for i=3:n
            dxxxx = -1/h^4. * (u(i-2,t)-4*u(i-1,t)+6*u(i,t)-4*u(i+1,t)+u(i+2,t));
            v(i) = (D*(dxxxx/sqrt(dxxxx^2))+lambda*(u0(i)-u(i,t)));
        end
        %check error
        err = max(abs(u(:,t)-v));
        u(:,t+1) = u(:,t) + dt*v;
        u(1,t+1)=2;u(2,t+1)=2;u(n+1,t+1)=2;u(n+2,t+1)=2;
        t=t+1;
    end
end

