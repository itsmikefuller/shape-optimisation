%Shape optimisation example: find shape \Omega that minimises
%the cost functional J(\Omega)=\int_\Omega f dx.

f_ = @(x,y) x.^2+y.^2-1; %Integrand
f = chebfun2(@(x,y) f_(x,y), [-5 5 -5 5]);
exact = fimplicit(f_, 'r');
set(exact,'LineWidth',2);
hold on

g_ = @(t) 0.4 + 0.3*1i + 0.1*cos(t) + 0.4*1i*sin(t); %Boundary
t = linspace(0,2*pi); 
g = chebfun(@(t) g_(t), [0, 2*pi], 'trig');
dg = diff(g);
n_ = -1i*dg; n = n_./abs(n_); %Unit normal to boundary

J = @(f,g) integral2(f,g); %Cost functional, J(\Omega)
dJ = @(f,g,V) integral(f.*dot(V,n),g); %dJ(\Omega,V)
fn = chebfun(@(t) n(t).*f(real(g(t)), imag(g(t))), [0 2*pi]); %Search direction

init = plot(g, 'k');
hold on
set(init,'LineWidth',2);

tol = 0.01;
iteration = 0;

while abs(dJ(f,g,fn)) >= tol
    
    hold on
    iteration = iteration + 1
    fn = chebfun(@(t) n(t).*f(real(g(t)), imag(g(t))), [0 2*pi]);
    
    % BLS for shapes; step size algorithm
        alpha = 0.1; beta = 0.7; s = 1;
        while J(f,g-s*fn) > J(f,g) + alpha*s*dJ(f,g,-fn);
            s = beta*s;
        end
    
    step = s
        
    q = quiver(real(g(t)), imag(g(t)), -s*real(fn(t)), -s*imag(fn(t)),0);
    set(q,'MaxHeadSize',0.075,'AutoScaleFactor',1);
    g = g - s*fn; %Updated boundary
    plot(real(g(t)), imag(g(t)), 'b')
    
end

axis equal

%ax = gca;
%ax.Visible = 'off';