function dotq = simple_pendulum (t,q)
% equation of motion of simple pendulum
    global mass; global length; global grav;
    theta = q(1);
    omega = q(2);
    dottheta = omega;
    dotomega = 1/(mass*length*length)* ...
        (external_torque(t) - mass*grav*length*sin(theta));
    dotq = [dottheta; dotomega];
end
