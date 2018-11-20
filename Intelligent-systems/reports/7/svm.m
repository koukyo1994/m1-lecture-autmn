clear all; rand('state', 0); randn('state', 0);
n = 200; a = linspace(0, 4*pi, n/2);
u = [a .* cos(a) (a + pi) .* cos(a)]' + rand(n, 1);
v = [a .* sin(a) (a + pi) .* sin(a)]' + rand(n, 1);
x = [u v]; y = [ones(1, n/2) -ones(1, n/2)];

hh=2*1^2;

m = 100; X = linspace(-15, 15, m)'; X2 = X.^2;
U=exp(-(repmat(u.^2,1,m)+repmat(X2',n,1)-2*u*X')/hh);
V=exp(-(repmat(v.^2,1,m)+repmat(X2',n,1)-2*v*X')/hh); 
figure(1); clf; hold on; axis([-15 15 -15 15]); 
plot(x(y==1,1),x(y==1,2),'bo'); plot(x(y==-1,1),x(y==-1,2),'rx');
colormap([1 0.7 1; 0.7 1 1]);