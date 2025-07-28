g_ = @(t) [0.2+0.3i] + 0.6*cos(t) + 0.2*1i*sin(t);
t = linspace(0,2*pi); 
g = chebfun(@(t) g_(t), [0, 2*pi], 'trig'); %Initial boundary
init = plot(g, 'k') %Plot of initial boundary
set(init,'LineWidth',2);
dg = diff(g); n_ = -1i*dg;
n = n_./abs(n_); %Unit normal to boundary

f_ = @(x,y) x.^2 + y.^2 - 1; 
f = chebfun2(@(x,y) f_(x,y), [-5 5 -5 5]); %Integrand, f

tol=0.01;

while abs(dJ(f,g,fn)) >= tol
    hold on
    dg = diff(g); n_ = -1i*dg; n = n_./abs(n_); %Unit normal to boundary
    fn = n.*f(real(g), imag(g));
    
    % BLS for shapes; step size algorithm
        alpha = 0.1; beta = 0.7; s = 1;
        while J(f,g-s*fn) > J(f,g) + alpha*s*dJ(f,g,-fn);
            s = beta*s;
        end
    
    step = s
    
    g = g - s*fn; %Updated boundary
    plot(real(g(t)), imag(g(t)), 'b')
end

exact = fimplicit(f_, 'r')
set(exact,'LineWidth',2);
axis equal
