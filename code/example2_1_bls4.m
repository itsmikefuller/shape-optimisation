%Shape optimisation example: find shape \Omega that minimises
%the cost functional J(\Omega)=\int_\Omega f dx.

close all

f_ = @(x,y) (x-y).^2+(2*x.*y-1).^4-2; %Integrand
f = chebfun2(@(x,y) f_(x,y), [-5 5 -5 5]);
exact = fimplicit(f_, 'r');
set(exact,'LineWidth',2);
hold on

[Y,X] = min2(f);
x1 = X(1); x2 = X(2);
r = sqrt(x1.^2+x2.^2); theta = atan2(x2,x1);

g_ = @(t) r*(cos(theta) + 1i*sin(theta)) + 0.1*cos(t) + 0.1*1i*sin(t); %Boundary
t = linspace(0,2*pi); t2 = linspace(0,2*pi,1e4);
g = chebfun(@(t) g_(t), [0, 2*pi], 'trig');
init = plot(g, 'k'); %Initial translated boundary

set(init,'LineWidth',2);
plot(g, 'b'); %Initial boundary

%J = @(f,g) integral2(f,g); %Cost functional, J(\Omega)
%dJ = @(f,g,V) integral(f.*dot(V,n),g); %dJ(\Omega,V)
%fn = chebfun(@(t) n(t).*f(real(g(t)), imag(g(t))), [0 2*pi,1e3]); %Search direction
    
  for k=1:55
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
    
    plot(g, 'b');%title(['Iteration ' num2str(k) '']);
    
    set(gca,'linewidth',1.5);
    set(gcf,'Position',[100 100 800 800]);
    axis equal
    
    %figure(2)
        %subplot(2,2,1);plot(g2);title('Reparametrisation R(t)');
       % subplot(2,2,2);plot(abs(diff(g2)));title('Slope dR/dt');
        %subplot(2,2,3);plot(real(g2));title('Re[g2(t))]');
        %subplot(2,2,4);plot(imag(g2));title('Im[g2(t))]');
        %suptitle(['Iteration ' num2str(k) '']);
    %figure(3)
     %   plot(fn);title(['fn at iteration ' num2str(k) '']);
    pause
    %g = g2;
    %figure(1)
    
  end

ax = gca;
ax.Visible = 'off';