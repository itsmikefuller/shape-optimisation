r = @(t) 0.6*cos(t) + 1i*sin(t);
t = linspace(0,2*pi);
r1 = chebfun(@(t) r(t), [0,2*pi], 'trig');

plot(r1)

hold on

r2=2*r1-3;

plot(r2)