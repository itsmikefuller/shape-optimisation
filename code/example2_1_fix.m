%Shape optimisation example: find shape \Omega that minimises
%the cost functional J(\Omega)=\int_\Omega f dx.

f_ = @(x,y) (x-y).^2+(2*x.*y-1).^4-2; %Integrand
f = chebfun2(@(x,y) f_(x,y), [-5 5 -5 5]);

[Y,X] = min2(f);
x1 = X(1); x2 = X(2);
r = sqrt(x1.^2+x2.^2); theta = atan2(x2,x1);

g_ = @(t) r*(cos(theta)+1i*sin(theta)) + 0.1*cos(t) + 0.1*1i*sin(t); %Boundary
t = linspace(0,2*pi); 
g = chebfun(@(t) g_(t), [0, 2*pi], 'trig');
init = plot(g, 'k'); %Initial translated boundary
hold on
set(init,'LineWidth',2);

dg = diff(g);
n_ = -1i*dg; n = n_./abs(n_); %Unit normal to boundary

plot(real(g(t)), imag(g(t)), 'b'); %Initial boundary
hold on

J = @(f,g) integral2(f,g); %Cost functional, J(\Omega)
dJ = @(f,g,V) integral(f.*dot(V,n),g); %dJ(\Omega,V)
fn = chebfun(@(t) n(t).*f(real(g(t)), imag(g(t))), [0 2*pi]); %Search direction

tol = 0.01;
iteration = 0;
    
  for k=1:14
    hold on
    fn = chebfun(@(t) n(t).*f(real(g(t)), imag(g(t))), [0 2*pi]);
    s = 0.1; %Step Size
    quiver(real(g(t)), imag(g(t)), -s*real(fn(t)), -s*imag(fn(t)),0);
    g = g - s*fn; %Updated boundary
    plot(real(g(t)), imag(g(t)), 'b')
    axis equal
  end

exact = fimplicit(f_, 'r');
set(exact,'LineWidth',2);
axis equal

%ax = gca;
%ax.Visible = 'off';