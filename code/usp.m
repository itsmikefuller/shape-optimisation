r = @(t) 0.1+1.2i + 0.6*cos(t) + 1.05*1i*sin(t);
t = linspace(0,2*pi);
r1 = chebfun(@(t) r(t), [0, 2*pi], 'trig');
r2 = 2*r1;
r3 = r2-[1+0i];
figure
t1=plot(r1)
hold on
t2=plot(r2);t3= plot(r3)
set(t1,'LineWidth',2);
set(t2,'LineWidth',2);
set(t3,'LineWidth',2);
legend('r1','r2','r3')
axis equal


