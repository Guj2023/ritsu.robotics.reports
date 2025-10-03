% solve the equation of motion of simple pendulum

global mass; global length; global grav;
mass = 0.01; length = 2.0; grav = 9.8;

interval = [0, 10];
qinit = [pi/3; 0]; % [ theta(0); omega(0) ]
[time, q] = ode45(@simple_pendulum, interval, qinit);

% time - theta
plot(time, q(:,1));
saveas(gcf, 'simple_pendulum_theta.png');

% time - omega
plot(time, q(:,2));
saveas(gcf, 'simple_pendulum_omega.png');

% phase plot
plot(q(:,1), q(:,2));
saveas(gcf, 'simple_pendulum_phase.png');
