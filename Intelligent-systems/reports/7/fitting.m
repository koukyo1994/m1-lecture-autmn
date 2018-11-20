clear all; rand('state', 0); randn('state', 0)
n=50; N=1000;
x=linspace(-3, 3, n)'; X=linspace(-3, 3, N);
pix=pi*x; y=sin(pix) ./ (pix) + 0.1 * x + 0.2 * randn(n, 1);

x2 = x.^2; hh=2 * 0.3^2; l=0.1;
k=exp(-(repmat(x2, 1, n)+repmat(x2', n, 1) - 2*(x*x'))/hh);
t=(k^2+l*eye(n))\(k*y);

X2=X.^2;
K=exp(-(repmat(X2, 1, n)+repmat(X2', N, 1)-2*(X*x'))/hh);
F=K*t;

figure(1); clf; hold on; axis([-2.8 2.8 1 1.5]);
plot(X, F, 'g-'); plot(x, y, 'bo');