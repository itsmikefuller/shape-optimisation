%Shape optimisation example: find shape \Omega that minimises
%the cost functional J(\Omega)=\int_\Omega f dx.

g_ = @(t) 0.1*cos(t) + 0.1*1i*sin(t); %Boundary, \partial\Omega
t = linspace(0,2*pi); 
g = chebfun(@(t) g_(t), [0, 2*pi], 'trig');
dg = diff(g);
n = -1i*dg;
n = n./abs(n); %Unit normal to boundary

f_ = @(x,y) x.^2+x*y+2*y.^2-1; %Integrand, f
f = chebfun2(@(x,y) f_(x,y), [-5 5 -5 5]);

J = @(f,g) integral2(f,g); %Cost functional, J(\Omega)
dJ = @(f,g,V) integral(f.*dot(V,n),g); %dJ(\Omega,V)

init = plot(g, 'k')
hold on
set(init,'LineWidth',2);
%quiver(real(g(t)), imag(g(t)), real(n(t)), imag(n(t)),0)

for k=1:10
    hold on
    fn = chebfun(@(t) n(t).*f(real(g(t)), imag(g(t))), [0 2*pi]);
    s = 0.2; %Step Size
    quiver(real(g(t)), imag(g(t)), -s*real(fn(t)), -s*imag(fn(t)),0)
    g = g - s*fn; %Updated boundary
    plot(real(g(t)), imag(g(t)), 'b')
    axis equal
end

exact = fimplicit(@(x,y) x.^2+x*y+2*y.^2-1, 'r')
set(exact,'LineWidth',2);

