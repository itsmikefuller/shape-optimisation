%Shape Optimisation example: find the shape
%\Omega^* \in \argmin_\Omega J(\Omega)=\int_\Omega f dx.

%Integrand, f
f_ = @(x,y) (x-y).^2+(x.*y-1).^4-2;
f = chebfun2(@(x,y) f_(x,y), [-5 5 -5 5]);

%Finding the minimum of f to define \partial\Omega^{(0)}
[Y,X] = min2(f);
x1 = X(1); x2 = X(2);
r = sqrt(x1.^2+x2.^2); theta = atan2(x2,x1);

%Initial boundary, \partial\Omega^{(0)}
g_ = @(t) r*(cos(theta)+1i*sin(theta)) + 0.1*cos(t) + 0.1*1i*sin(t);
t = linspace(0,2*pi); 
g = chebfun(@(t) g_(t), [0, 2*pi], 'trig');
init = plot(g, 'k'); hold on; set(init,'LineWidth',2);

%Unit normal to boundary
dg = diff(g); n_ = -1i*dg; n = n_./abs(n_);

%Functional, J(\Omega), Shape derivative dJ(\Omega,V)
J = @(f,g) integral2(f,g); 
dJ = @(f,g,V) integral(f.*dot(V,n),g);

tol = 0.01;
iteration = 0;

while abs(dJ(f,g,fn)) >= tol
    
    hold on
    iteration = iteration + 1
    fn = chebfun(@(t) n(t).*f(real(g(t)), imag(g(t))), [0 2*pi]);
    
    % BLS for shapes; step size algorithm
        alpha = 0.1; beta = 0.7; s = 0.5;
        while J(f,g-s*fn) > J(f,g) + alpha*s*dJ(f,g,-fn);
            s = beta*s;
        end
    step = s
        
    q = quiver(real(g(t)), imag(g(t)), -s*real(fn(t)), -s*imag(fn(t)),0);
    set(q,'MaxHeadSize',0.075,'AutoScaleFactor',1);
    
    %Updated boundary
    g = g - s*fn;
    plot(real(g(t)), imag(g(t)), 'b')
    
end

%Optimal boundary
exact = fimplicit(f_, 'r');
set(exact,'LineWidth',2);
axis equal

%ax = gca;
%ax.Visible = 'off';