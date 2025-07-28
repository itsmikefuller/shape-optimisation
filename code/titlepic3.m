%Shape optimisation example: find shape \Omega that minimises
%the cost functional J(\Omega)=\int_\Omega f dx.

close all

g_ = @(t) 0.3-0.2*1i + 0.6*cos(t) + 0.2*1i*sin(t); %Boundary, \partial\Omega
t = linspace(0,2*pi); t2 = linspace(0,2*pi,1e3);
g = chebfun(@(t) g_(t), [0, 2*pi], 'trig');
dg = diff(g); n = -1i*dg; n = n./abs(n); %Unit normal to boundary

f_ = @(x,y) x.^6+y.^6+x.^4*sin(y.^2)-2; %Integrand, f
f = chebfun2(@(x,y) f_(x,y), [-5 5 -5 5]);

J = @(f,g) integral2(f,g); %Cost functional, J(\Omega)
dJ = @(f,g,V) integral(f.*dot(V,n),g); %dJ(\Omega,V)

init = plot(g, 'k')
hold on
set(init,'LineWidth',2);
%quiver(real(g(t)), imag(g(t)), real(n(t)), imag(n(t)),0)

for k=1:5
    hold on
    fn = n.*f(real(g), imag(g));
    s = 0.2; %Step Size
    q = quiver(real(g(t)), imag(g(t)), -s*real(fn(t)), -s*imag(fn(t)),0);
    set(q,'MaxHeadSize',0.075,'AutoScaleFactor',1);
    g = g - s*fn; %Updated boundary
    plot(real(g(t2)), imag(g(t2)), 'b')
end

exact = fimplicit(f_, 'r')
set(exact,'LineWidth',2);
axis equal

ax = gca
ax.Visible = 'off'