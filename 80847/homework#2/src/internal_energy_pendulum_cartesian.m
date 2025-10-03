function I = internal_energy_pendulum_cartesian (q)
% internal energy of simple pendulm (Cartesian)
    global mass; global grav;
    global fx; global fy;
    x = q(1); y = q(2);
    U = mass*grav*y;
    W = fx*x + fy*y;
    I = U - W;
end
