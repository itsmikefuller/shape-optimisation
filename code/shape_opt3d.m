%Shape Optimisation example: find the shape
%\Omega^* \in \argmin_\Omega J(\Omega)=\int_\Omega f dx.

%Integrand, f
th = chebfun2(@(th,phi) th, [0 pi 0 2*pi]);
phi = chebfun2(@(th,phi) phi, [0 pi 0 2*pi]);
x = sin(th).*cos(phi);
y = sin(th).*sin(phi);
z = cos(th);
f = [x;y;z];
surf(f), camlight
quiver3(F(1),F(2),F(3),normal(F,'unit'),'numpts',10)
axis equal, hold off

