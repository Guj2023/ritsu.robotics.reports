% minimizing internal energy (Cartesian)

global mass; global length; global grav;
global fx; global fy;

mass = 0.01; length = 2.0; grav = 9.8;
fx = 0.1; fy = 0.2;

qinit = [0;0];
[qmin, Imin] = fmincon(@internal_energy_pendulum_cartesian, qinit, ...
                       [],[], [],[], [],[], @pendulum_cartesian_nonlcon);
qmin
Imin
