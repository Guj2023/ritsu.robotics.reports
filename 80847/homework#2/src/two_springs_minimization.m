% minimizing internal energy

global k1;
global k2;
global fext;

k1 = 5;
k2 = 2;
fext = 1;

qinit = [0;0];
[qmin, fmin] = fminsearch(@internal_energy_two_springs, qinit);
fprintf("internal energy\n");
fmin
fprintf("displacements\n");
qmin


x1 = qmin(1);
x2 = qmin(2);
f1 = -k1*x1 - k2*(x1-x2);
f2 = -k2*(x2-x1) + fext;
fprintf("forces\n");
f1
f2

k = k1*k2/(k1+k2);  % equivalent spring constnt
fprintf("displacements (analytical solution)\n");
[ fext/k1; fext/k ]
