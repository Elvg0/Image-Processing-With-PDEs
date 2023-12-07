n=99;
h = 1/(n-1);
dt = 0.1;
D=1;
X=0:h:1;
u0 = 1:n+2;
u0(1:0.2*n+2) = 2;
u0(0.9*n+2:n+2) = 2;
u0(0.2*n+2:0.4*n+2)=1;
u0(0.7*n+2:0.9*n+2)=1;
u0(0.4*n+2:0.7*n+2)=0.5;
noise = 0.05 * randn(1,n);
noise = [0,noise,0];
noisy_u0 = u0+noise;
u1 = heat(noisy_u0,h,500,n,dt,D);


subplot(3,1,1), plot(X,u0(2:n+1),'-')
subplot(3,1,2), plot(X,noisy_u0(2:n+1),'-')
subplot(3,1,3), plot(X,u1,'-')

function u = heat(u0,h,nt,n,dt,D)
    alpha = 1/h^2;
    K = spdiags(ones(n,1)*[1 -2 1],-1:1,n,n);
    u = u0(2:n+1);
    for k = 1:nt
        Dxx = K/u;
        Dxx(1) = 0; Dxx(end)=0;
        u=u+dt*(D*Dxx.');
        u(1)=2;u(end)=2;
    end
end