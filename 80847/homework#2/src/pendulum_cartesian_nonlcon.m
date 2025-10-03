function [ineq, cond] = pendulum_cartesian_nonlcon (q)
% constraints
% internal energy of simple pendulm (Cartesian)
    global length;
    x = q(1); y = q(2);
    R = sqrt(x^2+(y-length)^2)-length;
    ineq = [];	% inequalities
    cond = [R];	% equations
end
