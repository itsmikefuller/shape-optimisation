%Shape optimisation example: find shape \Omega that minimises
%the cost functional J(\Omega)=\int_\Omega f dx.

close all

g_ = @(t) 0.2+0.3*1i+ 0.6*cos(t) + 0.2*1i*sin(t); %Boundary, \partial\Omega
t = linspace(0,2*pi); 
g = chebfun(@(t) g_(t), [0, 2*pi], 'trig');
dg = diff(g);
n = -1i*dg;
n = n./abs(n); %Unit normal to boundary

f_ = @(x,y) x.^2+y.^2-1; %Integrand, f
f = chebfun2(@(x,y) f_(x,y), [-5 5 -5 5]);

%J = @(f,g) integral2(f,g); %Cost functional, J(\Omega)
%dJ = @(f,g,V) integral(f.*dot(V,n),g); %dJ(\Omega,V)

init = plot(g, 'k');
set(init,'LineWidth',2);
%quiver(real(g(t)), imag(g(t)), real(n(t)), imag(n(t)),0)
hold on

for k=1:7
    dg = diff(g); n = -1i*dg; n = n./abs(n);
    fn = n.*f(real(g), imag(g));
    s = 0.2; %Step Size
    %quiver(real(g(t)), imag(g(t)), -s*real(fn(t)), -s*imag(fn(t)),0);
    g = g - s*fn; %Updated boundary
    plot(real(g(t)), imag(g(t)), 'b')
    axis equal
    pause
end

exact = fimplicit(f_, 'r');
set(exact,'LineWidth',2);