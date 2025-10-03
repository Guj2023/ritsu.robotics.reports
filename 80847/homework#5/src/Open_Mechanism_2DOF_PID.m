% PID control of 2DOF open mechanism

len = 2.00; radius = 0.05; density = 1;
link1 = Link_Cylinder ( len, radius, density );
link2 = Link_Cylinder ( len, radius, density );
base = [0; 0];
grav = [0; -9.8];
robot = Open_Mechanism_Two_DOF (link1, link2, base, grav);

thetad = [ pi/3; pi/6 ];
Kp = [ 2.5; 2.5 ];
Kd = [ 0.8; 0.8 ];
Ki = [ 0.5; 0.5 ];
open_mechanism_2DOF_PID_ode = @(t,q) open_mechanism_2DOF_PID_params (t, q, robot, thetad, Kp,Ki, Kd);

interval = [ 0, 10 ];
thetainit = [ 0; 0 ]; omegainit = [ 0; 0 ]; errorinit = [ 0; 0 ];
qinit = [thetainit; omegainit; errorinit];
[time, q] = ode45(open_mechanism_2DOF_PID_ode, interval, qinit);

thetad1 = thetad(1)*ones(size(time));
thetad2 = thetad(2)*ones(size(time));
plot(time, q(:,1), 'r-', time, q(:,2), 'b-', ...
     time, thetad1, 'r--', time, thetad2, 'b--');
grid on;
saveas(gcf, '/Users/jun/Documents/80847/homework#3/assets/open_mechanism_2DOF_PID_angles.png');

pause(1);

clf;
sz = size(time);
for k=1:1:sz(1)
    theta = q(k,1:2);
    omega = q(k,3:4);
    robot = robot.joint_angles (theta, omega);
    robot.draw;
    xlim([-5,5]);
    ylim([ 0,5]);
    pbaspect([2 1 1]);
    grid on;
    pause(0.01);
end
fprintf("pause: press any key\n");
pause(1);

clf;
hold on;
for k=1:1:sz(1)
    theta = q(k,1:2);
    omega = q(k,3:4);
    robot = robot.joint_angles (theta, omega);
    robot.draw;
    xlim([-5,5]);
    ylim([ 0,5]);
    pbaspect([2 1 1]);
    grid on;
    pause(0.01);
end
hold off;
saveas(gcf, '/Users/jun/Documents/80847/homework#3/assets/open_mechanism_2DOF_PID_draw.png');

clf('reset');
ts = time(1);
te = time(end);
fr = 1;
clear M;
for t = ts:0.01:te
    clf;
    k = nearest_index(time, t);
    theta = q(k,1:2);
    omega = q(k,3:4);
    robot = robot.joint_angles (theta, omega);
    robot.draw;
    xlim([-5,5]);
    ylim([ 0,5]);
    pbaspect([2 1 1]);
    title(['time ' num2str(t,"%3.2f")]);
    grid on;
    M(fr) = getframe(gcf);
    fr = fr + 1;
end
M(fr) = getframe(gcf);

v = VideoWriter('/Users/jun/Documents/80847/homework#3/assets/open_mechanism_2DOF_PID_draw', 'MPEG-4');
open(v);
writeVideo(v, M);
close(v);
