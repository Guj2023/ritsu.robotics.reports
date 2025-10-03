% solve the equation of motion of simple pendulum (Cartesian)

global mass; global length; global grav;
mass = 0.01; length = 2.0; grav = 9.8;
global alpha;
alpha = 1000;
global viscous_coeiff
viscous_coeiff = 0.01;


interval = [0, 10];
qinit = [length*sin(pi/3); length*(1-cos(pi/3)); 0; 0];
[time, q] = ode45(@pendulum_cartesian, interval, qinit);

% time - x and y
plot(time,q(:,1),'-', time,q(:,2),'--');
saveas(gcf, 'pendulum_Cartesian_x_y.png');

% time - vx and vy
plot(time,q(:,3),'-', time,q(:,4),'--');
saveas(gcf, 'pendulum_Cartesian_vx_vy.png');

% x - y
plot(q(:,1), q(:,2));
saveas(gcf, 'pendulum_Cartesian_path.png');

% computed pendulum angle
angle = atan2(q(:,1), length-q(:,2));
plot(time, angle);
saveas(gcf, 'pendulum_Cartesian_computed_angle.png');

% constraint
R = sqrt(q(:,1).^2 + (q(:,2)-length).^2)-length;
plot(time, R);
saveas(gcf, 'pendulum_Cartesian_R.png');
