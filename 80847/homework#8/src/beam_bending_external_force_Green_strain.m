% g, cm, sec

addpath('../two_dim_fea');

m = 11; n = 3;
thickness = 1;
[ points, triangles ] = rectangular_object( m, n, 10, 2 );

% E = 0.1 MPa; c = 0.004 kPa s; rho = 0.020 g/cm^3
Young = 1.0*1e+6; c = 0.04*1e+3; nu = 0.48; density = 0.020;

[ lambda, mu ] = Lame_constants( Young, nu );
[lambda_vis, mu_vis] = Lame_constants(c, nu);

npoints = size(points,2);
ntriangles = size(triangles,1);
elastic = Body(npoints, points, ntriangles, triangles, thickness);
elastic = elastic.mechanical_parameters(density, lambda, mu);
elastic = elastic.viscous_parameters(lambda_vis, mu_vis);
elastic = elastic.calculate_stiffness_matrix;
elastic = elastic.calculate_damping_matrix;
elastic = elastic.calculate_inertia_matrix;

alpha = 1e+6;
A = elastic.constraint_matrix([1,12,23]);
b0 = zeros(2*3,1);
b1 = zeros(2*3,1);

tp = 0.05;
tf = 0.95;
fpush = -0.8*1e+5;
        
% external force
interval = [0,tp];
qinit = zeros(4*npoints,1);
external = zeros(2*npoints,1);
external(22*2) = fpush;
beam_bending_external_force = @(t,q) beam_bending_external_force_param_Green_strain(t,q, elastic, A,b0,b1, external, alpha);
[time_push, q_push] = ode15s(beam_bending_external_force, interval, qinit);
%[time_push, q_push] = ode45(beam_bending_external_force, interval, qinit);

% free
interval = [tp, tp+tf];
qinit = q_push(end,:);
external = zeros(2*npoints,1);
beam_bending_external_force = @(t,q) beam_bending_external_force_param_Green_strain(t,q, elastic, A,b0,b1, external, alpha);
[time_free, q_free] = ode15s(beam_bending_external_force, interval, qinit);

time = [time_push; time_free];
q = [q_push; q_free];

figure('position', [0, 0, 900, 1200]);
set(0,'defaultAxesFontSize',32);
set(0,'defaultTextFontSize',32);
clf;
for t = 0:0.05:tp+tf
    fprintf("time %f\n", t);
    index = nearest_index(time, t);
    disps = reshape(q(index,1:npoints*2), [2,npoints]);
    elastic.draw(disps);
    hold off;
    xlim([0,12]);
    ylim([-8,8]);
%    xticks([-10:10:40]);
%    yticks([-10:10:40]);
    pbaspect([3 4 1]);
    grid on;
    filename = strcat('beam_bending_external_force_Green_strain/deform_', num2str(floor(1000*t),'%04d'), '.png');
    saveas(gcf, filename, 'png');
end

clf('reset');
ts = time(1);
te = time(end);
fr = 1;
clear M;
for t = 0:0.01:tp+tf
    index = nearest_index(time, t);
    disps = reshape(q(index,1:npoints*2), [2,npoints]);
    elastic.draw(disps);
    hold off;
    xlim([0,12]);
    ylim([-8,8]);
%    xticks([-10:10:40]);
%    yticks([-10:10:40]);
    pbaspect([3 4 1]);
    title(['time ' num2str(t,"%3.2f")]);
    grid on;
    drawnow;
    M(fr) = getframe(gcf);
    fr = fr + 1;
    disp(t);
end
M(fr) = getframe(gcf);

v = VideoWriter('beam_bending_external_force_Green_strain', 'MPEG-4');
open(v);
writeVideo(v, M);
close(v);

function dotq = beam_bending_external_force_param_Green_strain(t,q, body, A,b0,b1, external, alpha)
    disp(t);
    
    persistent npoints M B K;
    if isempty(npoints)
        npoints = body.numNodalPoints;
        M = body.Inertia_Matrix;
        B = body.Damping_Matrix;
        K = body.Stiffness_Matrix;
    end
    
    un = q(1:2*npoints);
    vn = q(2*npoints+1:4*npoints);
    
    dotun = vn;
    
    coef = [ M, -A; -A', zeros(size(A,2),size(A,2))];
    forces = body.nodal_forces_Green_strain(reshape(un, [2,npoints]));
    vec = [ forces-B*vn+external; 2*alpha*(A'*vn-b1)+(alpha^2)*(A'*un-(b0+b1*t)) ];
    sol = coef\vec;
    dotvn = sol(1:2*npoints);
    
    dotq = [dotun; dotvn];
end
