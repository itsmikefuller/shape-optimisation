%Shape optimisation example: find shape \Omega that minimises
%the cost functional J(\Omega)=\int_\Omega f dx.

close all
chebfunpref.setDefaults('factory')

f_ = @(x,y) (x-y).^2+(2*x.*y-1).^4-2; %Integrand
f = chebfun2(@(x,y) f_(x,y), [-5 5 -5 5]);

[Y,X] = min2(f);
x1 = X(1); x2 = X(2);
r = sqrt(x1.^2+x2.^2); theta = atan2(x2,x1);

g_ = @(t) r*(cos(theta) + 1i*sin(theta)) + 0.1*cos(t) + 0.1*1i*sin(t); %Boundary
t = linspace(0,2*pi); t2 = linspace(0,2*pi,1e3);
g = chebfun(@(t) g_(t), [0, 2*pi], 'trig');
init = plot(g, 'k'); %Initial translated boundary
hold on
set(init,'LineWidth',2);
plot(g(t2), 'b'); %Initial boundary

hold on

%J = @(f,g) integral2(f,g); %Cost functional, J(\Omega)
%dJ = @(f,g,V) integral(f.*dot(V,n),g); %dJ(\Omega,V)
%fn = chebfun(@(t) n(t).*f(real(g(t)), imag(g(t))), [0 2*pi,1e3]); %Search direction
    
  for k=1:50
    dg = diff(g); n_ = -1i*dg; n = n_./abs(n_); %Unit normal to boundary
    fn = n.*f(real(g), imag(g));

    s = 0.05; %Step Size
    quiver(real(g(t)), imag(g(t)), s*real(-fn(t)), s*imag(-fn(t)),0);
    g = g - s*fn; %Updated boundary
    
    %Reparametrisation
    T = chebfun(@(t) t, [0 2*pi]);
    I = sum(abs(diff(g)),0,T);
    F = inv(I);
    scaling = T*I(2*pi)/2/pi;
    g2 = g(F(scaling));
    g = g2;
    
    plot(g(t2), 'b')
    
    axis equal
    %figure(2)
    %subplot(1,2,1);plot(real(-fn));title(['Re(-fn) at iteration ' num2str(k) '']);
    %subplot(1,2,2);plot(imag(-fn));title(['Im(-fn) at iteration ' num2str(k) '']);
    %figure(3)
    %plot(fn)
   % figure(4)
   % subplot(1,2,1);plot(R(T))
   % subplot(1,2,2);plot(diff(R(T)))
    %pause
    figure(1)
  end

exact = fimplicit(f_, 'r');
set(exact,'LineWidth',2);
axis equal

%ax = gca;
%ax.Visible = 'off';